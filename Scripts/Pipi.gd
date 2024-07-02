class_name Pipi extends GamePiece
var LOJE : Texture2D = preload("res://Assets/pipi_loje.png")
var PIMEJA : Texture2D = preload("res://Assets/pipi_pimeja.png")
func _init(_position : BoardSpace, _owner : int):
	name = "pipi"
	symbol = "P"
	position = _position
	owner = _owner
	textures = [LOJE, PIMEJA]
func get_name():
	return name + " " + COLORS[owner]
func get_description():
	return "bug piece. moves one space orthogonally and captures one space diagonally"
func get_potential_moves() -> Array [Action]:
	var moves : Array [Action] = []
	for pos : BoardSpace in position.get_adjacent_spaces():
		if len(pos.pieces) == 0 and not pos.type == SpaceType.TELO:
			moves.append(MovementAction.new(position, pos, len(position.pieces) > 1, false))
		if len(pos.pieces) == 1 and (pos.pieces[0].owner == owner or pos.pieces[0].owner == 0):
			moves.append(MovementAction.new(position, pos, false, false))
	for pos : BoardSpace in position.get_diagonal_spaces():
		if len(pos.pieces) > 0 and (len(pos.pieces) > 1 or not pos.type == SpaceType.TELO) and  (pos.pieces[-1].owner != owner and pos.pieces[-1].owner > 0):
			moves.append(MovementAction.new(position, pos, len(position.pieces) > 1 and len(pos.pieces) == 1, true))
	return moves
func get_copy(board_space : BoardSpace) -> GamePiece:
	return Pipi.new(board_space, owner)
