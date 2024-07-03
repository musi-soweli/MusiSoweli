class_name GamePiece
const COLORS : Array[String] = ["laso", "loje", "pimeja", "jelo", "walo"]
var name : String
var symbol : String
var owner : int #0 for kili, 1-4 for players
var position : BoardSpace
var aquatic : bool = false
var textures : Array[Resource]
func get_texture():
	return textures[owner - 1]
func get_potential_moves(current_turn : int, carry : bool) -> Array [Action]:
	return []
func get_copy(_board_space : BoardSpace) -> GamePiece:
	return GamePiece.new()
func in_stack() -> bool:
	return len(position.pieces) > 1
func can_move_onto_space(space : BoardSpace) -> bool:
	if space == null:
		return false
	if space.piece_num() == 1:
		return space.pieces[0].owner == owner or space.pieces[0].owner == 0
	elif space.piece_num() == 0:
		if space.type == SpaceType.TELO:
			return aquatic
		else:
			return true
	return false
func can_capture_onto_space(space : BoardSpace) -> bool:
	if space == null:
		return false
	if space.piece_num() > 0 and space.pieces[-1].owner > 0 and space.pieces[-1].owner != owner:
		if space.type == SpaceType.TELO:
			return aquatic or space.piece_num() > 1
		else:
			return true
	else:
		return false
func get_flipped() -> GamePiece:
	return self.get_copy(position)
