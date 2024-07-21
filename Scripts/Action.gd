class_name Action

var player: int

static func from_line(_notation: String) -> Action:
	var split: Array = _notation.split(" ")
	if split[0] == MovementAction.LINE_NAME:
		return MovementAction.new(int(split[1]), int(split[2]), int(split[3]), int(split[4]), int(split[5]), bool(split[6]), bool(split[7]))
	elif split[0] == PieceSelectionAction.LINE_NAME:
		return PieceSelectionAction.new(int(split[1]), split[2])
	elif split[0] == PromotionAction.LINE_NAME:
		return PromotionAction.new(int(split[1]), int(split[2]), int(split[3]), split[4])#TODO: Piece Type Refactor
	elif split[0] == PassAction.LINE_NAME:
		return PassAction.new(int(split[1]))
	return null

func _init(_player: int):
	player = _player

func execute(board_state: BoardState) -> BoardState:
	return board_state

func get_notation() -> String:
	return ""

func get_line() -> String:
	return ""
