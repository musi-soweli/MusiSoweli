class_name PassAction extends Action

static var LINE_NAME = "PASS"

func get_notation() -> String:
	return "Pass"

func execute(board_state: BoardState) -> BoardState:
	var n: BoardState = board_state.get_copy()
	n.passes += 1
	return n

func get_line() -> String:
	return LINE_NAME + " " + player
