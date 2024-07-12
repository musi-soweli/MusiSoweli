extends Control
#TODO: Make this not bad. Probably a game class idk.
#TODO: Turning back to previous moves

enum {LASO, LOJE, PIMEJA, JELO, WALO}

var current_state: BoardState
var first_state: BoardState
var local: bool = true
var pov: int = LOJE

func _ready() -> void:
	current_state = BoardState.get_starting_board_state()
	first_state = current_state
	$BoardDisplay.local = local
	$BoardDisplay.pov = pov
	$BoardDisplay.populate_grid(current_state)
	update()

func load_notation (notation: String) -> void:
	current_state = BoardState.get_starting_board_state()
	current_state.apply_notation(notation)
	first_state = current_state
	$BoardDisplay.local = local
	$BoardDisplay.pov = pov
	$BoardDisplay.populate_grid(current_state)
	update()

func update() -> void:
	$PieceSelectionDisplay.disappear()
	if can_move():
		if current_state.turn == 0:
			if current_state.get_current_player() == LOJE:
				var home_row_types: Array[SpaceType] = [SpaceType.LOJE, SpaceType.LOJE, SpaceType.TOMO_LOJE, SpaceType.LOJE, SpaceType.LOJE]
				$PieceSelectionDisplay.display_pieces(current_state.get_unused_pieces_for_player(LOJE), 5, home_row_types, Callable(self, "on_loje_pieces_selected"), "select loje starting pieces")
			elif current_state.get_current_player() == PIMEJA:
				var home_row_types: Array[SpaceType] = [SpaceType.PIMEJA, SpaceType.PIMEJA, SpaceType.TOMO_PIMEJA, SpaceType.PIMEJA, SpaceType.PIMEJA]
				$PieceSelectionDisplay.display_pieces(current_state.get_unused_pieces_for_player(PIMEJA), 5, home_row_types, Callable(self, "on_pimeja_pieces_selected"), "select pimeja starting pieces")
		else:
			$InfoPanel/InfoDisplay/GameInfo/Label.text = "loje's turn" if current_state.get_current_player() == LOJE else "pimeja's turn"
			if not local and current_state.get_current_player() == pov:
					$InfoPanel/InfoDisplay/GameInfo/Label.text = "your turn"
	elif current_state.complete:
				var scores = current_state.get_scores()
				$InfoPanel/InfoDisplay/GameInfo/Label.text = "game over (" + str(scores[0]) + " - " + str(scores[1]) + ")"
	$BoardDisplay.update_grid(current_state)
	$BoardDisplay.can_move = can_move()
	$InfoPanel/InfoDisplay/GameInfo/PassButton.disabled = not can_move() or current_state.turn == 0
	$InfoPanel/InfoDisplay/GameInfo/ResignButton.disabled = not can_move()
	$InfoPanel/InfoDisplay/GameInfo/NextMoveButton.disabled = current_state.next_state == null
	$InfoPanel/InfoDisplay/GameInfo/PreviousMoveButton.disabled = current_state.previous_state == null
	$InfoPanel/InfoDisplay/SpaceInfo.visible = not $PieceSelectionDisplay.visible

func on_loje_pieces_selected(pieces: Array[GamePiece]) -> void:
	var selection = PieceSelectionAction.new(pieces, current_state.get_current_player())
	current_state.move = selection
	current_state = selection.execute(current_state).progress_turn()
	update()

func on_pimeja_pieces_selected(pieces: Array[GamePiece]) -> void:
	var selection = PieceSelectionAction.new(pieces, current_state.get_current_player())
	current_state.move = selection
	current_state = selection.execute(current_state).progress_turn()
	update()

func on_board_display_move_selected(move: Action) -> void:
	current_state.move = move
	current_state = move.execute(current_state).progress_turn().check_complete()
	update()

func on_board_display_promotion(move: PromotionAction) -> void:
	$BoardDisplay.can_move = false
	var ht: Array[SpaceType] = [move.kili.position.type]
	$PieceSelectionDisplay.display_pieces(current_state.get_unused_pieces_for_player(current_state.get_current_player()), 1, ht, Callable(self, "on_promotion_confirmed").bind(move), "select promotion or cancel", true)

func on_promotion_confirmed(pieces: Array[GamePiece], move: PromotionAction) -> void:
	move.new_piece = pieces[0]
	current_state.move = move
	current_state = move.execute(current_state).progress_turn().check_complete()
	update()

func on_piece_selection_display_cancelled() -> void:
	$BoardDisplay.can_move = can_move()

func on_pass_button_pressed() -> void:
	if can_move() and current_state.get_are_pieces_selected_for_player(current_state.get_current_player()):
		var move = PassAction.new()
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
	return (not current_state.complete) and (current_state.next_state == null or local)

func on_resign_button_pressed() -> void:
	print(get_notation())

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
		notation += str(scores[0]) + str(scores[1]) #TODO: Add parenthesis if player resigns
	return notation

func on_notation_button_pressed():
	current_state = current_state.apply_notation($InfoPanel/InfoDisplay/DevPanel/LineEdit.text)
	update()
