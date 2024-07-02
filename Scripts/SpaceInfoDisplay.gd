extends VBoxContainer
func display_space(space : BoardSpace):
	get_node("SpaceInfo/Title").text = space.name+" ("+space.type.name+")"
	get_node("SpaceInfo/Space").texture = space.get_texture()
	get_node("SpaceInfo/Info").text = space.type.get_description(space)
	if len(space.pieces) > 0:
		get_node("SpaceInfo/Space/BottomPiece").show()
		get_node("SpaceInfo/Space/BottomPiece").texture = space.pieces[0].get_texture()
		get_node("BottomPieceInfo").show()
		get_node("BottomPieceInfo/BottomPiece").texture = space.pieces[0].get_texture()
		get_node("BottomPieceInfo/Title").text = space.pieces[0].get_name()
		get_node("BottomPieceInfo/Info").text = space.pieces[0].get_description()
	else:
		get_node("BottomPieceInfo").hide()
		get_node("SpaceInfo/Space/BottomPiece").hide()
	if len(space.pieces) > 1:
		get_node("SpaceInfo/Space/TopPiece").show()
		get_node("SpaceInfo/Space/TopPiece").texture = space.pieces[1].get_texture()
		get_node("TopPieceInfo").show()
		get_node("TopPieceInfo/TopPiece").texture = space.pieces[1].get_texture()
		get_node("TopPieceInfo/Title").text = space.pieces[1].get_name()
		get_node("TopPieceInfo/Info").text = space.pieces[1].get_description()
	else:
		get_node("TopPieceInfo").hide()
		get_node("SpaceInfo/Space/TopPiece").hide()
