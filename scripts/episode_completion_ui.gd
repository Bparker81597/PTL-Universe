extends CanvasLayer

## Presents the Episode 1 completion banner and investigation summary.

@onready var mission_complete_overlay: ColorRect = $MissionCompleteOverlay
@onready var summary_overlay: ColorRect = $SummaryOverlay
@onready var clues_label: Label = $SummaryOverlay/CenterContainer/SummaryPanel/MarginContainer/SummaryContent/QuestSummary/QuestSummaryContent/CluesLabel
@onready var npcs_label: Label = $SummaryOverlay/CenterContainer/SummaryPanel/MarginContainer/SummaryContent/QuestSummary/QuestSummaryContent/NPCsLabel
@onready var completion_label: Label = $SummaryOverlay/CenterContainer/SummaryPanel/MarginContainer/SummaryContent/QuestSummary/QuestSummaryContent/CompletionLabel
@onready var continue_button: Button = $SummaryOverlay/CenterContainer/SummaryPanel/MarginContainer/SummaryContent/ContinueButton
@onready var mission_complete_sfx: AudioStreamPlayer = $MissionCompleteSFX

var completion_sequence_running: bool = false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	InvestigationManager.episode_completed.connect(_on_episode_completed)
	continue_button.pressed.connect(_on_continue_pressed)
	mission_complete_overlay.hide()
	summary_overlay.hide()


func _on_episode_completed(_episode_title: String) -> void:
	call_deferred("_show_completion_sequence")


func _show_completion_sequence() -> void:
	if completion_sequence_running:
		return

	completion_sequence_running = true
	_close_open_dialogue()
	get_tree().paused = true

	mission_complete_overlay.modulate.a = 0.0
	mission_complete_overlay.show()
	if mission_complete_sfx.stream != null:
		mission_complete_sfx.play()

	var tween := create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(mission_complete_overlay, "modulate:a", 1.0, 0.6)
	tween.tween_interval(1.2)
	tween.tween_property(mission_complete_overlay, "modulate:a", 0.0, 0.6)
	await tween.finished

	mission_complete_overlay.hide()
	_refresh_summary()
	summary_overlay.show()
	continue_button.grab_focus()


func _refresh_summary() -> void:
	clues_label.text = "Clues Discovered\n%s" % _format_discovered_clues()
	npcs_label.text = "NPCs Spoken To\n%s" % _format_spoken_npcs()
	completion_label.text = "Investigation Completion\n- %s [Complete]" % InvestigationManager.INVESTIGATION_TITLE


func _on_continue_pressed() -> void:
	summary_overlay.hide()
	completion_sequence_running = false
	get_tree().paused = false
	SceneManager.return_to_ptl_hq()


func _close_open_dialogue() -> void:
	var dialogue_ui := get_tree().get_first_node_in_group("dialogue_ui")
	if dialogue_ui != null and dialogue_ui.has_method("close_dialogue"):
		dialogue_ui.close_dialogue()


func _format_discovered_clues() -> String:
	if InvestigationManager.discovered_clues.is_empty():
		return "- None"

	var lines: Array[String] = []
	for clue_data in InvestigationManager.discovered_clues.values():
		lines.append("- %s" % clue_data["title"])
	return "\n".join(lines)


func _format_spoken_npcs() -> String:
	var lines: Array[String] = []
	if (
		InvestigationManager.talked_to_npcs.has(InvestigationManager.STEP_TALK_BRITTANY_START)
		or InvestigationManager.talked_to_npcs.has(InvestigationManager.STEP_TALK_BRITTANY_END)
	):
		lines.append("- BrittanyVerse")
	if InvestigationManager.talked_to_npcs.has(InvestigationManager.STEP_TALK_NATE):
		lines.append("- NateVerse")
	if lines.is_empty():
		return "- None"
	return "\n".join(lines)
