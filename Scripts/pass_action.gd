class_name PassAction extends Action

func get_notation() -> String:
	return "Pass"

func execute(board_state: BoardState) -> BoardState:
	var n: BoardState = BoardState.from(board_state)
	n.passes += 1
	return n
