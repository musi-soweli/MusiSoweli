class_name MovementAction extends Action
var old_position : BoardSpace
var new_position : BoardSpace
var can_carry : bool = false
var carries : bool = false
var captures : bool = false
func _init(_old_position : BoardSpace, _new_position : BoardSpace, _can_carry : bool, _captures):
	old_position = _old_position
	new_position = _new_position
	can_carry = _can_carry
	captures = _captures
func execute(board_state : BoardState) -> BoardState:
	var new_state = BoardState.from(board_state)
	if captures:
		new_state.spaces[new_position.row][new_position.column].pieces.pop_back()
	var top_piece = new_state.spaces[old_position.row][old_position.column].pieces.pop_back()
	top_piece.position = new_state.spaces[new_position.row][new_position.column]
	if carries:
		new_state.spaces[new_position.row][new_position.column].pieces.append(new_state.spaces[old_position.row][old_position.column].pieces.pop_back())
	new_state.spaces[new_position.row][new_position.column].pieces.append(top_piece)
	return new_state
