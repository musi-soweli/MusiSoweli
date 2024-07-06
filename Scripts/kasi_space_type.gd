class_name KasiSpaceType extends SpaceType

func get_description(board_space: BoardSpace):
	var k = board_space.board_state.kasi_spaces.find(board_space)
	return str(board_space.board_state.kili_amounts[k]) + "/" + str(board_space.board_state.kili_amount) + " kili remain. \n" + description
