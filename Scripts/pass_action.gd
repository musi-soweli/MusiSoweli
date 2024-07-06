class_name PassAction extends Action

func get_notation() -> String:
	return ""

func execute(board_state: BoardState) -> BoardState:
	board_state.passes += 1
	return board_state
