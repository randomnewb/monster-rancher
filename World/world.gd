extends Node2D

signal accept_button_pressed;

@onready var spawn_zone = $SpawnZone
@onready var player = $Player
@onready var restart_button = $HUD/RestartButton
@onready var game_over_label = $HUD/GameOverLabel

var INTERACTABLE_SCENE = preload("res://Environment/interactable.tscn")
var PLAYER_SCENE = preload("res://Player/player.tscn")

func _ready():
	randomize();
	spawn_interactable();

func get_spawn_position():
	return (Vector2(randi_range(spawn_zone.position.x, spawn_zone.size.x + spawn_zone.position.x), randi_range(spawn_zone.position.y, spawn_zone.size.y + spawn_zone.position.y)))

func get_random_frame(sprite):
#	print(sprite.hframes * sprite.vframes); 
	return randi_range(0, (sprite.hframes * sprite.vframes) - 1);

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

@onready var lives_label = $HUD/LivesLabel
#@export var success = 0:
var lives = 3.0:
	get:
		return Global.lives
	set(value):
		Global.lives = value
		lives = Global.experience
		lives_label.text = "Lives: " + str(Global.lives);
		if Global.lives == 0.0:
			restart_game();
			player.queue_free()

var extra_lives_counter = 0.0:
	get:
		return Global.extra_lives_counter
	set(value):
		Global.extra_lives_counter = value
		if Global.extra_lives_counter >= 10.0:
			Global.extra_lives_counter -= 10.0;
			lives += 1.0;

@onready var inventory_display = $HUD/InventoryDisplay;
@onready var ITEM_SPRITE2D_SCENE = preload("res://UI/ItemSprite2D.tscn")
		# add a Sprite2D that matches the frame from the inventory
#		var world = get_tree().current_scene;
#		var item_sprite2d_scene = ITEM_SPRITE2D_SCENE.instantiate();
#		print(value);
#		item_sprite2d_scene.frame = value;
#		inventory_display.add_child(item_sprite2d_scene);
#		world.add_child.call_deferred(item_sprite2d_scene);
#		item_sprite2d_scene.position = self.global_position

func _on_player_mini_game_won():
	experience += 1.0;
	extra_lives_counter += 1.0;
	spawn_interactable();

func _on_player_failed_mini_game():
	lives -= 1.0;

func _on_button_button_down():
	accept_button_pressed.emit();

func restart_game():
	await get_tree().create_timer(1.5).timeout;
	restart_button.show();
	game_over_label.show();

func _on_restart_button_pressed():
	restart_button.hide();
	game_over_label.hide();
	
	experience = 0.0;
	lives = 3.0;
	extra_lives_counter = 0.0;
	
	player = PLAYER_SCENE.instantiate();
	#other_instance.signal_that_other_instance_is_emitting.connect(to_the_current_object_probably._on_currentObject_name_of_signal)
	player.mini_game_won.connect(self._on_player_mini_game_won);
	player.failed_mini_game.connect(self._on_player_failed_mini_game);
	var world = get_tree().current_scene;
	world.add_child.call_deferred(player);
	player.position = Vector2(20,20);

	for node in get_tree().get_nodes_in_group("Entities"):
		node.queue_free();
		
	spawn_interactable();
