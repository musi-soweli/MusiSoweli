extends Control
#TODO: Make this not bad. Probably a game class idk.

enum {LASO, LOJE, PIMEJA, JELO, WALO}

static var player_names = ["neutral", "loje", "pimeja", "jelo", "walo"]

var current_state: BoardState
var first_state: BoardState
var local: bool = true
var pov: int = LOJE

func create(num_players: int, num_kili: int, _local: bool) -> void:
	var space_types = BoardState.default_space_types
	var starting_pieces = BoardState.default_starting_pieces
	if num_players == 3:
		space_types = BoardState.default_space_types_3
		starting_pieces = BoardState.default_starting_pieces_3
	elif num_players == 4:
		space_types = BoardState.default_space_types_4
		starting_pieces = BoardState.default_starting_pieces_4
	current_state = BoardState.new(num_players, num_kili, space_types, true, starting_pieces, "AASWW")
	first_state = current_state
	local = _local
	$BoardDisplay.local = local
	$BoardDisplay.pov = pov
	$BoardDisplay.populate_grid(current_state)
	update()

func load_notation (notation: String) -> void:
	current_state = BoardState.new()
	first_state = current_state
	current_state = current_state.apply_notation(notation)
	update()

func update() -> void:
	if local and current_state.next_state == null:
		pov = current_state.get_current_player()
		$BoardDisplay.pov = pov
	$PieceSelectionDisplay.disappear()
	if can_move():
		if current_state.turn == 0:
			$InfoPanel/InfoDisplay/GameInfo/Label.text = "0. "+player_names[current_state.get_current_player()]+" piece selection"
			var home_row_types: Array[SpaceType] = current_state.get_starting_position_types(current_state.get_current_player())
			$PieceSelectionDisplay.display_pieces(current_state.get_unused_pieces_for_player(current_state.get_current_player()), len(home_row_types), home_row_types, Callable(self, "on_pieces_selected"), "select "+player_names[current_state.get_current_player()]+" starting pieces")
		elif local:
			$InfoPanel/InfoDisplay/GameInfo/Label.text = str(current_state.turn) + ". " + player_names[current_state.get_current_player()] + "'s turn"
		else:
			$InfoPanel/InfoDisplay/GameInfo/Label.text = str(current_state.turn) + ". your turn"
	elif current_state.complete:
				var scores = current_state.get_scores()
				$InfoPanel/InfoDisplay/GameInfo/Label.text = "game over (" + str(scores[0]) + " - " + str(scores[1]) + ")"
	else:
		$InfoPanel/InfoDisplay/GameInfo/Label.text = str(current_state.turn) + ". " + player_names[current_state.get_current_player()] + "'s turn"
	$BoardDisplay.update_grid(current_state)
	$BoardDisplay.can_move = can_move()
	$InfoPanel/InfoDisplay/GameInfo/PassButton.disabled = not can_move() or current_state.turn == 0
	$InfoPanel/InfoDisplay/GameInfo/ResignButton.disabled = not can_move()
	$InfoPanel/InfoDisplay/GameInfo/NextMoveButton.disabled = current_state.next_state == null
	$InfoPanel/InfoDisplay/GameInfo/PreviousMoveButton.disabled = current_state.previous_state == null
	$InfoPanel/InfoDisplay/SpaceInfo.visible = not $PieceSelectionDisplay.visible

func on_pieces_selected(pieces: Array[GamePiece]) -> void:
	var p = ""
	for piece in pieces:
		p += piece.symbol#TODO: Piece Type Refactor
	var selection = PieceSelectionAction.new(current_state.get_current_player(), p)
	current_state.move = selection
	current_state = selection.execute(current_state).progress_turn()
	update()

func on_board_display_move_selected(move: Action) -> void:
	current_state.move = move
	current_state = move.execute(current_state).progress_turn().check_complete()
	update()

func on_board_display_promotion(move: PromotionAction) -> void:
	$BoardDisplay.can_move = false
	var ht: Array[SpaceType] = [current_state.spaces[move.column][move.row].type]
	$PieceSelectionDisplay.display_pieces(current_state.get_unused_pieces_for_player(current_state.get_current_player()), 1, ht, Callable(self, "on_promotion_confirmed").bind(move), "select promotion or cancel", true)

func on_promotion_confirmed(pieces: Array[GamePiece], move: PromotionAction) -> void:
	move.new_piece_type = pieces[0].symbol #TODO Piece Type Refactor
	current_state.move = move
	current_state = move.execute(current_state).progress_turn().check_complete()
	update()

func on_piece_selection_display_cancelled() -> void:
	$BoardDisplay.can_move = can_move()

func on_pass_button_pressed() -> void:
	if can_move() and current_state.has_player_selected_pieces(current_state.get_current_player()):
		var move = PassAction.new(current_state.get_current_player())
		current_state.move = move
		current_state = move.execute(current_state).progress_turn().check_complete()
		$BoardDisplay.update_grid(current_state)
		if current_state.complete:
			var scores = current_state.get_scores()
			$InfoPanel/InfoDisplay/GameInfo/Label.text = "game over (" + str(scores[0]) + " - " + str(scores[1]) + ")"

func on_previous_move_button_pressed() -> void:
	if current_state.previous_state != null:
		current_state = current_state.previous_state
		$BoardDisplay.hide_potential_moves()
		update()

func on_next_move_button_pressed() -> void:
	if current_state.next_state != null:
		current_state = current_state.next_state
		$BoardDisplay.hide_potential_moves()
		update()

func can_move() -> bool:
	return (not current_state.complete) and (current_state.next_state == null or local) and (current_state.get_current_player() == pov or local)

func on_resign_button_pressed() -> void:
	pass

func get_notation() -> String:
	var notation = ""
	if first_state.kili_amount != 4:
		notation += str(first_state.kili_amount)+" "
	var state : BoardState = first_state
	while not (state.complete or state.move == null or state.next_state == null):
		if state.current_player_num == 0:
			notation += str(state.turn) + ". "
		notation += state.move.get_notation()
		notation += " "
		state = state.next_state
	if state.complete:
		var scores = state.get_scores()
		notation += str(scores[0]) + "-" + str(scores[1]) #TODO: Add parenthesis if player resigns
	return notation

func on_notation_button_pressed():
	if $InfoPanel/InfoDisplay/DevPanel/LineEdit.text[0] == "0":
		current_state = BoardState.new()
		first_state = current_state
	current_state = current_state.apply_notation($InfoPanel/InfoDisplay/DevPanel/LineEdit.text)
	$InfoPanel/InfoDisplay/DevPanel/LineEdit.text = ""
	update()

func on_export_game_button_pressed():
	print("Game Notation:")
	print(get_notation())

func on_export_move_button_pressed():
	print("Previous Move Notation:")
	if current_state.previous_state != null:
		if current_state.previous_state.move != null:
			print(current_state.previous_state.move.get_notation())
		else:
			print("No previous move to export.")
	else:
		print("No previous move to export.")

func on_export_line_button_pressed():
	print("Previous Move Line Notation:")
	if current_state.previous_state != null:
		if current_state.previous_state.move != null:
			print(current_state.previous_state.move.get_line())
		else:
			print("No previous move to export.")
	else:
		print("No previous move to export.")

func on_toggle_local_button_pressed():
	local = not local
	$InfoPanel/InfoDisplay/DevPanel/ToggleLocalButton.text = "make not local" if local else "make local"
	$BoardDisplay.local = local
	$BoardDisplay.pov = pov
	update()

func on_line_button_pressed():
	if len($InfoPanel/InfoDisplay/DevPanel/LineEdit.text) > 0:
		current_state = current_state.apply_lines($InfoPanel/InfoDisplay/DevPanel/LineEdit.text.split("\n"))
		$InfoPanel/InfoDisplay/DevPanel/LineEdit.text = ""
		update()
