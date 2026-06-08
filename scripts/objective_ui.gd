extends CanvasLayer

## Displays the active objective and short interaction messages.

@onready var objective_label: Label = $ObjectivePanel/MarginContainer/ObjectiveLabel
@onready var message_panel: PanelContainer = $MessagePanel
@onready var message_label: Label = $MessagePanel/MarginContainer/MessageLabel
@onready var message_timer: Timer = $MessageTimer


func _ready() -> void:
	ObjectiveManager.objective_changed.connect(_on_objective_changed)
	ObjectiveManager.message_shown.connect(_on_message_shown)
	message_timer.timeout.connect(_on_message_timer_timeout)
	message_panel.hide()

	_on_objective_changed(ObjectiveManager.current_objective, ObjectiveManager.objective_complete)


func _on_objective_changed(objective_text: String, is_complete: bool) -> void:
	if objective_text == "":
		objective_label.text = "Objective: None"
		return

	var status := "Complete" if is_complete else "Active"
	objective_label.text = "Objective: %s\nStatus: %s" % [objective_text, status]


func _on_message_shown(message_text: String) -> void:
	message_label.text = message_text
	message_panel.show()
	message_timer.start()


func _on_message_timer_timeout() -> void:
	message_panel.hide()
