class_name PromotionAction extends Action

var kili: Kili
var new_piece: GamePiece
var owner: int = 0

func _init(_kili):
	kili = _kili
	if kili.position.type == SpaceType.TOMO_LOJE:
		owner = 1
	if kili.position.type == SpaceType.TOMO_PIMEJA:
		owner = 2

func execute(board_state: BoardState) -> BoardState:
	var new_state = BoardState.from(board_state)
	new_state.spaces[kili.position.row][kili.position.column].pieces[kili.position.pieces.find(kili)] = new_piece
	new_piece.position = new_state.spaces[kili.position.row][kili.position.column]
	return new_state
