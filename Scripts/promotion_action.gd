class_name PromotionAction extends Action

var kili: Kili
var new_piece: GamePiece
var owner: int = 0

func _init(_kili):
	kili = _kili
	owner = kili.position.type.owner_signature

func execute(board_state: BoardState) -> BoardState:
	var new_state = BoardState.from(board_state)
	new_state.spaces[kili.position.row][kili.position.column].pieces[kili.position.pieces.find(kili)] = new_piece
	new_piece.position = new_state.spaces[kili.position.row][kili.position.column]
	return new_state

func get_notation() -> String:
	return BoardState.column_names[kili.position.column] + str(kili.position.row) + "=" + new_piece.symbol
