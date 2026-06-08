extends Node

## Stores investigation progress, discovered clues, and unlocked lore.

signal investigation_updated

const INVESTIGATION_TITLE := "The Corrupted Signal"
const REQUIRED_CLUE_IDS := ["signal_fragment_a", "signal_fragment_b", "signal_fragment_c"]

var active_investigation: String = INVESTIGATION_TITLE
var discovered_clues: Dictionary = {}
var completed_investigations: Array[String] = []
var lore_entries: Array[String] = []


func discover_clue(clue_id: String, clue_title: String, lore_entry: String) -> void:
	if discovered_clues.has(clue_id):
		return

	discovered_clues[clue_id] = {
		"title": clue_title,
		"lore": lore_entry,
	}
	if lore_entry != "":
		lore_entries.append(lore_entry)

	investigation_updated.emit()

	if has_all_required_clues():
		ObjectiveManager.set_custom_objective("Return to PTL HQ")
		ObjectiveManager.message_shown.emit("All signal fragments recovered. Return to PTL HQ.")


func on_world_loaded(world_name: String) -> void:
	if completed_investigations.has(INVESTIGATION_TITLE):
		return

	if has_all_required_clues():
		if world_name == "PTL_HQ":
			complete_investigation()
		else:
			ObjectiveManager.set_custom_objective("Return to PTL HQ")


func has_all_required_clues() -> bool:
	for clue_id in REQUIRED_CLUE_IDS:
		if not discovered_clues.has(clue_id):
			return false
	return true


func get_steps_text() -> String:
	var steps := [
		["Investigate Codeverse panel", discovered_clues.has("signal_fragment_a")],
		["Investigate NovaTone console", discovered_clues.has("signal_fragment_b")],
		["Investigate NovaCanvas canvas", discovered_clues.has("signal_fragment_c")],
		["Return to PTL HQ", completed_investigations.has(INVESTIGATION_TITLE)],
	]

	var lines: Array[String] = []
	for index in steps.size():
		var status := "Complete" if steps[index][1] else "Pending"
		if index == 3 and has_all_required_clues() and not steps[index][1]:
			status = "Active"
		lines.append("%d. %s [%s]" % [index + 1, steps[index][0], status])
	return "\n".join(lines)


func complete_investigation() -> void:
	if completed_investigations.has(INVESTIGATION_TITLE):
		return

	completed_investigations.append(INVESTIGATION_TITLE)
	active_investigation = ""
	ObjectiveManager.set_custom_objective("Return to PTL HQ")
	ObjectiveManager.complete_current_objective("Unknown source detected: GLITCH")
	investigation_updated.emit()
