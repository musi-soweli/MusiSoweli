class_name Kije extends GamePiece

var TEXTURE_LOJE: Texture2D = preload ("res://assets/kije_loje.png")
var TEXTURE_PIMEJA: Texture2D = preload ("res://assets/kije_pimeja.png")

func _init(_position: BoardSpace, _owner: int):
	name = "kijetesantakalu"
	symbol = "U"
	position = _position
	owner = _owner
	textures = [TEXTURE_LOJE, TEXTURE_PIMEJA]

func get_name():
	return name + " " + COLORS[owner]

func get_description():
	return "raccoon piece. moves and captures in an L shape"

func get_potential_moves(current_turn: int, carry: bool) -> Array[Action]:
	var moves: Array[Action] = []
	if current_turn != owner:
		return moves
	var spaces: Array[BoardSpace] = [position.get_space_relative(1, 2), position.get_space_relative( - 1, 2), position.get_space_relative(1, -2), position.get_space_relative( - 1, -2), position.get_space_relative(2, 1), position.get_space_relative( - 2, 1), position.get_space_relative(2, -1), position.get_space_relative( - 2, -1)]
	add_moves_from_spaces(spaces, carry, true, true, moves)
	return moves

func get_copy(board_space: BoardSpace) -> GamePiece:
	return Kije.new(board_space, owner)

func get_flipped() -> GamePiece:
	return Waso.new(position, owner)
