extends Node2D

signal accept_button_pressed;

@onready var spawn_zone = $SpawnZone

var INTERACTABLE_SCENE = preload("res://Environment/interactable.tscn")

func _ready():
	randomize();
	spawn_interactable();

func get_spawn_position():
	return (Vector2(randi_range(spawn_zone.position.x, spawn_zone.size.x + spawn_zone.position.x), randi_range(spawn_zone.position.y, spawn_zone.size.y + spawn_zone.position.y)))

func get_random_frame(sprite):
#	print(sprite.hframes * sprite.vframes); 
	return randi_range(0, sprite.hframes * sprite.vframes);

func spawn_interactable():
#	print(get_spawn_position());
	var interactable = INTERACTABLE_SCENE.instantiate();
	var sprite = interactable.find_child("Sprite2D");
	sprite.frame = get_random_frame(sprite)
	var world = get_tree().current_scene;
	world.add_child.call_deferred(interactable);
	interactable.position = get_spawn_position();

@onready var experience_label = $HUD/ExperienceLabel
#@export var success = 0:
var experience = 0.0:
	get:
		return Global.experience
	set(value):
		Global.experience = value
		experience = Global.experience
		experience_label.text = "Experience: " + str(Global.experience);

func _on_player_mini_game_won():
	experience += 1.0;
	spawn_interactable();

func _on_button_button_down():
	accept_button_pressed.emit();
