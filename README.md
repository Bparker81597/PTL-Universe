# PTL Universe

PTL Universe is a small Godot 4 third-person exploration prototype for the Parker Tech Labs Universe.

This first version intentionally stays small. It includes a basic PTL HQ lobby, a placeholder player, simple third-person camera setup, WASD movement, jump, basic lighting, a placeholder portal called **The Nexus**, and a starter UI label.

The Nexus now travels to four small placeholder worlds: Codeverse City, NovaTone Studio, NovaCanvas Loft, and Wonder Labs. Each destination includes a walk-in portal back to PTL HQ.

The prototype also includes a simple objective UI. The first investigation drives the active objective while its mystery is in progress.

The first investigation, **The Corrupted Signal**, follows this chain: investigate clue A, talk to Codeverse Mentor, talk to NovaTone Guide, talk to NovaCanvas Guide, then return to PTL HQ to reveal **GL!TCH**. Press `Tab` to open the Investigation Journal.

Placeholder cast scenes are available for BrittanyVerse, NateVerse, BrooklynVerse, MaizeVerse, and Gl!tch. The first four are placed as interactable NPCs; Gl!tch remains hidden and non-interactable.

Quaternius Sci-Fi Essentials glTF props are imported under `assets/quaternius/sci_fi_essentials/` and used as environmental storytelling props in PTL HQ, Codeverse City, and Wonder Labs. No weapon models or combat systems were added.

## Open The Project

Open this folder in Godot 4:

```text
/Users/mymac/PTL-Universe
```

The main scene is:

```text
res://scenes/main/Main.tscn
```

## Controls

- `W` moves forward.
- `A` moves left.
- `S` moves backward.
- `D` moves right.
- `Space` jumps.
- `E` interacts with The Nexus when nearby.
- `Escape` closes the Nexus travel menu.
- `Tab` opens or closes the Investigation Journal.

## Learning Notes

Read `docs/prototype_overview.md` for a breakdown of each scene, node, and script.
