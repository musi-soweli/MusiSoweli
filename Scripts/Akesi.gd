class_name Akesi extends GamePiece

var TEXTURE_LOJE: Texture2D = preload ("res://assets/akesi_loje.png")
var TEXTURE_PIMEJA: Texture2D = preload ("res://assets/akesi_pimeja.png")

func _init(_position: BoardSpace, _owner: int):
	name = "akesi"
	symbol = "A"
	position = _position
	owner = _owner
	textures = [TEXTURE_LOJE, TEXTURE_PIMEJA]
	aquatic = true

func get_name():
	return name + " " + COLORS[owner]

func get_description():
	return "frog piece. moves and captures one space diagonally and two spaces orthogonally"
func get_potential_moves(current_turn: int, carry: bool) -> Array[Action]:
	var moves: Array[Action] = []
	if current_turn != owner:
		return moves
	add_moves_from_spaces(position.get_adjacent_spaces(2), carry, true, true, moves)
	add_moves_from_spaces(position.get_diagonal_spaces(1), carry, true, true, moves)
	return moves

func get_copy(board_space: BoardSpace) -> GamePiece:
	return Akesi.new(board_space, owner)

func get_flipped() -> GamePiece:
	return Kala.new(position, owner)
