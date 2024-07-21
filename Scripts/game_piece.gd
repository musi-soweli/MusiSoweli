class_name GamePiece

enum {LASO, LOJE, PIMEJA, JELO, WALO}

const COLORS: Array[String] = ["laso", "loje", "pimeja", "jelo", "walo"]

static var TEXTURE = preload("res://Assets/pieces.png")
static var TYPES: Dictionary = {
	"I": Kili,
	"P": Pipi,
	"W": Waso,
	"U": Kije,
	"A": Akesi,
	"K": Kala,
	"S": Soweli
}

var name: String
var symbol: String
var owner: int
var position: BoardSpace
var aquatic: bool = false
var textures: Array[Resource]

func get_texture():
	return textures[owner - 1]

func get_potential_moves(_current_turn: int, _carry: bool) -> Array[Action]:
	return []

func get_copy(_board_space: BoardSpace) -> GamePiece:
	return GamePiece.new()

func in_stack() -> bool:
	return len(position.pieces) > 1

func can_move_onto_space(space: BoardSpace) -> bool:
	if space == null:
		return false
	if space.piece_num() == 1:
		return space.pieces[0].owner == owner or space.pieces[0].owner == 0
	elif space.piece_num() == 0:
		if space.type == SpaceType.TELO:
			return aquatic
		else:
			return true
	return false

func can_capture_onto_space(space: BoardSpace) -> bool:
	if space == null:
		return false
	if space.piece_num() > 0 and space.pieces[- 1].owner > 0 and space.pieces[- 1].owner != owner:
		if space.type == SpaceType.TELO:
			return aquatic or space.piece_num() > 1
		else:
			return true
	else:
		return false

func get_flipped() -> GamePiece:
	return self.get_copy(position)

func add_moves_from_spaces(spaces : Array[BoardSpace], carry : bool, move : bool, capture : bool, moves : Array[Action]):
	for pos: BoardSpace in spaces:
		if move and can_move_onto_space(pos):
			if carry:
				if len(position.pieces) > 1 and len(pos.pieces) == 0:
					moves.append(MovementAction.new(owner, position.row, position.column, pos.row, pos.column, true, false))
			else:
				moves.append(MovementAction.new(owner, position.row, position.column, pos.row, pos.column, false, false))
		elif capture and can_capture_onto_space(pos):
			if carry:
				if len(position.pieces) > 1 and len(pos.pieces) == 1:
					moves.append(MovementAction.new(owner, position.row, position.column, pos.row, pos.column, true, true))
			else:
				moves.append(MovementAction.new(owner, position.row, position.column, pos.row, pos.column, false, true))

static func from_notation(_notation: String, _position: BoardSpace, _owner: int) -> GamePiece:
	return TYPES[_notation].new(_position, _owner)
