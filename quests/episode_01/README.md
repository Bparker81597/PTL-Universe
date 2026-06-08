# Episode 01: The Corrupted Signal

Episode 1 uses `InvestigationManager` as its persistent mission state tracker.

Mission order:

1. Talk to BrittanyVerse in PTL HQ.
2. Use The Nexus to travel to Codeverse City.
3. Talk to NateVerse.
4. Investigate the corrupted code panel.
5. Collect Signal Fragment A.
6. Return to PTL HQ.
7. Talk to BrittanyVerse again.

`SceneManager` reports world travel to `InvestigationManager`, NPC scenes report
configured conversation events, and the corrupted panel reports the clue. The
manager validates the active step before updating the objective UI or journal.

After the final BrittanyVerse conversation, `InvestigationManager` emits
`episode_completed`. The persistent `EpisodeCompletionUI` closes the dialogue,
plays the mission-complete fade sequence, shows the quest summary, and returns
the player to PTL HQ when Continue is pressed.
