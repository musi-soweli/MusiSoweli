extends Control

var GAME_DISPLAY = preload("res://game_display.tscn")

func on_create_button_pressed():
	var game = GAME_DISPLAY.instantiate()
	game.create($Create/SpinBox2.value, $Create/SpinBox.value, true)
	add_child(game)
	$Create.hide()
	$Main.hide()

func on_join_button_pressed():
	pass # Replace with function body.
