class_name Kala extends GamePiece
var LOJE : Texture2D = preload("res://Assets/kala_loje.png")
var PIMEJA : Texture2D = preload("res://Assets/kala_pimeja.png")
func _init(_position : BoardSpace, _owner : int):
	name = "kala"
	symbol = "K"
	position = _position
	owner = _owner
	textures = [LOJE, PIMEJA]
	aquatic = true
func get_name():
	return name + " " + COLORS[owner]
func get_description():
	return "fish piece. moves and captures one space in any direction"
func get_potential_moves(carry : bool) -> Array [Action]:
	var moves : Array [Action] = []
	for pos : BoardSpace in position.get_adjacent_spaces(1):
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
	return Kala.new(board_space, owner)
func get_flipped() -> GamePiece:
	return Akesi.new(position, owner)
