class_name PromotionAction extends Action

static var LINE_NAME = "PROMOTE"

var row: int
var column: int
var new_piece_type: String#TODO: Piece Type Refactor

func _init(_player: int, _row: int, _column: int, _new_piece_type: String = ""):
	player = _player
	row = _row
	column = _column
	new_piece_type = _new_piece_type

func execute(board_state: BoardState) -> BoardState:
	var new_state: BoardState = board_state.get_copy()
	var new_piece: GamePiece = board_state.pop_unused_piece_from_notation(player, new_piece_type)
	new_state.spaces[row][column].pieces[0] = new_piece
	new_piece.position = new_state.spaces[row][column]
	return new_state

func get_notation() -> String:
	return BoardState.column_names[column] + str(7-row) + "=" + new_piece_type

func get_line() -> String:
	return LINE_NAME + " " + str(player) + " " + str(row) + " " + str(column) + " " + new_piece_type
