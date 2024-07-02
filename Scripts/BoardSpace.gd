class_name BoardSpace
var board_state : BoardState
var name : String
var type : SpaceType
var pieces : Array [GamePiece] = []
var light : bool
var row : int = 0
var column : int = 0
func _init(_board_state : BoardState, _name : String, _type : SpaceType, _light : bool, _row : int, _column : int):
	board_state = _board_state
	name = _name
	type = _type
	light = _light
	row = _row
	column = _column
func get_texture() -> Texture2D:
	return type.light_texture if light else type.dark_texture
func get_adjacent_spaces(distance : int = 1) -> Array[BoardSpace]:
	var spaces : Array[BoardSpace] = []
	if row > distance-1:
		spaces.append(board_state.spaces[row-distance][column])
	if row < len(board_state.spaces)-distance:
		spaces.append(board_state.spaces[row+distance][column])
	if column > distance-1:
		spaces.append(board_state.spaces[row][column-distance])
	if column < len(board_state.spaces[row])-distance:
		spaces.append(board_state.spaces[row][column+distance])
	return spaces
func get_space_relative(_row : int, _column : int) -> BoardSpace:
	if row + _row >= 0 and row + _row < len(board_state.spaces) and column + _column >= 0 and column + _column < len(board_state.spaces[row]):
		return board_state.spaces[row + _row][column + _column]
	return null
func get_diagonal_spaces(distance : int = 1) -> Array[BoardSpace]:
	var spaces : Array[BoardSpace] = []
	if row > distance-1 and column > distance-1:
		spaces.append(board_state.spaces[row-distance][column-distance])
	if row > distance-1 and column < len(board_state.spaces[row])-distance:
		spaces.append(board_state.spaces[row-distance][column+distance])
	if row < len(board_state.spaces)-distance and column > distance-1:
		spaces.append(board_state.spaces[row+distance][column-distance])
	if row < len(board_state.spaces)-distance and column < len(board_state.spaces[row])-distance:
		spaces.append(board_state.spaces[row+distance][column+distance])
	return spaces
func get_copy(_board_state) -> BoardSpace:
	var new_space = BoardSpace.new(_board_state, name, type, light, row, column)
	for piece in pieces:
		new_space.pieces.append(piece.get_copy(new_space))
	return new_space
func piece_num() -> int:
	return len(pieces)
