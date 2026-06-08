extends Node

## Tracks Episode 1 mission progress, discovered clues, and unlocked lore.

signal investigation_updated

const INVESTIGATION_TITLE := "The Corrupted Signal"
const REQUIRED_CLUE_IDS := ["signal_fragment_a"]
const STEP_TALK_BRITTANY_START := "talk_brittany_start"
const STEP_USE_NEXUS := "use_nexus_to_codeverse"
const STEP_TALK_NATE := "talk_nateverse"
const STEP_INVESTIGATE_PANEL := "investigate_corrupted_panel"
const STEP_RETURN_TO_HQ := "return_to_ptl_hq"
const STEP_TALK_BRITTANY_END := "talk_brittany_end"
const NPC_EVENT_BRITTANY := "talk_brittanyverse"
const NPC_EVENT_NATE := "talk_nateverse"

const STEP_OBJECTIVES := {
	STEP_TALK_BRITTANY_START: "Talk to BrittanyVerse",
	STEP_USE_NEXUS: "Use The Nexus to travel to Codeverse City.",
	STEP_TALK_NATE: "Talk to NateVerse",
	STEP_INVESTIGATE_PANEL: "Investigate the corrupted code panel.",
	STEP_RETURN_TO_HQ: "Return to PTL HQ",
	STEP_TALK_BRITTANY_END: "Talk to BrittanyVerse",
}

var active_investigation: String = INVESTIGATION_TITLE
var current_step: String = STEP_TALK_BRITTANY_START
var discovered_clues: Dictionary = {}
var talked_to_npcs: Dictionary = {}
var completed_investigations: Array[String] = []
var lore_entries: Array[String] = []


func discover_clue(clue_id: String, clue_title: String, lore_entry: String) -> void:
	if not can_discover_clue(clue_id):
		return

	_record_clue(clue_id, clue_title, lore_entry)
	current_step = STEP_RETURN_TO_HQ
	_set_chain_objective()
	ObjectiveManager.message_shown.emit("Signal Fragment A recovered. Return to PTL HQ.")


func can_discover_clue(clue_id: String) -> bool:
	return (
		active_investigation == INVESTIGATION_TITLE
		and current_step == STEP_INVESTIGATE_PANEL
		and clue_id == "signal_fragment_a"
		and not discovered_clues.has(clue_id)
	)


func complete_npc_step(npc_event_id: String) -> void:
	if active_investigation != INVESTIGATION_TITLE:
		return

	match current_step:
		STEP_TALK_BRITTANY_START:
			if npc_event_id != NPC_EVENT_BRITTANY:
				return
			talked_to_npcs[STEP_TALK_BRITTANY_START] = true
			current_step = STEP_USE_NEXUS
			_set_chain_objective()
		STEP_TALK_NATE:
			if npc_event_id != NPC_EVENT_NATE:
				return
			talked_to_npcs[STEP_TALK_NATE] = true
			current_step = STEP_INVESTIGATE_PANEL
			_set_chain_objective()
		STEP_TALK_BRITTANY_END:
			if npc_event_id != NPC_EVENT_BRITTANY:
				return
			talked_to_npcs[STEP_TALK_BRITTANY_END] = true
			complete_investigation()


func on_world_loaded(world_name: String) -> void:
	if active_investigation != INVESTIGATION_TITLE:
		return

	if current_step == STEP_USE_NEXUS and world_name == "CodeverseCity":
		current_step = STEP_TALK_NATE
	elif current_step == STEP_RETURN_TO_HQ and world_name == "PTL_HQ":
		current_step = STEP_TALK_BRITTANY_END
	_set_chain_objective()


func has_all_required_clues() -> bool:
	for clue_id in REQUIRED_CLUE_IDS:
		if not discovered_clues.has(clue_id):
			return false
	return true


func get_steps_text() -> String:
	var steps := [
		[STEP_TALK_BRITTANY_START, "Talk to BrittanyVerse", talked_to_npcs.has(STEP_TALK_BRITTANY_START)],
		[STEP_USE_NEXUS, "Use The Nexus to travel to Codeverse City", _has_reached_codeverse()],
		[STEP_TALK_NATE, "Talk to NateVerse", talked_to_npcs.has(STEP_TALK_NATE)],
		[STEP_INVESTIGATE_PANEL, "Investigate the corrupted code panel", discovered_clues.has("signal_fragment_a")],
		[STEP_RETURN_TO_HQ, "Return to PTL HQ", _has_returned_to_hq()],
		[STEP_TALK_BRITTANY_END, "Talk to BrittanyVerse again", completed_investigations.has(INVESTIGATION_TITLE)],
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

	completed_investigations.append(INVESTIGATION_TITLE)
	active_investigation = ""
	ObjectiveManager.set_custom_objective(STEP_OBJECTIVES[STEP_TALK_BRITTANY_END])
	ObjectiveManager.complete_current_objective("The signal is spreading. The investigation has begun.")
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


func _has_reached_codeverse() -> bool:
	return current_step not in [STEP_TALK_BRITTANY_START, STEP_USE_NEXUS]


func _has_returned_to_hq() -> bool:
	return current_step == STEP_TALK_BRITTANY_END or completed_investigations.has(INVESTIGATION_TITLE)
