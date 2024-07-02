class_name Kije extends GamePiece
var LOJE : Texture2D = preload("res://Assets/kije_loje.png")
var PIMEJA : Texture2D = preload("res://Assets/kije_pimeja.png")
func _init(_position : BoardSpace, _owner : int):
	name = "kijetesantakalu"
	symbol = "U"
	position = _position
	owner = _owner
	textures = [LOJE, PIMEJA]
func get_name():
	return name + " " + COLORS[owner]
func get_description():
	return "raccoon piece. moves and captures in an L shape"
func get_potential_moves() -> Array [Action]:
	var moves : Array [Action] = []
	var spaces : Array [BoardSpace] = [position.get_space_relative(1, 2), position.get_space_relative(-1, 2), position.get_space_relative(1, -2), position.get_space_relative(-1, -2), position.get_space_relative(2, 1), position.get_space_relative(-2, 1), position.get_space_relative(2, -1), position.get_space_relative(-2, -1)]
	for pos : BoardSpace in spaces:
		if pos != null:
			if can_move_onto_space(pos):
				moves.append(MovementAction.new(position, pos, len(position.pieces) > 1 and len(pos.pieces) == 0, false))
			if can_capture_onto_space(pos):
				moves.append(MovementAction.new(position, pos, len(position.pieces) > 1 and len(pos.pieces) == 1, true))
	return moves
func get_copy(board_space : BoardSpace) -> GamePiece:
	return Kije.new(board_space, owner)
func get_flipped() -> GamePiece:
	return Waso.new(position, owner)
