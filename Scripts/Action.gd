class_name Action

func execute(board_state: BoardState) -> BoardState:
	return board_state

func get_notation() -> String:
	return ""

func from_notation(_board_state: BoardState, _notation: String) -> Action:
	return Action.new()
