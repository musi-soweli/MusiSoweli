extends Control

var current_state: BoardState
var local: bool = true
var pov: int = 0

func _ready():
	current_state = BoardState.get_starting_board_state()
	$BoardDisplay.local = local
	$BoardDisplay.pov = pov
	$BoardDisplay.populate_grid(current_state)
	var home_row_types: Array[SpaceType] = [SpaceType.LOJE, SpaceType.LOJE, SpaceType.TOMO_LOJE, SpaceType.LOJE, SpaceType.LOJE]
	$PieceSelectionDisplay.display_pieces(current_state.unused_pieces[0], 5, home_row_types, Callable(self, "on_loje_pieces_selected"), "select loje starting pieces")

func on_loje_pieces_selected(pieces: Array[GamePiece]):
	var selection = PieceSelectionAction.new(pieces, current_state.orientation)
	current_state = selection.execute(current_state).progress_turn()
	$BoardDisplay.update_grid(current_state)
	var home_row_types: Array[SpaceType] = [SpaceType.PIMEJA, SpaceType.PIMEJA, SpaceType.TOMO_PIMEJA, SpaceType.PIMEJA, SpaceType.PIMEJA]
	$InfoPanel/InfoDisplay/SpaceInfo.hide()
	$PieceSelectionDisplay.display_pieces(current_state.unused_pieces[1], 5, home_row_types, Callable(self, "on_pimeja_pieces_selected"), "select pimeja starting pieces")

func on_pimeja_pieces_selected(pieces: Array[GamePiece]):
	var selection = PieceSelectionAction.new(pieces, current_state.orientation)
	current_state = selection.execute(current_state).progress_turn()
	$InfoPanel/InfoDisplay/SpaceInfo.show()
	$InfoPanel/InfoDisplay/GameInfo/Label.text = "loje's turn" if local else "your turn"

	if current_state.orientation != pov and not local:
		$InfoPanel/InfoDisplay/GameInfo/PassButton.hide()
	else:
		$InfoPanel/InfoDisplay/GameInfo/PassButton.show()

	$BoardDisplay.moving = true
	$BoardDisplay.update_grid(current_state)

func on_board_display_move_selected(move: Action):
	current_state = move.execute(current_state).progress_turn().check_complete()

	if current_state.complete:
		var scores = current_state.get_scores()
		$InfoPanel/InfoDisplay/GameInfo/Label.text = "game over (" + str(scores[0]) + " - " + str(scores[1]) + ")"
	else:
		$InfoPanel/InfoDisplay/GameInfo/Label.text = "loje's turn" if current_state.orientation == 0 else "pimeja's turn"
		if not local:
			if current_state.orientation == pov:
				$InfoPanel/InfoDisplay/GameInfo/Label.text = "your turn"
			else:
				$InfoPanel/InfoDisplay/GameInfo/PassButton.hide()
		else:
			$InfoPanel/InfoDisplay/GameInfo/PassButton.show()

	$BoardDisplay.update_grid(current_state)

func on_board_display_promotion(move: PromotionAction):
	$BoardDisplay.moving = false
	var ht: Array[SpaceType] = [move.kili.position.type]
	$InfoPanel/InfoDisplay/SpaceInfo.hide()
	$PieceSelectionDisplay.display_pieces(current_state.unused_pieces[move.owner - 1], 1, ht, Callable(self, "on_promotion_confirmed").bind(move), "select promotion or cancel", true)

func on_promotion_confirmed(pieces: Array[GamePiece], move: PromotionAction):
	move.new_piece = pieces[0]
	current_state = move.execute(current_state).progress_turn().check_complete()
	$BoardDisplay.moving = true
	$BoardDisplay.update_grid(current_state)
	$InfoPanel/InfoDisplay/SpaceInfo.show()

func on_piece_selection_display_cancelled():
	$BoardDisplay.moving = current_state.orientation == pov
	$InfoPanel/InfoDisplay/SpaceInfo.show()

func on_pass_button_pressed():
	if current_state.complete:
		$InfoPanel/InfoDisplay/GameInfo/PassButton.hide()
		var scores = current_state.get_scores()
		$InfoPanel/InfoDisplay/GameInfo/Label.text = "game over (" + str(scores[0]) + " - " + str(scores[1]) + ")"
	else:
		var move = PassAction.new()
		current_state = move.execute(current_state).progress_turn().check_complete()
		$BoardDisplay.moving = true
		$BoardDisplay.update_grid(current_state)
		if current_state.complete:
			$InfoPanel/InfoDisplay/GameInfo/PassButton.hide()
			var scores = current_state.get_scores()
			$InfoPanel/InfoDisplay/GameInfo/Label.text = "game over (" + str(scores[0]) + " - " + str(scores[1]) + ")"
