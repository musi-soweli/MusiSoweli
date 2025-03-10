class_name Kala extends GamePiece

func _init(_position: BoardSpace, _owner: int):
	name = "kala"
	symbol = "K"
	position = _position
	owner = _owner
	textures = []
	for i in range(4):
		var t = AtlasTexture.new()
		t.atlas = GamePiece.TEXTURE
		t.region = Rect2(500, 100+i*100, 100, 100)
		textures.append(t)
	aquatic = true

func get_name():
	return name + " " + COLORS[owner]

func get_description():
	return "fish piece. moves and captures one space in any direction"

func get_potential_moves(current_turn: int, carry: bool) -> Array[Action]:
	var moves: Array[Action] = []
	if current_turn != owner:
		return moves
	add_moves_from_spaces(position.get_adjacent_spaces(1), carry, true, true, moves)
	add_moves_from_spaces(position.get_diagonal_spaces(1), carry, true, true, moves)
	return moves
func get_copy(board_space: BoardSpace) -> GamePiece:
	return Kala.new(board_space, owner)

func get_flipped() -> GamePiece:
	return Akesi.new(position, owner)
