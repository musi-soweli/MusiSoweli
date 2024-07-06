class_name PieceSelectionAction extends Action

var pieces: Array[GamePiece]
var player: int

func _init(_pieces: Array[GamePiece], _player: int):
	pieces = _pieces
	player = _player

func execute(board_state: BoardState) -> BoardState:
	var new_state = BoardState.from(board_state)
	var n: Array[GamePiece] = []
	new_state.unused_pieces[player] = n

	if player == 0:
		for i in range(len(pieces)):
			var new_piece = pieces[i].get_copy(new_state.spaces[6][2 + i])
			new_state.spaces[6][2 + i].pieces.append(new_piece)
	elif player == 1:
		for i in range(len(pieces)):
			var new_piece = pieces[i].get_copy(new_state.spaces[0][6 - i])
			new_state.spaces[0][6 - i].pieces.append(new_piece)

	return new_state
