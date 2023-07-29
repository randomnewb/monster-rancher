extends Control

@export var MAX_PROGRESS_VALUE = 42;
@export var progress_value = 0;
@export var default_stop_value = 320;
@onready var stop_value = default_stop_value;

@onready var label = $Label
@onready var progress_bar = $ProgressBar
@onready var progress_timer = $ProgressTimer
@onready var stop_zone = $StopZone

@onready var check_value_label = $CheckValueLabel
@onready var stop_value_label = $StopValueLabel

@onready var check = int(progress_value * (default_stop_value / MAX_PROGRESS_VALUE));

func _ready():
	restart();
	update_progress_ui();
	progress_bar.max_value = MAX_PROGRESS_VALUE;
	
func update_progress_ui():
	set_label();
	set_progress_bar();

func restart():
	randomize();
	progress_value = 0;
	stop_value = randi_range(0, 310);
	stop_zone.position.x = stop_value;
	print(stop_zone.position.x);
	print(stop_value);

func check_stop_value():
	if (check >= stop_value and check < stop_value + 10):
		print("WINNER");
	print("check: ", check);
	print("check:", check + 10)
	print("stop_value:", stop_value);


func set_label():
	label.text = "Progress: %s" % progress_value

func set_progress_bar():
	progress_bar.value = progress_value;

func _input(event):
	if event.is_action_pressed("ui_accept"):
		if progress_timer.is_stopped():
			progress_timer.start();
			restart();
		else:
			progress_timer.stop();
			check = int(progress_value * (default_stop_value / MAX_PROGRESS_VALUE));
			check_stop_value();

func progress():
	progress_value += 1
	if progress_value > MAX_PROGRESS_VALUE:
		restart();
	update_progress_ui();

func _on_timer_timeout():
	progress();
	
func _process(delta):
	check = int(progress_value * (default_stop_value / MAX_PROGRESS_VALUE));
	check_value_label.text = str(check);
	stop_value_label.text = str(stop_value);
	if (check >= stop_value):
		print("WINNER");
