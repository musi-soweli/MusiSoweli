class_name MovementAction extends Action

static var LINE_NAME = "MOVE"

var old_row: int
var old_column: int
var new_row: int
var new_column: int
#var piece_symbol: String = ""
var carries: bool = false
var captures: bool = false

func _init(_player: int, _old_row: int, _old_column: int, _new_row: int, _new_column: int, _carries: bool, _captures: bool):
	player = _player
	old_row = _old_row
	old_column = _old_column
	#piece_symbol = old_position.pieces[-1].symbol
	new_row = _new_row
	new_column = _new_column
	carries = _carries
	captures = _captures

func execute(board_state: BoardState) -> BoardState:
	var new_state : BoardState = board_state.get_copy()

	if captures:
		var captured_piece : GamePiece = new_state.spaces[new_row][new_column].pieces.pop_back()
		captured_piece.position = null
		new_state.add_unused_piece_for_player(captured_piece.owner, captured_piece)

	var top_piece : GamePiece = new_state.spaces[old_row][old_column].pieces.pop_back()
	top_piece.position = new_state.spaces[new_row][new_column]

	if carries:
		var carried : GamePiece = new_state.spaces[old_row][old_column].pieces.pop_back()
		new_state.spaces[new_row][new_column].pieces.append(carried)
		carried.position = new_state.spaces[new_row][new_column]

	new_state.spaces[new_row][new_column].pieces.append(top_piece)

	for k in len(new_state.kasi_spaces):
		if len(new_state.kasi_spaces[k].pieces) == 0:
			if new_state.kili_amounts[k] > 0:
				new_state.kasi_spaces[k].pieces.append(Kili.new(new_state.kasi_spaces[k]))
				new_state.kili_amounts[k] -= 1

	return new_state

func get_notation() -> String: #TODO: change this and the decoder to be how notation actually works
	#var s : String = BoardState.column_names[old_position.column] + str(old_position.row) if piece_symbol == "P" else piece_symbol
	var s : String = BoardState.column_names[old_column] + str(7-old_row)
	s += "x" if captures else ""
	s += BoardState.column_names[new_column] + str(7-new_row)
	s += "+" if carries else ""
	#TODO: Add ^ if it carries
	return s

func get_line() -> String:
	return LINE_NAME + " " + str(player) + " " + str(old_row) + " " + str(old_column) + " " + str(new_row) + " " + str(new_column) + " " + ("1" if carries else "0") + " " + ("1" if captures else "0")
