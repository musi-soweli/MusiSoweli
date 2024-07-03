extends GridContainer
signal move_selected(move : Action)
signal promotion(move : PromotionAction)
@export var SPACE_INFO_DISPLAY : NodePath
@export var PIECE_SELECTION_DISPLAY : NodePath
const SPACE_DISPLAY := preload("res://space_display.tscn")
#var current_state : BoardState
var displaying_moves : bool = false
var moves_displayed : int = 0
var potential_moves : Array[Array] = []
var selected_space : BoardSpace
var moving = false

func populate_grid(boardState : BoardState):
	for child : Node in get_children():
		child.queue_free()
	for r : int in range(len(boardState.spaces)):
		for c : int in range(len(boardState.spaces[r])):
			var display = SPACE_DISPLAY.instantiate()
			display.set_space(boardState.spaces[r][c])
			display.connect("space_hovered", Callable(get_node(SPACE_INFO_DISPLAY), "display_space"))
			display.connect("piece_selected", Callable(self, "on_piece_selected"))
			display.connect("move_selected", Callable(self, "on_move_selected"))
			display.connect("empty_selected", Callable(self, "on_empty_selected"))
			add_child(display)
	size.x = (size.y/7)*9
func update_grid(boardState : BoardState):
	for i : int in range(get_child_count()):
		get_child(i).set_space(boardState.spaces[i/9][i%9])

#func _ready():
	#current_state = BoardState.get_starting_board_state()
	#populate_grid(current_state)

func get_child_from_indexes(row : int, column : int):
	return get_child(row*9+column)

func on_empty_selected():
	hide_potential_moves()
func on_piece_selected(space : BoardSpace):
	if moving:
		if displaying_moves and space == selected_space:
			moves_displayed += 1
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
func show_potential_moves(moves : Array[Action]):
	displaying_moves = true
	for child in get_children():
		child.set_move(null)
	for move in moves:
		if move is MovementAction:
			get_child_from_indexes(move.new_position.row, move.new_position.column).set_move(move)
		elif move is PromotionAction:
			print("promotion")
			emit_signal("promotion", move)
			hide_potential_moves()
			break
func hide_potential_moves():
	displaying_moves = false
	potential_moves = []
	for child in get_children():
		child.set_move(null)
func on_move_selected(move : Action):
	if moving:
		for child in get_children():
			child.set_move(null)
		emit_signal("move_selected", move)
