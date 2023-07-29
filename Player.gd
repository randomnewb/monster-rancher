extends CharacterBody2D

@export var speed = 100;
@onready var ray_cast_2d = $RayCast2D

func _ready():
	pass;

func _process(delta):
	var input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
			
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
	
	ray_cast_2d.target_position = input_vector * 25;
	var ray_collide = ray_cast_2d.get_collider()
	if ray_collide:
		print("ray: ",ray_collide)
	
	var collision = move_and_collide(input_vector * speed * delta);
	if collision:
		print("collision ", collision.get_collider().name)
