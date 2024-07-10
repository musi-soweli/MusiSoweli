class_name MovementAction extends Action

var old_position: BoardSpace
var new_position: BoardSpace
var carries: bool = false
var captures: bool = false

func _init(_old_position: BoardSpace, _new_position: BoardSpace, _carries: bool, _captures):
	old_position = _old_position
	new_position = _new_position
	carries = _carries
	captures = _captures

func execute(board_state: BoardState) -> BoardState:
	var new_state : BoardState = BoardState.from(board_state)

	if captures:
		var captured_piece : GamePiece = new_state.spaces[new_position.row][new_position.column].pieces.pop_back()
		captured_piece.position = null
		new_state.add_unused_piece_for_player(captured_piece.owner, captured_piece)

	var top_piece : GamePiece = new_state.spaces[old_position.row][old_position.column].pieces.pop_back()
	top_piece.position = new_state.spaces[new_position.row][new_position.column]

	if carries:
		var carried : GamePiece = new_state.spaces[old_position.row][old_position.column].pieces.pop_back()
		new_state.spaces[new_position.row][new_position.column].pieces.append(carried)
		carried.position = new_state.spaces[new_position.row][new_position.column]

	new_state.spaces[new_position.row][new_position.column].pieces.append(top_piece)

	for k in len(new_state.kasi_spaces):
		if len(new_state.kasi_spaces[k].pieces) == 0:
			if new_state.kili_amounts[k] > 0:
				new_state.kasi_spaces[k].pieces.append(Kili.new(new_state.kasi_spaces[k]))
				new_state.kili_amounts[k] -= 1

	return new_state
