class_name BoardState

enum {LASO, LOJE, PIMEJA, JELO, WALO}

var spaces: Array[Array]
var kasi_spaces: Array[BoardSpace] = []
var kili_amounts: Array[int] = []
var unused_pieces: Array[Array] = []
var complete: bool = false
var turn: int
var passes: int = 0
var player_order : Array[int] = [LOJE, PIMEJA]
var pieces_selected : Array[bool] = [false, false]
var current_player_num : int
var previous_state: BoardState = null
var next_state: BoardState = null#TODO: Might not wanna settle with this in the end
var move: Action

@export var kili_amount: int = 4

static var column_names = ["m", "n", "p", "t", "k", "s", "w", "l", "j"]

func _init(_current_player_num: int, _turn: int):
	current_player_num = _current_player_num
	turn = _turn

func progress_turn() -> BoardState:
	current_player_num += 1
	if current_player_num >= len(player_order):
		current_player_num = 0
		turn += 1
	return self

func check_complete() -> BoardState:
	if passes > len(player_order):
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
	var state : BoardState = BoardState.new(0, 0)
	var new_spaces : Array[Array] = []
	var default_types : Array[Array] = [[SpaceType.TELO, SpaceType.TELO, SpaceType.PIMEJA, SpaceType.PIMEJA, SpaceType.TOMO_PIMEJA, SpaceType.PIMEJA, SpaceType.PIMEJA, SpaceType.TELO, SpaceType.TELO],
	[SpaceType.TELO, SpaceType.TELO, SpaceType.PIMEJA, SpaceType.PIMEJA, SpaceType.PIMEJA, SpaceType.PIMEJA, SpaceType.PIMEJA, SpaceType.TELO, SpaceType.TELO],
	[SpaceType.OPEN, SpaceType.OPEN, SpaceType.OPEN, SpaceType.OPEN, SpaceType.OPEN, SpaceType.OPEN, SpaceType.OPEN, SpaceType.OPEN, SpaceType.OPEN],
	[SpaceType.OPEN, SpaceType.KASI, SpaceType.OPEN, SpaceType.TELO, SpaceType.TELO, SpaceType.TELO, SpaceType.OPEN, SpaceType.KASI, SpaceType.OPEN],
	[SpaceType.OPEN, SpaceType.OPEN, SpaceType.OPEN, SpaceType.OPEN, SpaceType.OPEN, SpaceType.OPEN, SpaceType.OPEN, SpaceType.OPEN, SpaceType.OPEN],
	[SpaceType.TELO, SpaceType.TELO, SpaceType.LOJE, SpaceType.LOJE, SpaceType.LOJE, SpaceType.LOJE, SpaceType.LOJE, SpaceType.TELO, SpaceType.TELO],
	[SpaceType.TELO, SpaceType.TELO, SpaceType.LOJE, SpaceType.LOJE, SpaceType.TOMO_LOJE, SpaceType.LOJE, SpaceType.LOJE, SpaceType.TELO, SpaceType.TELO]]

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

	var p: Array[GamePiece] = [Akesi.new(null, LOJE), Akesi.new(null, LOJE), Soweli.new(null, LOJE), Waso.new(null, LOJE), Waso.new(null, LOJE)]
	state.unused_pieces.append(p)

	var p2: Array[GamePiece] = [Akesi.new(null, PIMEJA), Akesi.new(null, PIMEJA), Soweli.new(null, PIMEJA), Waso.new(null, PIMEJA), Waso.new(null, PIMEJA)]
	state.unused_pieces.append(p2)

	return state

static func from(board_state: BoardState) -> BoardState: # TODO: There has to be a better way of doing this with deep copies this feel so inefficient
	var new_board = BoardState.new(board_state.current_player_num, board_state.turn)
	var a : Array[Array] = []
	new_board.spaces = a

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
	
	for i in range(len(board_state.pieces_selected)):
		new_board.pieces_selected[i] = board_state.pieces_selected[i]
	
	board_state.next_state = new_board
	new_board.previous_state = board_state
	new_board.complete = board_state.complete
	return new_board
#0. AASWW KKSUU
#0. AASWW ASAWW 1. w6k4 p0k2
func apply_notation(notation: String) -> BoardState:
	print(notation)
	if len(notation) == 0:
		return
	var slice : String = notation.get_slice(" ", 0)
	notation = notation.erase(0, len(slice)+1)
	print(slice)
	while slice.contains("."):
		slice = notation.get_slice(" ", 0) #Skip the numbers
		notation = notation.erase(0, len(slice)+1)
		print(slice)
	#TODO: Change movements to be the same as the official notation
	if slice.is_valid_int(): #Check if kili number is being specified
		kili_amount = int(slice)
		for k in kili_amounts:
			k = kili_amount
		slice = notation.get_slice(" ", 0) #If it is, change kili amounts and move on
		notation = notation.erase(0, len(slice)+1)
		print(slice)
	if slice == "Pass":
		move = PassAction.new()
	elif slice == slice.to_upper(): #Check if the section is all uppercase (Meaning it is a piece selection)
		var pieces : Array[GamePiece] = []
		for char in slice:
			pieces.append(pop_unused_piece_from_notation(get_current_player(), char))#TODO: Checking if this is null, throwing error
		print(pieces)
		move = PieceSelectionAction.new(pieces, get_current_player())
	elif slice.contains("="):#Check if the section contains = (Meaning it is a promotion)
		var kili: GamePiece = get_space_from_notation(slice.substr(0,2)).pieces[0]
		if kili is Kili:
			move = PromotionAction.new(kili)
			move.new_piece = pop_unused_piece_from_notation(get_current_player(), slice[-1])#TODO: Checking if this is null, throwing error
		#TODO: Throw error
	else:
		var old_pos: BoardSpace = get_space_from_notation(slice.substr(0, 2))#TODO: change this to be piece selection instead of position i guess
		slice = slice.erase(0, 2)
		var capture: bool = false
		if slice[0] == "x":
			capture = true
			slice = slice.erase(0, 1)
		var new_pos : BoardSpace = get_space_from_notation(slice.substr(0, 2))
		var carry: bool = false
		if slice[-1] == "+":
			carry = true
		move = MovementAction.new(old_pos, new_pos, carry, capture)#TODO: just checking for error and stuff
	if move != null:
		next_state = move.execute(self).progress_turn().check_complete()
		if len(notation) > 0 and not next_state.complete:
			return next_state.apply_notation(notation)
		return next_state
	return self

func get_space_from_notation(notation: String) -> BoardSpace:
	return spaces[7-int(notation[1])][column_names.find(notation[0])]

func pop_unused_piece_from_notation(player: int, notation: String) -> GamePiece:
	for i in len(get_unused_pieces_for_player(player)):
		if get_unused_pieces_for_player(player)[i].symbol == notation:
			return get_unused_pieces_for_player(player).pop_at(i)
		elif get_unused_pieces_for_player(player)[i].get_flipped().symbol == notation:
			return get_unused_pieces_for_player(player).pop_at(i).get_flipped()
	return null
	
func get_current_player() -> int:
	return player_order[current_player_num]

func get_unused_pieces_for_player(player: int) -> Array[GamePiece]:
	return unused_pieces[player_order.find(player)]

func set_unused_pieces_for_player(player: int, pieces: Array[GamePiece]) -> void:
	unused_pieces[player_order.find(player)] = pieces

func add_unused_piece_for_player(player: int, piece: GamePiece) -> void:
	unused_pieces[player_order.find(player)].append(piece)

func get_are_pieces_selected_for_player(player: int) -> bool:
	return pieces_selected[player_order.find(player)]

func set_are_pieces_selected_for_player(player: int, selected: bool) -> void:
	pieces_selected[player_order.find(player)] = selected
