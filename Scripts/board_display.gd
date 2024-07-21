extends GridContainer

enum {LASO, LOJE, PIMEJA, JELO, WALO}

signal move_selected(move: Action)
signal promotion(move: PromotionAction)

@export var SPACE_INFO_DISPLAY: NodePath
@export var PIECE_SELECTION_DISPLAY: NodePath

const SPACE_DISPLAY := preload ("res://space_display.tscn")

#var current_state : BoardState
var displaying_moves: bool = false
var moves_displayed: int = 0
var pov: int
var local: bool
var potential_moves: Array[Array] = []
var selected_space: BoardSpace
var can_move = false

func populate_grid(board_state: BoardState):
	if local and board_state.next_state == null:
		pov = board_state.get_current_player()

	for child: Node in get_children():
		child.queue_free()

	for r: int in range(len(board_state.spaces)):
		for c: int in range(len(board_state.spaces[r])):
			var display = SPACE_DISPLAY.instantiate()
			display.set_space(board_state.spaces[r][c])
			display.connect("space_hovered", Callable(get_node(SPACE_INFO_DISPLAY), "display_space"))
			display.connect("piece_selected", Callable(self, "on_piece_selected"))
			display.connect("move_selected", Callable(self, "on_move_selected"))
			display.connect("empty_selected", Callable(self, "on_empty_selected"))
			add_child(display)

func _process(_delta):
	if get_child_count()/columns == 7:
		size.x = (size.y / 7.0) * 9.0
	else:
		size.x = size.y

func update_grid(board_state: BoardState):
	pivot_offset = Vector2(size.x * 0.5, size.y * 0.5)
	if pov == PIMEJA:
		rotation_degrees = 180
	elif pov == JELO:
		rotation_degrees = 90
	elif pov == WALO:
		rotation_degrees = 270
	else:
		rotation_degrees = 0

	for i: int in range(get_child_count()):
		get_child(i).set_space(board_state.spaces[i / 9][i % 9])
		get_child(i).pivot_offset = Vector2(get_child(i).size.x * 0.5, get_child(i).size.y * 0.5)
		if pov == PIMEJA:
			get_child(i).rotation_degrees = 180
		elif pov == JELO:
			get_child(i).rotation_degrees = 270
		elif pov == WALO:
			get_child(i).rotation_degrees = 90
		else:
			get_child(i).rotation_degrees = 0

#func _ready():
	#current_state = BoardState.get_starting_board_state()
	#populate_grid(current_state)

func get_child_from_indexes(row: int, column: int):
	return get_child(row * 9 + column)

func on_empty_selected():
	hide_potential_moves()

func on_piece_selected(space: BoardSpace):
	if can_move:
		if displaying_moves and space == selected_space:
			moves_displayed += 1#Cycle through different types of moves

			if moves_displayed >= len(potential_moves):
				moves_displayed = 0
				hide_potential_moves()
			else:
				show_potential_moves(potential_moves[moves_displayed])
		else:
			moves_displayed = 0
			potential_moves = space.get_potential_moves()

			if len(potential_moves) > 0:
				selected_space = space
				show_potential_moves(potential_moves[moves_displayed])
			else:
				hide_potential_moves()

func show_potential_moves(moves: Array[Action]):
	displaying_moves = true

	for child in get_children():
		child.set_move(null)

	for move in moves:
		if move is MovementAction:
			get_child_from_indexes(move.new_row, move.new_column).set_move(move)
		elif move is PromotionAction:
			emit_signal("promotion", move)
			hide_potential_moves()
			break

func hide_potential_moves():
	displaying_moves = false
	potential_moves = []
	for child in get_children():
		child.set_move(null)

func on_move_selected(move: Action):
	if can_move:
		for child in get_children():
			child.set_move(null)
		
		emit_signal("move_selected", move)
