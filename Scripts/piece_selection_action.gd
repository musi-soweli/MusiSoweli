class_name PieceSelectionAction extends Action

enum {LASO, LOJE, PIMEJA, JELO, WALO}

static var LINE_NAME = "PLACE"

var pieces: String #TODO: Piece Type Refactor

func _init(_player: int, _pieces: String):
	pieces = _pieces
	player = _player

func execute(board_state: BoardState) -> BoardState:
	var new_state = board_state.get_copy()
	new_state.set_has_player_selected_pieces(player, true)
	var positions: Array[BoardSpace] = new_state.get_starting_positions(player)
	for i in range(len(pieces)):
		var new_piece = new_state.pop_unused_piece_from_notation(player, pieces[i]).get_copy(new_state.spaces[positions[i].row][positions[i].column])
		new_state.spaces[positions[i].row][positions[i].column].pieces.append(new_piece)
	
	for k in len(new_state.kasi_spaces):
		if len(new_state.kasi_spaces[k].pieces) == 0:
			if new_state.kili_amounts[k] > 0:
				new_state.kasi_spaces[k].pieces.append(Kili.new(new_state.kasi_spaces[k]))
				new_state.kili_amounts[k] -= 1

	return new_state

func get_notation() -> String:
	return pieces

func get_line() -> String:
	return LINE_NAME + " " + str(player) + " " + pieces
