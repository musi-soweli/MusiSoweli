class_name PieceSelectionAction extends Action

enum {LASO, LOJE, PIMEJA, JELO, WALO}

var pieces: Array[GamePiece]
var player: int

func _init(_pieces: Array[GamePiece], _player: int):
	pieces = _pieces
	player = _player

func execute(board_state: BoardState) -> BoardState:
	var new_state = BoardState.from(board_state)
	var n: Array[GamePiece] = []
	new_state.set_unused_pieces_for_player(player, n)
	new_state.set_has_player_selected_pieces(player, true)
	#TODO: Multiplayer compatibility
	if player == LOJE:
		for i in range(len(pieces)):
			var new_piece = pieces[i].get_copy(new_state.spaces[6][2 + i])
			new_state.spaces[6][2 + i].pieces.append(new_piece)
	elif player == PIMEJA:
		for i in range(len(pieces)):
			var new_piece = pieces[i].get_copy(new_state.spaces[0][6 - i])
			new_state.spaces[0][6 - i].pieces.append(new_piece)

	return new_state

func get_notation() -> String:
	var s: String = ""
	for p in pieces:
		s += p.symbol
	return s
