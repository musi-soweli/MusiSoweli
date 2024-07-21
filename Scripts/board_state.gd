class_name BoardState

enum {LASO, LOJE, PIMEJA, JELO, WALO}
#These vars are set in _init
var player_order : Array[int]
var pieces_selected : Array[bool]
var kili_amount: int
var kili_amounts: Array[int] = []
var space_types_string
var starting_pieces_string
var spaces: Array[Array]
var kasi_spaces: Array[BoardSpace] = []
var unused_pieces: Array[Array]
#These vars need to be copied over when the state is copied
var complete: bool = false
var turn: int = 0
var passes: int = 0
var current_player_num : int = 0
#These vars are set for each state
var previous_state: BoardState = null
var next_state: BoardState = null#TODO: Might not wanna settle with this in the end
var move: Action = null
#const starting_pieces_string = "_________ __PPPPP__ _________ _I_____I_ _________ __PPPPP__ _________"

static var column_names = ["m", "n", "p", "t", "k", "s", "w", "l", "j"]
static var default_space_types = "ttppPpptt ttppppptt ooooooooo okotttoko ooooooooo ttllllltt ttllLlltt"
static var default_starting_pieces = "__#####__ __PPPPP__ _________ _________ _________ __PPPPP__ __#####__"
static var default_space_types_3 = "WwwtttppP wwooooopp woookooop toootooot toktttkot toootooot loookoooj llooooojj LlltttjjJ"
static var default_starting_pieces_3 = "______P## _______P# ________P _________ _________ _________ P_______P #P_____P# ##P___P##"
static var default_space_types_4 = "WwwtttppP wwooooopp woookooop toootooot toktttkot toootooot loookoooj llooooojj LlltttjjJ"
static var default_starting_pieces_4 = "##P___P## #P_____P# P_______P _________ _________ _________ P_______P #P_____P# ##P___P##"

func _init(number_of_players: int = 2, _kili_amount: int = 4, _space_types: String = default_space_types, add_pieces: bool = false, _starting_pieces: String = default_starting_pieces, _selectable_pieces: String = ""):#TODO: piece type refactor 
	#Set up player order and piece selection checks
	if number_of_players == 4:
		player_order = [LOJE, JELO, PIMEJA, WALO]
		pieces_selected = [false, false, false, false]
	elif number_of_players == 3:
		player_order = [LOJE, JELO, PIMEJA]
		pieces_selected = [false, false, false]
	else:
		player_order = [LOJE, PIMEJA]
		pieces_selected = [false, false]
	
	kili_amounts = []
	kili_amount = _kili_amount
	
	#Assign spaces array with new spaces based on the types passed in.
	space_types_string = _space_types
	starting_pieces_string = _starting_pieces
	var new_spaces: Array[Array] = []
	var space_rows = _space_types.split(" ")
	var piece_rows = _starting_pieces.split(" ")
	
	for r in range(len(space_rows)):
		new_spaces.append([])

		for c in range(len(space_rows[r])):
			var new_space = BoardSpace.new(self, column_names[c] + str(len(space_rows) - r), SpaceType.from_notation(space_rows[r][c]), (r * len(_space_types[r]) + c) % 2 == 0, r, c)
			new_spaces[r].append(new_space)
			if space_rows[r][c] == "k":
				kasi_spaces.append(new_space)
				kili_amounts.append(kili_amount)
			
			if add_pieces and piece_rows[r][c] != "_" and piece_rows[r][c] != "#":
				new_space.pieces.append(GamePiece.from_notation(piece_rows[r][c], new_space, new_space.type.owner_signature))
	
	spaces = new_spaces
	
	#Add selectable pieces from the types given
	unused_pieces = []
	
	for player in player_order:
		var pieces: Array[GamePiece] = []
		
		for char in _selectable_pieces:
			pieces.append(GamePiece.from_notation(char, null, player))
		
		unused_pieces.append(pieces)

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

func get_copy() -> BoardState: # TODO: There has to be a better way of doing this with deep copies this feel so inefficient
	var new_board: BoardState = BoardState.new(len(player_order), kili_amount, space_types_string, false, starting_pieces_string)
	for r in range(len(spaces)):
		for c in range(len(spaces[r])):
			var pieces: Array[GamePiece] = []
			for piece: GamePiece in spaces[r][c].pieces:
				pieces.append(piece.get_copy(new_board.spaces[r][c]))
			new_board.spaces[r][c].pieces = pieces
	
	new_board.pieces_selected = pieces_selected.duplicate()
	new_board.kili_amounts = kili_amounts.duplicate()
	
	for i in range(len(unused_pieces)):
		var n: Array[GamePiece] = []
		new_board.unused_pieces.append(n)

		for j in range(len(unused_pieces[i])):
			new_board.unused_pieces[i].append(unused_pieces[i][j].get_copy(null))
	
	new_board.complete = complete
	new_board.turn = turn
	new_board.passes = passes
	new_board.current_player_num = current_player_num
	
	next_state = new_board
	new_board.previous_state = self
	
	return new_board

func apply_lines(lines: Array[String]) -> BoardState:
	while len(lines) > 0:
		var move = Action.from_line(lines.pop_front())
		if move != null:
			next_state = move.execute(self).progress_turn().check_complete()
			if len(lines) > 1 and not next_state.complete:
				return next_state.apply_lines(lines)
			return next_state
	return self
#0. AASWW KKSUU
#0. AASWW ASAWW 1. w6k4 p0k2
func apply_notation(notation: String) -> BoardState:
	if len(notation) == 0:
		return
	var slice : String = notation.get_slice(" ", 0)
	notation = notation.erase(0, len(slice)+1)
	while slice.contains("."):
		slice = notation.get_slice(" ", 0) #Skip the numbers
		notation = notation.erase(0, len(slice)+1)
	#TODO: Change movements to be the same as the official notation
	if slice.is_valid_int(): #Check if kili number is being specified
		kili_amount = int(slice)
		for k in kili_amounts:
			k = kili_amount
		slice = notation.get_slice(" ", 0) #If it is, change kili amounts and move on
		notation = notation.erase(0, len(slice)+1)
	if slice == "Pass":
		move = PassAction.new(get_current_player())
	elif slice == slice.to_upper(): #Check if the section is all uppercase (Meaning it is a piece selection)
		if not has_player_selected_pieces(get_current_player()):
			move = PieceSelectionAction.new(get_current_player(), slice)
	elif slice.contains("="):#Check if the section contains = (Meaning it is a promotion)
		var space = get_space_from_notation(slice.substr(0,2))
		move = PromotionAction.new(get_current_player(), space.row, space.column, slice[-1])
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
		move = MovementAction.new(get_current_player(), old_pos.row, old_pos.column, new_pos.row, new_pos.column, carry, capture)#TODO: just checking for error and stuff
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

func has_player_selected_pieces(player: int) -> bool:
	return pieces_selected[player_order.find(player)]

func set_has_player_selected_pieces(player: int, selected: bool) -> void:
	pieces_selected[player_order.find(player)] = selected

func get_starting_positions(player: int) -> Array[BoardSpace]:
	var positions: Array[BoardSpace] = []
	var split_starting_pieces = starting_pieces_string.split(" ")
	for r in range(len(spaces)):
		for c in range(len(spaces[r])):
			if split_starting_pieces[r][c] == "#" and spaces[r][c].type.owner_signature == player:
				positions.append(spaces[r][c])
	return positions
func get_starting_position_types(player: int) -> Array[SpaceType]:
	var types: Array[SpaceType] = []
	var split_starting_pieces = starting_pieces_string.split(" ")
	for r in range(len(spaces)):
		for c in range(len(spaces[r])):
			if split_starting_pieces[r][c] == "#" and spaces[r][c].type.owner_signature == player:
				types.append(spaces[r][c].type)
	return types
