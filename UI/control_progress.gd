extends Control

@export var MAX_PROGRESS_VALUE = 100.0;
@export var progress_value = 0.0;
@export var default_stop_value = 500.0;
@export var default_stop_size = 250.0;
@onready var stop_value = default_stop_value;


@onready var label = $Label
@onready var progress_bar = $ProgressBar
@onready var progress_timer = $ProgressTimer
@onready var stop_zone = $StopZone

@onready var check_value_label = $CheckValueLabel
@onready var stop_value_label = $StopValueLabel

@onready var check = roundi(int(progress_value * (default_stop_value / MAX_PROGRESS_VALUE)));

var accept_button_pressed = false;

var reverse_value = false;

var stop_zone_difficulty = (default_stop_size - pow(Global.experience,1.2)); #Difficulty example using Global.experience

signal mini_game_completed
signal failed_mini_game

func _ready():
	restart();
	update_progress_ui();
	progress_bar.max_value = MAX_PROGRESS_VALUE;
	progress_bar.size.x = default_stop_value;
	#other_instance.signal_that_other_instance_is_emitting.connect(to_the_current_object_probably._on_currentObject_name_of_signal)
	var world = get_tree().current_scene;
	world.accept_button_pressed.connect(self._on_accept_button_pressed);

func _on_accept_button_pressed():
	accept_button_pressed = true;
	
func update_progress_ui():
	set_label();
	set_progress_bar();

func restart():
	reverse_value = false;
	stop_zone.size.x = stop_zone_difficulty; 
	randomize();
	progress_value = 0;
	stop_value = randi_range(0, (default_stop_value - stop_zone_difficulty));
	stop_zone.position.x = stop_value;

func check_stop_value():
	if (check >= stop_value and check < stop_value + stop_zone_difficulty):
		mini_game_completed.emit();
		queue_free()
		await get_tree().create_timer(0.5).timeout;
	else:
		failed_mini_game.emit();

func set_label():
	label.text = "Progress: %s" % progress_value

func set_progress_bar():
	progress_bar.value = progress_value;

func _input(event):
	if event.is_action_pressed("ui_accept") or accept_button_pressed:
		accept_button_pressed = false;
		if progress_timer.is_stopped():
			progress_timer.start();
			restart();
		else:
			progress_timer.stop();
			check = int(progress_value * (default_stop_value / MAX_PROGRESS_VALUE));
			check_stop_value();

func progress():
	if not reverse_value:
		progress_value += (1 + Global.experience / 2); # Another difficulty example, progress_value increases based on exp
	elif reverse_value:
		progress_value -= abs((1 + Global.experience / 2)); # Another difficulty example, progress_value increases based on exp
		
	if progress_value > MAX_PROGRESS_VALUE and not reverse_value:
		reverse_value = true;
	elif progress_value < 0 and reverse_value:
		reverse_value = false;
	update_progress_ui();

func _on_timer_timeout():
	progress();
	
func _process(_delta):
	check = roundi(int(progress_value * (default_stop_value / MAX_PROGRESS_VALUE)));
	stop_value_label.text = str(stop_value);
	check_value_label.text = str(check);

	if (check >= stop_value and check <= stop_value + default_stop_size):
		check_value_label.add_theme_color_override("font_color", Color(1, 1, 0.5))
	else:
		check_value_label.remove_theme_color_override("font_color")

func _on_button_pressed():
	if progress_timer.is_stopped():
		progress_timer.start();
		restart();
	else:
		progress_timer.stop();
		check = int(progress_value * (default_stop_value / MAX_PROGRESS_VALUE));
		check_stop_value();
