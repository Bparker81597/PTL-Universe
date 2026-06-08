extends Node

## Tracks the current objective and broadcasts UI updates.
## SceneManager calls set_world_objective() whenever a new world loads.

signal objective_changed(objective_text: String, is_complete: bool)
signal message_shown(message_text: String)

const WORLD_OBJECTIVES := {
	"PTL_HQ": "Enter The Nexus",
	"CodeverseCity": "Investigate the corrupted code panels",
	"NovaToneStudio": "Check the soundwave console",
	"NovaCanvasLoft": "Inspect the glowing canvas",
}

var current_world_name: String = ""
var current_objective: String = ""
var objective_complete: bool = false


func set_world_objective(world_name: String) -> void:
	current_world_name = world_name
	current_objective = WORLD_OBJECTIVES.get(world_name, "")
	objective_complete = false
	objective_changed.emit(current_objective, objective_complete)


func set_custom_objective(objective_text: String) -> void:
	current_objective = objective_text
	objective_complete = false
	objective_changed.emit(current_objective, objective_complete)


func complete_current_objective(message_text: String) -> void:
	if current_objective == "" or objective_complete:
		return

	objective_complete = true
	objective_changed.emit(current_objective, objective_complete)
	message_shown.emit(message_text)
