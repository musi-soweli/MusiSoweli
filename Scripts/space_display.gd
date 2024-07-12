extends TextureRect

signal space_hovered(space: BoardSpace)
signal piece_selected(space: BoardSpace)
signal move_selected(move: Action)
signal empty_selected()

static var TEXTURES = preload("res://Assets/symbols.png")
static var EMPTY: Texture2D = preload ("res://assets/empty.png")
static var MOVE: Texture2D
static var DOUBLE_MOVE: Texture2D
static var CAPTURE: Texture2D
static var DOUBLE_CAPTURE: Texture2D

var space: BoardSpace
var move: Action
var moveable: bool = false
var selectable: bool = true

func _init():
	if MOVE == null:
		MOVE = AtlasTexture.new()
		MOVE.atlas = TEXTURES
		MOVE.region = Rect2(0, 0, 100, 100)
		DOUBLE_MOVE = AtlasTexture.new()
		DOUBLE_MOVE.atlas = TEXTURES
		DOUBLE_MOVE.region = Rect2(100, 0, 100, 100)
		CAPTURE = AtlasTexture.new()
		CAPTURE.atlas = TEXTURES
		CAPTURE.region = Rect2(200, 0, 100, 100)
		DOUBLE_CAPTURE = AtlasTexture.new()
		DOUBLE_CAPTURE.atlas = TEXTURES
		DOUBLE_CAPTURE.region = Rect2(300, 0, 100, 100)

func set_space(_space):
	space = _space
	name = space.name
	texture = space.get_texture()

	if len(space.pieces) > 0:
		get_node("BottomPiece").show()
		get_node("BottomPiece").texture = space.pieces[0].get_texture()
	else:
		get_node("BottomPiece").hide()

	if len(space.pieces) > 1:
		get_node("TopPiece").show()
		get_node("TopPiece").texture = space.pieces[- 1].get_texture()
	else:
		get_node("TopPiece").hide()

	update_icon()

func set_move(_move: Action):
	move = _move

	if _move == null:
		moveable = false
	else:
		moveable = true

	update_icon()

func update_icon():
	if moveable:
		if move.carries:
			if move.captures:
				get_node("Button").texture_normal = DOUBLE_CAPTURE
			else:
				get_node("Button").texture_normal = DOUBLE_MOVE
		else:
			if move.captures:
				get_node("Button").texture_normal = CAPTURE
			else:
				get_node("Button").texture_normal = MOVE
	else:
		get_node("Button").texture_normal = EMPTY

func _on_button_mouse_entered():
	emit_signal("space_hovered", space)

func _on_button_pressed():
	if moveable:
		emit_signal("move_selected", move)
	elif selectable:
		if len(space.pieces) > 0:
			emit_signal("piece_selected", space)
		else:
			emit_signal("empty_selected")
