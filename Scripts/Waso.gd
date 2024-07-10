class_name Waso extends GamePiece

var LOJE: Texture2D = preload ("res://Assets/waso_loje.png")
var PIMEJA: Texture2D = preload ("res://Assets/waso_pimeja.png")

func _init(_position: BoardSpace, _owner: int):
	name = "waso"
	symbol = "W"
	position = _position
	owner = _owner
	textures = [LOJE, PIMEJA]

func get_name():
	return name + " " + COLORS[owner]

func get_description():
	return "bird piece. moves and captures up to two spaces diagonally"

func get_potential_moves(current_turn: int, carry: bool) -> Array[Action]:
	var moves: Array[Action] = []

	if current_turn != owner:
		return moves

	add_moves_from_spaces(position.get_diagonal_spaces(1), carry, true, true, moves)
	add_moves_from_spaces(position.get_diagonal_spaces(2), carry, true, true, moves)
	return moves

func get_copy(board_space: BoardSpace) -> GamePiece:
	return Waso.new(board_space, owner)

func get_flipped() -> GamePiece:
	return Kije.new(position, owner)
