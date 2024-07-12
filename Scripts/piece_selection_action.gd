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
	
	for i in range(len(pieces)):
		var position = new_state.starting_positions[new_state.player_order.find(player)][i]
		var new_piece = pieces[i].get_copy(new_state.spaces[position.y][position.x])
		new_state.spaces[position.y][position.x].pieces.append(new_piece)

	return new_state

func get_notation() -> String:
	var s: String = ""
	for p in pieces:
		s += p.symbol
	return s
