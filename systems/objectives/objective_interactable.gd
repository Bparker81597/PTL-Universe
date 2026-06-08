extends Area3D

## Completes the current world's objective when the nearby player presses E.

@export var interaction_prompt: String = "Press E to investigate"
@export_multiline var completion_message: String = "Objective complete."

var player_nearby: bool = false
var nexus_menu: CanvasLayer


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	nexus_menu = get_tree().get_first_node_in_group("nexus_menu") as CanvasLayer


func _unhandled_input(event: InputEvent) -> void:
	if not player_nearby or ObjectiveManager.objective_complete:
		return

	if event.is_action_pressed("interact"):
		ObjectiveManager.complete_current_objective(completion_message)
		_hide_prompt()
		get_viewport().set_input_as_handled()


func _on_body_entered(body: Node3D) -> void:
	if not body.is_in_group("player") or ObjectiveManager.objective_complete:
		return

	player_nearby = true
	if nexus_menu != null and nexus_menu.has_method("set_interaction_prompt"):
		nexus_menu.set_interaction_prompt(true, interaction_prompt)


func _on_body_exited(body: Node3D) -> void:
	if not body.is_in_group("player"):
		return

	player_nearby = false
	_hide_prompt()


func _hide_prompt() -> void:
	if nexus_menu != null and nexus_menu.has_method("set_interaction_prompt"):
		nexus_menu.set_interaction_prompt(false, interaction_prompt)
