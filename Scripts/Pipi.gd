class_name Pipi extends GamePiece

func _init(_position: BoardSpace, _owner: int):
	name = "pipi"
	symbol = "P"
	position = _position
	owner = _owner
	textures = []
	for i in range(4):
		var t = AtlasTexture.new()
		t.atlas = GamePiece.TEXTURE
		t.region = Rect2(0, 100+i*100, 100, 100)
		textures.append(t)

func get_name():
	return name + " " + COLORS[owner]

func get_description():
	return "bug piece. moves one space orthogonally and captures one space diagonally"

func get_potential_moves(current_turn: int, carry: bool) -> Array[Action]:
	var moves: Array[Action] = []
	if current_turn != owner:
		return moves
	add_moves_from_spaces(position.get_adjacent_spaces(1), carry, true, false, moves)
	add_moves_from_spaces(position.get_diagonal_spaces(1), carry, false, true, moves)
	return moves

func get_copy(board_space: BoardSpace) -> GamePiece:
	return Pipi.new(board_space, owner)
