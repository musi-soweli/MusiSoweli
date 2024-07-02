extends Panel
signal space_hovered(space : BoardSpace)

const SPACE = preload("res://space_display.tscn")
var spaces : Array[BoardSpace] = []
var selection_num : int = 5
var on_selected : Callable

func display_pieces(pieces : Array[GamePiece], _selection_num : int, types : Array[SpaceType], _on_selected : Callable) -> void:
	show()
	selection_num = _selection_num
	on_selected = _on_selected
	$GridContainer.columns = len(pieces)
	spaces = []
	for i in range(len(pieces)*3):
		var space_display = SPACE.instantiate()
		spaces.append(BoardSpace.new(null, "piece selection", types[i] if i < selection_num else SpaceType.OPEN, i%2 == 0, i/len(pieces), i%len(pieces)))
		if i >= len(pieces)*2:
			var p : Array[GamePiece] = [pieces[i-len(pieces)*2].get_flipped()]
			p[0].position = spaces[i]
			spaces[i].pieces = p
		elif i >= len(pieces):
			var p : Array[GamePiece] = [pieces[i-len(pieces)]]
			p[0].position = spaces[i]
			spaces[i].pieces = p
		space_display.set_space(spaces[i])
		$GridContainer.add_child(space_display)
		space_display.connect("space_hovered", Callable(self, "on_space_hovered"))
		space_display.connect("piece_selected", Callable(self, "on_piece_selected"))

func on_space_hovered(space : BoardSpace) -> void:
	emit_signal("space_hovered", space)
func on_piece_selected(piece : GamePiece) -> void:
	spaces[piece.position.row*$GridContainer.columns + piece.position.column].pieces.pop_back() #take the piece off the space
	if piece.position.row == 0:
		for i in range($GridContainer.columns):
			if spaces[$GridContainer.columns + i].piece_num() == 0:
				spaces[$GridContainer.columns + i].pieces.append(piece)
				piece.position = spaces[$GridContainer.columns + i]
				var flipped = piece.get_flipped()
				spaces[$GridContainer.columns*2 + i].pieces.append(flipped)#TODO: Check if this is memory safe or whatever
				flipped.position = spaces[$GridContainer.columns*2 + i]
				break
	elif piece.position.row == 1:
		spaces[2*$GridContainer.columns + piece.position.column].pieces.pop_back()
		for i in range(selection_num):
			if spaces[i].piece_num() == 0:
				spaces[i].pieces.append(piece)
				piece.position = spaces[i]
				break
	elif piece.position.row == 2:
		spaces[$GridContainer.columns + piece.position.column].pieces.pop_back()
		for i in range(selection_num):
			if spaces[i].piece_num() == 0:
				spaces[i].pieces.append(piece)
				piece.position = spaces[i]
				break
	for i in range($GridContainer.get_child_count()):
		$GridContainer.get_child(i).set_space(spaces[i])
	var ready = false
	for i in range(selection_num):
		if spaces[i].piece_num() == 0:
			ready = true
			break
	$Button.disabled = ready
func on_button_pressed():
	for child in $GridContainer.get_children():
		child.queue_free()
	hide()
	var pieces : Array[GamePiece] = []
	for i in range(selection_num):
		pieces.append(spaces[i].pieces[0])
	on_selected.bind(pieces).call()
