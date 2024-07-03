class_name Akesi extends GamePiece
var LOJE : Texture2D = preload("res://Assets/akesi_loje.png")
var PIMEJA : Texture2D = preload("res://Assets/akesi_pimeja.png")
func _init(_position : BoardSpace, _owner : int):
	name = "akesi"
	symbol = "A"
	position = _position
	owner = _owner
	textures = [LOJE, PIMEJA]
	aquatic = true
func get_name():
	return name + " " + COLORS[owner]
func get_description():
	return "frog piece. moves and captures one space diagonally and two spaces orthogonally"
func get_potential_moves(current_turn : int, carry : bool) -> Array [Action]:
	var moves : Array [Action] = []
	if current_turn != owner:
		return moves
	for pos : BoardSpace in position.get_adjacent_spaces(2):
		if can_move_onto_space(pos):
			if carry:
				if len(position.pieces) > 1 and len(pos.pieces) == 0:
					moves.append(MovementAction.new(position, pos, true, false))
			else:
				moves.append(MovementAction.new(position, pos, false, false))
		if can_capture_onto_space(pos):
			if carry:
				if len(position.pieces) > 1 and len(pos.pieces) == 1:
					moves.append(MovementAction.new(position, pos, true, true))
			else:
				moves.append(MovementAction.new(position, pos, false, true))
	for pos : BoardSpace in position.get_diagonal_spaces(1):
		if can_capture_onto_space(pos):
			if carry:
				if len(position.pieces) > 1 and len(pos.pieces) == 1:
					moves.append(MovementAction.new(position, pos, true, true))
			else:
				moves.append(MovementAction.new(position, pos, false, true))
		if can_move_onto_space(pos):
			if carry:
				if len(position.pieces) > 1 and len(pos.pieces) == 0:
					moves.append(MovementAction.new(position, pos, true, false))
			else:
				moves.append(MovementAction.new(position, pos, false, false))
	return moves
func get_copy(board_space : BoardSpace) -> GamePiece:
	return Akesi.new(board_space, owner)
func get_flipped() -> GamePiece:
	return Kala.new(position, owner)
