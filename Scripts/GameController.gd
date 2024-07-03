extends Control

var current_state : BoardState
func _ready():
	current_state = BoardState.get_starting_board_state()
	$BoardDisplay.populate_grid(current_state)
	var home_row_types : Array[SpaceType] = [SpaceType.LOJE, SpaceType.LOJE, SpaceType.TOMO_LOJE, SpaceType.LOJE, SpaceType.LOJE]
	$PieceSelectionDisplay.display_pieces(current_state.unused_pieces[0], 5, home_row_types, Callable(self, "on_loje_pieces_selected"))
func on_loje_pieces_selected(pieces : Array[GamePiece]):
	for i in range(len(pieces)):
		current_state.spaces[6][2+i].pieces.append(pieces[i])
		pieces[i].position = current_state.spaces[6][2+i]
	$BoardDisplay.update_grid(current_state)
	var home_row_types : Array[SpaceType] = [SpaceType.PIMEJA, SpaceType.PIMEJA, SpaceType.TOMO_PIMEJA, SpaceType.PIMEJA, SpaceType.PIMEJA]
	$PieceSelectionDisplay.display_pieces(current_state.unused_pieces[1], 5, home_row_types, Callable(self, "on_pimeja_pieces_selected"))
func on_pimeja_pieces_selected(pieces : Array[GamePiece]):
	for i in range(len(pieces)):
		current_state.spaces[0][6-i].pieces.append(pieces[i])
		pieces[i].position = current_state.spaces[0][6-i]
	$BoardDisplay.moving = true
	$BoardDisplay.update_grid(current_state)
func on_board_display_move_selected(move : Action):
	current_state = move.execute(current_state)
	$BoardDisplay.update_grid(current_state)
func on_board_display_promotion(move : PromotionAction):
	$BoardDisplay.moving = false
	var ht : Array[SpaceType] = [move.kili.position.type]
	$PieceSelectionDisplay.display_pieces(current_state.unused_pieces[move.owner-1], 1, ht, Callable(self, "on_promotion_confirmed").bind(move))
func on_promotion_confirmed(pieces : Array[GamePiece], move : PromotionAction):
	move.new_piece = pieces[0]
	current_state = move.execute(current_state)
	$BoardDisplay.moving = true
	$BoardDisplay.update_grid(current_state)
