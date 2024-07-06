class_name BoardState

var spaces: Array
var kasi_spaces: Array[BoardSpace] = []
var kili_amounts: Array[int] = []
var unused_pieces: Array = []
var complete: bool = false
var orientation: int
var turn: int
var passes: int = 0
var num_players: int = 2

@export var kili_amount: int = 1

# TODO: Don't hardcode this
static var default_types = [[SpaceType.TELO, SpaceType.TELO, SpaceType.PIMEJA, SpaceType.PIMEJA, SpaceType.TOMO_PIMEJA, SpaceType.PIMEJA, SpaceType.PIMEJA, SpaceType.TELO, SpaceType.TELO],
	[SpaceType.TELO, SpaceType.TELO, SpaceType.PIMEJA, SpaceType.PIMEJA, SpaceType.PIMEJA, SpaceType.PIMEJA, SpaceType.PIMEJA, SpaceType.TELO, SpaceType.TELO],
	[SpaceType.OPEN, SpaceType.OPEN, SpaceType.OPEN, SpaceType.OPEN, SpaceType.OPEN, SpaceType.OPEN, SpaceType.OPEN, SpaceType.OPEN, SpaceType.OPEN],
	[SpaceType.OPEN, SpaceType.KASI, SpaceType.OPEN, SpaceType.TELO, SpaceType.TELO, SpaceType.TELO, SpaceType.OPEN, SpaceType.KASI, SpaceType.OPEN],
	[SpaceType.OPEN, SpaceType.OPEN, SpaceType.OPEN, SpaceType.OPEN, SpaceType.OPEN, SpaceType.OPEN, SpaceType.OPEN, SpaceType.OPEN, SpaceType.OPEN],
	[SpaceType.TELO, SpaceType.TELO, SpaceType.LOJE, SpaceType.LOJE, SpaceType.LOJE, SpaceType.LOJE, SpaceType.LOJE, SpaceType.TELO, SpaceType.TELO],
	[SpaceType.TELO, SpaceType.TELO, SpaceType.LOJE, SpaceType.LOJE, SpaceType.TOMO_LOJE, SpaceType.LOJE, SpaceType.LOJE, SpaceType.TELO, SpaceType.TELO]]
static var column_names = ["m", "n", "p", "t", "k", "s", "w", "l", "j"]

func _init(_orientation: int, _turn: int):
	orientation = _orientation
	turn = _turn

func progress_turn() -> BoardState:
	orientation += 1
	if orientation >= num_players:
		orientation = 0
		turn += 1
	return self

func check_complete() -> BoardState:
	if passes > num_players:
		complete = true
		return self

	for k in kili_amounts:
		if k > 0:
			return self

	for kasi_space in kasi_spaces:
		if kasi_space.piece_num() > 0 and kasi_space.pieces[0] is Kili:
			return self

	complete = true
	return self

func get_scores() -> Array[int]:
	var scores: Array[int] = [0, 0]

	for r in range(len(spaces)):
		for c in range(len(spaces[r])):
			if spaces[r][c].piece_num() > 0 and spaces[r][c].pieces[0] is Kili:
				if spaces[r][c].type == SpaceType.LOJE or spaces[r][c].type == SpaceType.TOMO_LOJE:
					scores[0] += 1
				elif spaces[r][c].type == SpaceType.PIMEJA or spaces[r][c].type == SpaceType.TOMO_PIMEJA:
					scores[1] += 1
				elif spaces[r][c].piece_num() > 1:
					scores[spaces[r][c].pieces[- 1].owner - 1] += 1
	return scores

static func get_starting_board_state() -> BoardState:
	var state = BoardState.new(0, 0)
	var new_spaces = []

	for r in range(0, 7):
		new_spaces.append([])

		for c in range(0, 9):
			var new_space = BoardSpace.new(state, column_names[c] + str(7 - r), default_types[r][c], (r * 9 + c) % 2 == 0, r, c)
			var pieces: Array[GamePiece] = []

			if r == 1 or r == 5:
				if c > 1 and c < 7:
					pieces = [Pipi.new(new_space, 2 if r == 1 else 1)]

			if default_types[r][c] == SpaceType.KASI:
				pieces = [Kili.new(new_space)]
				state.kili_amounts.append(state.kili_amount - 1)
				state.kasi_spaces.append(new_space)

			new_space.pieces = pieces
			new_spaces[r].append(new_space)

	state.spaces = new_spaces

	var p: Array[GamePiece] = [Akesi.new(null, 1), Akesi.new(null, 1), Soweli.new(null, 1), Waso.new(null, 1), Waso.new(null, 1)]
	state.unused_pieces.append(p)

	var p2: Array[GamePiece] = [Akesi.new(null, 2), Akesi.new(null, 2), Soweli.new(null, 2), Waso.new(null, 2), Waso.new(null, 2)]
	state.unused_pieces.append(p2)

	return state
static func from(board_state: BoardState) -> BoardState: # TODO: There has to be a better way of doing this with deep copies this feel so inefficient
	var new_board = BoardState.new(board_state.orientation, board_state.turn)
	new_board.spaces = []

	for r in range(len(board_state.spaces)):
		new_board.spaces.append([])
		for c in range(len(board_state.spaces[r])):
			new_board.spaces[r].append(board_state.spaces[r][c].get_copy(new_board))

	for k in range(len(board_state.kili_amounts)):
		new_board.kili_amounts.append(board_state.kili_amounts[k])
		var k_space = board_state.kasi_spaces[k]
		new_board.kasi_spaces.append(new_board.spaces[k_space.row][k_space.column])

	new_board.kili_amount = board_state.kili_amount

	for i in range(len(board_state.unused_pieces)):
		var n: Array[GamePiece] = []
		new_board.unused_pieces.append(n)

		for j in range(len(board_state.unused_pieces[i])):
			new_board.unused_pieces[i].append(board_state.unused_pieces[i][j].get_copy(null))

	new_board.complete = board_state.complete
	return new_board
