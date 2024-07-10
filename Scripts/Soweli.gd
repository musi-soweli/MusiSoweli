class_name Soweli extends GamePiece

var TEXTURE_LOJE: Texture2D = preload ("res://assets/soweli_loje.png")
var TEXTURE_PIMEJA: Texture2D = preload ("res://assets/soweli_pimeja.png")

func _init(_position: BoardSpace, _owner: int):
	name = "soweli"
	symbol = "S"
	position = _position
	owner = _owner
	textures = [TEXTURE_LOJE, TEXTURE_PIMEJA]

func get_name():
	return name + " " + COLORS[owner]

func get_description():
	return "bull piece. moves and captures in a straight line. cannot move over other pieces"

func get_potential_moves(current_turn: int, carry: bool) -> Array[Action]:
	var moves: Array[Action] = []

	if current_turn != owner:
		return moves

	var spaces: Array[BoardSpace] = position.get_adjacent_spaces()
	var check_spaces: Array[BoardSpace] = spaces.duplicate()

	for i in range(len(spaces)):
		var direction: Vector2 = Vector2(spaces[i].row - position.row, spaces[i].column - position.column)
		while true:
			if spaces[i].piece_num() != 0 or spaces[i].type == SpaceType.TELO:
				break
			if can_move_onto_space(spaces[i].get_space_relative(direction.x, direction.y)):
				spaces[i] = spaces[i].get_space_relative(direction.x, direction.y)
				check_spaces.append(spaces[i])
			else:
				check_spaces.append(spaces[i].get_space_relative(direction.x, direction.y)) # check one extra to see if you can capture
				break
	add_moves_from_spaces(check_spaces, carry, true, true, moves)
	return moves

func get_copy(board_space: BoardSpace) -> GamePiece:
	return Soweli.new(board_space, owner)
