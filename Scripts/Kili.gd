class_name Kili extends GamePiece

func _init(_position: BoardSpace, _owner: int = 0):
	name = "kili"
	symbol = "I"
	position = _position
	owner = 0
	var t = AtlasTexture.new()
	t.atlas = GamePiece.TEXTURE
	t.region = Rect2(0, 0, 100, 100)
	textures = [t]

func get_texture():
	return textures[0]

func get_name():
	return name

func get_description():
	return "store kili in your home area or under your pieces to score points."

func get_potential_moves(current_turn: int, _carry: bool) -> Array[Action]:
	if position.type.is_home and position.type.owner_signature == current_turn:
		return [PromotionAction.new(current_turn, position.row, position.column)]

	return []

func get_copy(board_space: BoardSpace) -> Kili:
	return Kili.new(board_space)
