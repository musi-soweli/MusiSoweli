extends GridContainer
signal move_selected(move : Action)
@export var SPACE_INFO_DISPLAY : NodePath
@export var PIECE_SELECTION_DISPLAY : NodePath
const SPACE_DISPLAY := preload("res://space_display.tscn")
#var current_state : BoardState
var selected_piece : GamePiece
var carrying : bool = false
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
	selected_piece = null
	for child in get_children():
		child.set_move(null)
func on_piece_selected(piece : GamePiece):
	if moving:
		if selected_piece == piece:
			if selected_piece.in_stack():
				carrying = not carrying
				for child in get_children():
					if child.move is MovementAction and child.move.can_carry:
						child.move.carries = carrying
						child.update_icon()
			else:
				selected_piece = null
				for child in get_children():
					child.set_move(null)
		else:
			for child in get_children():
				child.set_move(null)
			selected_piece = piece
			for move in piece.get_potential_moves():
				if move is MovementAction:
					if move.can_carry:
						move.carries = carrying
					get_child_from_indexes(move.new_position.row, move.new_position.column).set_move(move)
func on_move_selected(move : Action):
	if moving:
		selected_piece = null
		for child in get_children():
			child.set_move(null)
		emit_signal("move_selected", move)
