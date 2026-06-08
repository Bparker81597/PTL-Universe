extends Node

## Stores investigation progress, discovered clues, and unlocked lore.

signal investigation_updated

const INVESTIGATION_TITLE := "The Corrupted Signal"
const REQUIRED_CLUE_IDS := ["signal_fragment_a", "signal_fragment_b", "signal_fragment_c"]
const STEP_INVESTIGATE_A := "investigate_clue_a"
const STEP_TALK_CODEVERSE := "talk_codeverse_mentor"
const STEP_TALK_NOVATONE := "talk_novatone_guide"
const STEP_TALK_NOVACANVAS := "talk_novacanvas_guide"
const STEP_RETURN_TO_HQ := "return_to_ptl_hq"

const STEP_OBJECTIVES := {
	STEP_INVESTIGATE_A: "Investigate clue A",
	STEP_TALK_CODEVERSE: "Talk to Codeverse Mentor",
	STEP_TALK_NOVATONE: "Talk to NovaTone Guide",
	STEP_TALK_NOVACANVAS: "Talk to NovaCanvas Guide",
	STEP_RETURN_TO_HQ: "Return to PTL HQ",
}

var active_investigation: String = INVESTIGATION_TITLE
var current_step: String = STEP_INVESTIGATE_A
var discovered_clues: Dictionary = {}
var talked_to_npcs: Dictionary = {}
var completed_investigations: Array[String] = []
var lore_entries: Array[String] = []
var glitch_discovered: bool = false


func discover_clue(clue_id: String, clue_title: String, lore_entry: String) -> void:
	if not can_discover_clue(clue_id):
		return

	_record_clue(clue_id, clue_title, lore_entry)
	current_step = STEP_TALK_CODEVERSE
	_set_chain_objective()
	ObjectiveManager.message_shown.emit("Signal Fragment A recovered. Talk to the Codeverse Mentor.")


func can_discover_clue(clue_id: String) -> bool:
	return (
		active_investigation == INVESTIGATION_TITLE
		and current_step == STEP_INVESTIGATE_A
		and clue_id == "signal_fragment_a"
		and not discovered_clues.has(clue_id)
	)


func complete_npc_step(step_id: String) -> void:
	if active_investigation != INVESTIGATION_TITLE or step_id != current_step:
		return

	talked_to_npcs[step_id] = true
	match step_id:
		STEP_TALK_CODEVERSE:
			_record_clue(
				"signal_fragment_b",
				"Signal Fragment B",
				"The Codeverse Mentor recognizes a pattern hidden inside the corrupted access record."
			)
			current_step = STEP_TALK_NOVATONE
			_set_chain_objective()
			ObjectiveManager.message_shown.emit("Signal Fragment B unlocked. Talk to the NovaTone Guide.")
		STEP_TALK_NOVATONE:
			_record_clue(
				"signal_fragment_c",
				"Signal Fragment C",
				"The unstable NovaTone frequencies identify the source behind the signal."
			)
			current_step = STEP_TALK_NOVACANVAS
			_set_chain_objective()
			ObjectiveManager.message_shown.emit("Signal Fragment C unlocked. Talk to the NovaCanvas Guide.")
		STEP_TALK_NOVACANVAS:
			current_step = STEP_RETURN_TO_HQ
			_set_chain_objective()
			ObjectiveManager.message_shown.emit("All clues connected. Return to PTL HQ.")


func on_world_loaded(world_name: String) -> void:
	if active_investigation == INVESTIGATION_TITLE:
		if current_step == STEP_RETURN_TO_HQ and world_name == "PTL_HQ":
			complete_investigation()
		else:
			_set_chain_objective()


func has_all_required_clues() -> bool:
	for clue_id in REQUIRED_CLUE_IDS:
		if not discovered_clues.has(clue_id):
			return false
	return true


func get_steps_text() -> String:
	var steps := [
		[STEP_INVESTIGATE_A, "Investigate clue A", discovered_clues.has("signal_fragment_a")],
		[STEP_TALK_CODEVERSE, "Talk to Codeverse Mentor and unlock clue B", discovered_clues.has("signal_fragment_b")],
		[STEP_TALK_NOVATONE, "Talk to NovaTone Guide and unlock clue C", discovered_clues.has("signal_fragment_c")],
		[STEP_TALK_NOVACANVAS, "Talk to NovaCanvas Guide", talked_to_npcs.has(STEP_TALK_NOVACANVAS)],
		[STEP_RETURN_TO_HQ, "Return to PTL HQ and discover GL!TCH", glitch_discovered],
	]

	var lines: Array[String] = []
	for index in steps.size():
		var status := "Complete" if steps[index][2] else "Pending"
		if steps[index][0] == current_step and not steps[index][2]:
			status = "Active"
		lines.append("%d. %s [%s]" % [index + 1, steps[index][1], status])
	return "\n".join(lines)


func complete_investigation() -> void:
	if completed_investigations.has(INVESTIGATION_TITLE):
		return

	glitch_discovered = true
	completed_investigations.append(INVESTIGATION_TITLE)
	active_investigation = ""
	ObjectiveManager.set_custom_objective(STEP_OBJECTIVES[STEP_RETURN_TO_HQ])
	ObjectiveManager.complete_current_objective("Unknown source detected: GL!TCH")
	investigation_updated.emit()


func _record_clue(clue_id: String, clue_title: String, lore_entry: String) -> void:
	discovered_clues[clue_id] = {
		"title": clue_title,
		"lore": lore_entry,
	}
	if lore_entry != "":
		lore_entries.append(lore_entry)
	investigation_updated.emit()


func _set_chain_objective() -> void:
	ObjectiveManager.set_custom_objective(STEP_OBJECTIVES[current_step])
