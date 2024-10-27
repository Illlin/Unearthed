extends Node3D

@export var player: NodePath  # Drag and drop the player node in the editor
@export var text: String # Text to say
@onready var dialogue_label = $"../../UI/dialogue"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func get_distance_to_player() -> float:
	var player_node = get_node(player)
	if player_node:
		return global_transform.origin.distance_to(player_node.global_transform.origin)
	else:
		print("Player node not found in the scene.")
		return -1.0

func set_player_state():
	dialogue_label.text = text


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var a = get_distance_to_player()
	if get_distance_to_player() < 2:
		set_player_state()
	
