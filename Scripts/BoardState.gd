class_name BoardState
var spaces : Array
var orientation : int
var turn : int
static var default_types = [[SpaceType.TELO, SpaceType.TELO, SpaceType.PIMEJA, SpaceType.PIMEJA, SpaceType.TOMO_PIMEJA, SpaceType.PIMEJA, SpaceType.PIMEJA, SpaceType.TELO, SpaceType.TELO], 
	[SpaceType.TELO, SpaceType.TELO, SpaceType.PIMEJA, SpaceType.PIMEJA, SpaceType.PIMEJA, SpaceType.PIMEJA, SpaceType.PIMEJA, SpaceType.TELO, SpaceType.TELO], 
	[SpaceType.OPEN, SpaceType.OPEN, SpaceType.OPEN, SpaceType.OPEN, SpaceType.OPEN, SpaceType.OPEN, SpaceType.OPEN, SpaceType.OPEN, SpaceType.OPEN], 
	[SpaceType.OPEN, SpaceType.KASI, SpaceType.OPEN, SpaceType.OPEN, SpaceType.OPEN, SpaceType.OPEN, SpaceType.OPEN, SpaceType.KASI, SpaceType.OPEN], 
	[SpaceType.OPEN, SpaceType.OPEN, SpaceType.OPEN, SpaceType.OPEN, SpaceType.OPEN, SpaceType.OPEN, SpaceType.OPEN, SpaceType.OPEN, SpaceType.OPEN], 
	[SpaceType.TELO, SpaceType.TELO, SpaceType.LOJE, SpaceType.LOJE, SpaceType.LOJE, SpaceType.LOJE, SpaceType.LOJE, SpaceType.TELO, SpaceType.TELO], 
	[SpaceType.TELO, SpaceType.TELO, SpaceType.LOJE, SpaceType.LOJE, SpaceType.TOMO_LOJE, SpaceType.LOJE, SpaceType.LOJE, SpaceType.TELO, SpaceType.TELO]]
static var column_names = ["m", "n", "p", "t", "k", "s", "w", "l", "j"]
func _init(_orientation : int, _turn : int):
	orientation = _orientation
	turn = _turn

static func get_starting_board_state() -> BoardState:
	var state = BoardState.new(0, 0)
	var new_spaces = []
	for r in range(0, 7):
		new_spaces.append([])
		for c in range(0, 9):
			var new_space = BoardSpace.new(state, column_names[c]+str(7-r), default_types[r][c], (r*9 + c)%2 == 0, r, c)
			var pieces : Array [GamePiece] = []
			if r == 1 or r == 5:
				if c > 1 and c < 7:
					pieces = [Pipi.new(new_space, 2 if r == 1 else 1)]
			new_space.pieces = pieces
			new_spaces[r].append(new_space)
	state.spaces = new_spaces
	return state
static func from(board_state : BoardState) -> BoardState:
	var new_board = BoardState.new(board_state.orientation, board_state.turn)
	new_board.spaces = []
	for r in range(len(board_state.spaces)):
		new_board.spaces.append([])
		for c in range(len(board_state.spaces[r])):
			new_board.spaces[r].append(board_state.spaces[r][c].get_copy(new_board))
	return new_board
