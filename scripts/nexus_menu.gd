extends CanvasLayer

## Controls the Nexus interaction prompt and the first placeholder travel menu.
## Destination buttons only print debug messages until real worlds are added.

@onready var prompt_panel: PanelContainer = $PromptPanel
@onready var prompt_label: Label = $PromptPanel/MarginContainer/PromptLabel
@onready var menu_overlay: ColorRect = $MenuOverlay
@onready var codeverse_button: Button = $MenuOverlay/CenterContainer/MenuPanel/MarginContainer/MenuContent/CodeverseButton
@onready var novatone_button: Button = $MenuOverlay/CenterContainer/MenuPanel/MarginContainer/MenuContent/NovaToneButton
@onready var novacanvas_button: Button = $MenuOverlay/CenterContainer/MenuPanel/MarginContainer/MenuContent/NovaCanvasButton
@onready var cancel_button: Button = $MenuOverlay/CenterContainer/MenuPanel/MarginContainer/MenuContent/CancelButton

var player_is_nearby: bool = false


func _ready() -> void:
	codeverse_button.pressed.connect(_on_destination_selected.bind("Codeverse City"))
	novatone_button.pressed.connect(_on_destination_selected.bind("NovaTone Studio"))
	novacanvas_button.pressed.connect(_on_destination_selected.bind("NovaCanvas Loft"))
	cancel_button.pressed.connect(close_menu)

	prompt_panel.hide()
	menu_overlay.hide()


func _unhandled_input(event: InputEvent) -> void:
	# Escape closes the travel menu without selecting a destination.
	if menu_overlay.visible and event.is_action_pressed("ui_cancel"):
		close_menu()
		get_viewport().set_input_as_handled()


func set_interaction_prompt(is_visible: bool, message: String) -> void:
	player_is_nearby = is_visible
	prompt_label.text = message
	prompt_panel.visible = is_visible and not menu_overlay.visible


func open_menu() -> void:
	if menu_overlay.visible:
		return

	prompt_panel.hide()
	menu_overlay.show()
	codeverse_button.grab_focus()
	get_tree().paused = true


func close_menu() -> void:
	get_tree().paused = false
	menu_overlay.hide()
	prompt_panel.visible = player_is_nearby


func _on_destination_selected(destination_name: String) -> void:
	print("Nexus travel selected: %s" % destination_name)
	close_menu()
