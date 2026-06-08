extends CanvasLayer

## Opens with Tab and summarizes investigation progress.

@onready var journal_overlay: ColorRect = $JournalOverlay
@onready var active_label: Label = $JournalOverlay/CenterContainer/JournalPanel/MarginContainer/JournalContent/ActiveInvestigationLabel
@onready var clues_label: Label = $JournalOverlay/CenterContainer/JournalPanel/MarginContainer/JournalContent/CluesLabel
@onready var completed_label: Label = $JournalOverlay/CenterContainer/JournalPanel/MarginContainer/JournalContent/CompletedLabel
@onready var lore_label: Label = $JournalOverlay/CenterContainer/JournalPanel/MarginContainer/JournalContent/LoreLabel
@onready var close_button: Button = $JournalOverlay/CenterContainer/JournalPanel/MarginContainer/JournalContent/CloseButton


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	close_button.pressed.connect(close_journal)
	InvestigationManager.investigation_updated.connect(refresh_journal)
	journal_overlay.hide()
	refresh_journal()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("investigation_journal"):
		if get_tree().paused and not journal_overlay.visible:
			return
		toggle_journal()
		get_viewport().set_input_as_handled()
	elif journal_overlay.visible and event.is_action_pressed("ui_cancel"):
		close_journal()
		get_viewport().set_input_as_handled()


func toggle_journal() -> void:
	if journal_overlay.visible:
		close_journal()
	else:
		open_journal()


func open_journal() -> void:
	refresh_journal()
	journal_overlay.show()
	get_tree().paused = true
	close_button.grab_focus()


func close_journal() -> void:
	get_tree().paused = false
	journal_overlay.hide()


func refresh_journal() -> void:
	var active_text := InvestigationManager.active_investigation
	if active_text == "":
		active_text = "None"
	active_label.text = "Active Investigation\n%s\n%s" % [active_text, InvestigationManager.get_steps_text()]

	clues_label.text = "Discovered Clues\n%s" % _format_clues()
	completed_label.text = "Completed Investigations\n%s" % _format_completed()
	lore_label.text = "Lore Entries\n%s" % _format_lore()


func _format_clues() -> String:
	if InvestigationManager.discovered_clues.is_empty():
		return "- No clues discovered"

	var lines: Array[String] = []
	for clue_id in InvestigationManager.REQUIRED_CLUE_IDS:
		if InvestigationManager.discovered_clues.has(clue_id):
			lines.append("- %s" % InvestigationManager.discovered_clues[clue_id]["title"])
		else:
			lines.append("- Unknown signal fragment")
	return "\n".join(lines)


func _format_completed() -> String:
	if InvestigationManager.completed_investigations.is_empty():
		return "- None"

	var lines: Array[String] = []
	for investigation_name in InvestigationManager.completed_investigations:
		lines.append("- %s" % investigation_name)
	return "\n".join(lines)


func _format_lore() -> String:
	if InvestigationManager.lore_entries.is_empty():
		return "- No lore entries unlocked"

	var lines: Array[String] = []
	for lore_entry in InvestigationManager.lore_entries:
		lines.append("- %s" % lore_entry)
	return "\n".join(lines)
