class_name GamePiece
const COLORS : Array[String] = ["laso", "loje", "pimeja", "jelo", "walo"]
var name : String
var symbol : String
var owner : int #0 for kili, 1-4 for players
var position : BoardSpace
var textures : Array[Resource]
func get_texture():
	return textures[owner - 1]
func get_potential_moves() -> Array [Action]:
	return []
func get_copy(_board_space : BoardSpace) -> GamePiece:
	return GamePiece.new()
func in_stack() -> bool:
	return len(position.pieces) > 1
