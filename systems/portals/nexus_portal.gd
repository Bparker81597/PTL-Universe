extends Area3D

## Detects when the player is close enough to interact with The Nexus.
## The portal asks the shared Nexus menu to show a prompt or open the menu.

@export var prompt_text: String = "Press E to access The Nexus"

var player_nearby: bool = false
var nexus_menu: CanvasLayer


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	nexus_menu = get_tree().get_first_node_in_group("nexus_menu") as CanvasLayer

	if nexus_menu == null:
		push_warning("The Nexus could not find a node in the 'nexus_menu' group.")


func _unhandled_input(event: InputEvent) -> void:
	if not player_nearby or nexus_menu == null:
		return

	if event.is_action_pressed("interact") and nexus_menu.has_method("open_menu"):
		nexus_menu.open_menu()
		get_viewport().set_input_as_handled()


func _on_body_entered(body: Node3D) -> void:
	if not body.is_in_group("player"):
		return

	player_nearby = true
	if nexus_menu != null and nexus_menu.has_method("set_interaction_prompt"):
		nexus_menu.set_interaction_prompt(true, prompt_text)


func _on_body_exited(body: Node3D) -> void:
	if not body.is_in_group("player"):
		return

	player_nearby = false
	if nexus_menu != null and nexus_menu.has_method("set_interaction_prompt"):
		nexus_menu.set_interaction_prompt(false, prompt_text)
