extends Node2D

signal accept_button_pressed;

@onready var success_label = $HUD/SuccessLabel
@export var success = 0:
	get:
		return success
	set(value):
		success = value
		success_label.text = "Success: " + str(success);

func _on_player_mini_game_won():
	success += 1;

#func _on_button_pressed():
#	accept_button_pressed.emit();


func _on_button_button_down():
	accept_button_pressed.emit();
