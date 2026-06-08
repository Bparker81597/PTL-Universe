extends Node3D

## Reusable non-player character with a name, interaction prompt, and dialogue.

@export var npc_name: String = "NPC"
@export_multiline var dialogue_text: String = "Hello."
@export_multiline var after_clue_dialogue_text: String = ""
@export var dialogue_clue_id: String = ""
@export var interaction_prompt: String = "Press E to talk to"
@export var investigation_step_id: String = ""

@onready var name_label: Label3D = $NameLabel
@onready var interaction_area: Area3D = $InteractionArea

var player_nearby: bool = false
var prompt_ui: CanvasLayer
var dialogue_ui: CanvasLayer


func _ready() -> void:
	name_label.text = npc_name
	interaction_area.body_entered.connect(_on_body_entered)
	interaction_area.body_exited.connect(_on_body_exited)
	prompt_ui = get_tree().get_first_node_in_group("nexus_menu") as CanvasLayer
	dialogue_ui = get_tree().get_first_node_in_group("dialogue_ui") as CanvasLayer


func _unhandled_input(event: InputEvent) -> void:
	if not player_nearby or dialogue_ui == null:
		return

	if event.is_action_pressed("interact") and dialogue_ui.has_method("show_dialogue"):
		_hide_prompt()
		dialogue_ui.show_dialogue(npc_name, _get_current_dialogue())
		if investigation_step_id != "":
			InvestigationManager.complete_npc_step(investigation_step_id)
		get_viewport().set_input_as_handled()


func _on_body_entered(body: Node3D) -> void:
	if not body.is_in_group("player"):
		return

	player_nearby = true
	if prompt_ui != null and prompt_ui.has_method("set_interaction_prompt"):
		prompt_ui.set_interaction_prompt(true, "%s %s" % [interaction_prompt, npc_name])


func _on_body_exited(body: Node3D) -> void:
	if not body.is_in_group("player"):
		return

	player_nearby = false
	_hide_prompt()


func _hide_prompt() -> void:
	if prompt_ui != null and prompt_ui.has_method("set_interaction_prompt"):
		prompt_ui.set_interaction_prompt(false, interaction_prompt)


func _get_current_dialogue() -> String:
	if (
		dialogue_clue_id != ""
		and after_clue_dialogue_text != ""
		and InvestigationManager.discovered_clues.has(dialogue_clue_id)
	):
		return after_clue_dialogue_text
	return dialogue_text
