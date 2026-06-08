extends CanvasLayer

## Displays one simple NPC dialogue message at a time.

@onready var dialogue_panel: PanelContainer = $DialoguePanel
@onready var speaker_label: Label = $DialoguePanel/MarginContainer/DialogueContent/SpeakerLabel
@onready var dialogue_label: Label = $DialoguePanel/MarginContainer/DialogueContent/DialogueLabel
@onready var close_button: Button = $DialoguePanel/MarginContainer/DialogueContent/CloseButton


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	close_button.pressed.connect(close_dialogue)
	dialogue_panel.hide()


func _unhandled_input(event: InputEvent) -> void:
	if dialogue_panel.visible and event.is_action_pressed("ui_cancel"):
		close_dialogue()
		get_viewport().set_input_as_handled()


func show_dialogue(speaker_name: String, message: String) -> void:
	speaker_label.text = speaker_name
	dialogue_label.text = message
	dialogue_panel.show()
	get_tree().paused = true
	close_button.grab_focus()


func close_dialogue() -> void:
	dialogue_panel.hide()
	get_tree().paused = false
