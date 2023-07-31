extends CharacterBody2D

@export var speed = 100;
@onready var ray_cast_2d = $RayCast2D
var last_clicked_position = null;
var interacting = false;
var collision = null;
var CONTROL_PROGRESS_SCENE = preload("res://UI/control_progress.tscn")

signal mini_game_won

func _process(delta):
	var input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	if Input.is_action_pressed("tap_left_mouse"):
		last_clicked_position = get_local_mouse_position();
		var target = last_clicked_position;
		target /= position;
		input_vector = target.normalized();

	if input_vector == Vector2.ZERO:
#		animation_player.play("idle");
		pass;
	else:
#		animation_player.play("run");
		if input_vector.x != 0:
			pass;
#			sprite_2d.scale.x = sign(input_vector.x);
#	position.x = clamp(position.x, 5, width - 5);
#	position.y = clamp(position.y, 5, height - 5);
	#position += input_vector * speed * delta;
	
	#ray_cast code
#	ray_cast_2d.target_position = input_vector * 25;
#	var ray_collide = ray_cast_2d.get_collider()
#	if ray_collide:
#		print("ray: ",ray_collide)
	if not interacting:
		collision = move_and_collide(input_vector * speed * delta);
	
	if collision and not interacting:
		interacting = true;
		print("collision ", collision.get_collider().name)
		var control_progress_scene = CONTROL_PROGRESS_SCENE.instantiate();
		var world = get_tree().current_scene;
		world.add_child.call_deferred(control_progress_scene);
		control_progress_scene.scale.x = 0.05;
		control_progress_scene.scale.y = 0.1;
		control_progress_scene.position = global_position;
		control_progress_scene.mini_game_completed.connect(self._on_player_mini_game_completed);
#		connect("mini_game_completed", self._on_player_mini_game_completed);

func _on_player_mini_game_completed():
	interacting = false;
	mini_game_won.emit();
