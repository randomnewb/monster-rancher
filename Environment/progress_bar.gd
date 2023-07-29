extends ProgressBar

@export var MAX_PROGRESS = 100;
var progress = MAX_PROGRESS;

# Called when the node enters the scene tree for the first time.
func _ready():
	set_progress_label();

func set_progress_label() -> void:
	
