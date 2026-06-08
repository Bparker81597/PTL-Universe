extends CanvasLayer

## Controls the Nexus interaction prompt and travel menu.

const CODEVERSE_CITY_PATH := "res://scenes/worlds/codeverse_city/CodeverseCity.tscn"
const NOVATONE_STUDIO_PATH := "res://scenes/worlds/novatone_studio/NovaToneStudio.tscn"
const NOVACANVAS_LOFT_PATH := "res://scenes/worlds/novacanvas_loft/NovaCanvasLoft.tscn"
const WONDER_LABS_PATH := "res://scenes/worlds/wonder_labs/WonderLabs.tscn"

@onready var prompt_panel: PanelContainer = $PromptPanel
@onready var prompt_label: Label = $PromptPanel/MarginContainer/PromptLabel
@onready var menu_overlay: ColorRect = $MenuOverlay
@onready var codeverse_button: Button = $MenuOverlay/CenterContainer/MenuPanel/MarginContainer/MenuContent/CodeverseButton
@onready var novatone_button: Button = $MenuOverlay/CenterContainer/MenuPanel/MarginContainer/MenuContent/NovaToneButton
@onready var novacanvas_button: Button = $MenuOverlay/CenterContainer/MenuPanel/MarginContainer/MenuContent/NovaCanvasButton
@onready var wonder_labs_button: Button = $MenuOverlay/CenterContainer/MenuPanel/MarginContainer/MenuContent/WonderLabsButton
@onready var cancel_button: Button = $MenuOverlay/CenterContainer/MenuPanel/MarginContainer/MenuContent/CancelButton

var player_is_nearby: bool = false


func _ready() -> void:
	codeverse_button.pressed.connect(_on_destination_selected.bind(CODEVERSE_CITY_PATH))
	novatone_button.pressed.connect(_on_destination_selected.bind(NOVATONE_STUDIO_PATH))
	novacanvas_button.pressed.connect(_on_destination_selected.bind(NOVACANVAS_LOFT_PATH))
	wonder_labs_button.pressed.connect(_on_destination_selected.bind(WONDER_LABS_PATH))
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


func _on_destination_selected(world_scene_path: String) -> void:
	set_interaction_prompt(false, "")
	close_menu()
	SceneManager.travel_to(world_scene_path)
