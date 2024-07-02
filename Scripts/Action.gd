class_name Action
func execute(board_state : BoardState) -> BoardState:
	return board_state
func get_notation() -> String:
	return ""
func from_notation(board_state : BoardState, notation : String) -> Action:
	return Action.new()
