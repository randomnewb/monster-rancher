extends Control

@export var MAX_PROGRESS_VALUE = 42;
@export var progress_value = 0;

@onready var label = $Label
@onready var progress_bar = $ProgressBar

func _ready():
	update_progress_ui();
	progress_bar.max_value = MAX_PROGRESS_VALUE;
	
func update_progress_ui():
	set_label();
	set_progress_bar();

func set_label():
	label.text = "Progress: %s" % progress_value

func set_progress_bar():
	progress_bar.value = progress_value;

func _input(event):
	if event.is_action_pressed("ui_accept"):
		print("input");
		progress();

func progress():
	progress_value += 1
	if progress_value > MAX_PROGRESS_VALUE:
		progress_value = 0;
	update_progress_ui();
