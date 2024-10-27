extends CanvasLayer

@onready var panel = $Panel
@onready var label = $Label

func _ready() -> void:
	# Make sure the overlay is visible at the start
	panel.visible = true
	label.visible = true
	panel.modulate = Color(0, 0, 0, 2)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		panel.visible = false
		label.visible = false
