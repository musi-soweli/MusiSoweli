class_name Kili extends GamePiece
var KILI : Texture2D = preload("res://Assets/kili.png")
func _init(_position : BoardSpace):
	name = "kili"
	symbol = "I"
	position = _position
	owner = 0
	textures = [KILI]
func get_name():
	return name
func get_description():
	return "store kili in your home area or under your pieces to score points."
func get_potential_moves(carry : bool) -> Array [Action]:
	if position.type.is_home:
		return [PromotionAction.new(self)]
	return []
func get_copy(board_space : BoardSpace) -> Kili:
	return Kili.new(board_space)
