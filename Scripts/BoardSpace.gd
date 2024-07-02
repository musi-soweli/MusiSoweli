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
func get_adjacent_spaces() -> Array[BoardSpace]:
	var spaces : Array[BoardSpace] = []
	if row > 0:
		spaces.append(board_state.spaces[row-1][column])
	if row < len(board_state.spaces)-1:
		spaces.append(board_state.spaces[row+1][column])
	if column > 0:
		spaces.append(board_state.spaces[row][column-1])
	if column < len(board_state.spaces[row])-1:
		spaces.append(board_state.spaces[row][column+1])
	return spaces
func get_diagonal_spaces() -> Array[BoardSpace]:
	var spaces : Array[BoardSpace] = []
	if row > 0 and column > 0:
		spaces.append(board_state.spaces[row-1][column-1])
	if row > 0 and column < len(board_state.spaces[row])-1:
		spaces.append(board_state.spaces[row-1][column+1])
	if row < len(board_state.spaces)-1 and column > 0:
		spaces.append(board_state.spaces[row+1][column-1])
	if row < len(board_state.spaces)-1 and column < len(board_state.spaces[row])-1:
		spaces.append(board_state.spaces[row+1][column+1])
	return spaces
func get_copy(_board_state) -> BoardSpace:
	var new_space = BoardSpace.new(_board_state, name, type, light, row, column)
	for piece in pieces:
		new_space.pieces.append(piece.get_copy(new_space))
	return new_space
