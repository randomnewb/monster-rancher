extends Node2D
@onready var success_label = $HUD/SuccessLabel
@export var success = 0:
	get:
		return success
	set(value):
		success = value
		success_label.text = "Success: " + str(success);

func _on_player_mini_game_won():
	success += 1;
