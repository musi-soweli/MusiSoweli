extends Panel

signal space_hovered(space: BoardSpace)
signal cancelled()

const SPACE = preload ("res://space_display.tscn")

var spaces: Array[BoardSpace] = []
var number_to_select: int = 5
var on_selected: Callable

func display_pieces(pieces: Array[GamePiece], _number_to_select: int, types: Array[SpaceType], _on_selected: Callable, text: String="Select Pieces", cancellable: bool=false) -> void:
	if len(pieces) > 0:
		show()
		$Cancel.visible = cancellable
		$Label.text = text
		number_to_select = _number_to_select
		on_selected = _on_selected
		$GridContainer.columns = len(pieces)
		$GridContainer.size.x = len(pieces)*100
		spaces = []
		for i in range(len(pieces) * 3):
			var space_display = SPACE.instantiate()
			spaces.append(BoardSpace.new(null, "piece selection", types[i] if i < number_to_select else SpaceType.EMPTY, i % 2 == 0, i / len(pieces), i %len(pieces)))
			if i >= len(pieces) * 2:
				var p: Array[GamePiece] = [pieces[i - len(pieces) * 2].get_flipped()]
				p[0].position = spaces[i]
				spaces[i].pieces = p
			elif i >= len(pieces):
				var p: Array[GamePiece] = [pieces[i - len(pieces)]]
				p[0].position = spaces[i]
				spaces[i].pieces = p
			space_display.set_space(spaces[i])
			$GridContainer.add_child(space_display)
			space_display.connect("space_hovered", Callable(self, "on_space_hovered"))
			space_display.connect("piece_selected", Callable(self, "on_piece_selected"))

func on_space_hovered(space: BoardSpace) -> void:
	emit_signal("space_hovered", space)

func on_piece_selected(space: BoardSpace) -> void: # take the piece off the space
	if space.row == 0:
		for i in range($GridContainer.columns):
			if spaces[$GridContainer.columns + i].piece_num() == 0:
				var piece = spaces[space.row * $GridContainer.columns + space.column].pieces.pop_back()
				spaces[$GridContainer.columns + i].pieces.append(piece)
				piece.position = spaces[$GridContainer.columns + i]
				var flipped = piece.get_flipped()
				spaces[$GridContainer.columns * 2 + i].pieces.append(flipped) # TODO: Check if this is memory safe or whatever
				flipped.position = spaces[$GridContainer.columns * 2 + i]
				break
	elif space.row == 1:
		for i in range(number_to_select):
			if spaces[i].piece_num() == 0:
				var piece = spaces[space.row * $GridContainer.columns + space.column].pieces.pop_back()
				spaces[2 * $GridContainer.columns + space.column].pieces.pop_back()
				spaces[i].pieces.append(piece)
				piece.position = spaces[i]
				break
	elif space.row == 2:
		for i in range(number_to_select):
			if spaces[i].piece_num() == 0:
				var piece = spaces[space.row * $GridContainer.columns + space.column].pieces.pop_back()
				spaces[$GridContainer.columns + space.column].pieces.pop_back()
				spaces[i].pieces.append(piece)
				piece.position = spaces[i]
				break
	for i in range($GridContainer.get_child_count()):
		$GridContainer.get_child(i).set_space(spaces[i])
	var redy = false
	for i in range(number_to_select):
		if spaces[i].piece_num() == 0:
			redy = true
			break
	$Button.disabled = redy

func on_button_pressed():
	disappear()
	var pieces: Array[GamePiece] = []
	for i in range(number_to_select):
		pieces.append(spaces[i].pieces[0])
	on_selected.bind(pieces).call()

func on_cancel_pressed():
	for child in $GridContainer.get_children():
		child.queue_free()
	hide()
	#var pieces: Array[GamePiece] = []
	emit_signal("cancelled")

func disappear():
	if visible:
		for child in $GridContainer.get_children():
			child.queue_free()
		hide()
