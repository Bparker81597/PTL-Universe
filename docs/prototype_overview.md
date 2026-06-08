# PTL Universe Prototype Overview

This project is a small Godot 4 third-person exploration prototype for the Parker Tech Labs Universe.

## Folder Structure

- `res://scenes/main/` contains the main entry scene that starts the prototype.
- `res://scenes/worlds/` contains world or level scenes, starting with the PTL HQ lobby.
- `res://scenes/characters/` contains character scenes, starting with the player.
- `res://scenes/ui/` contains UI scenes, starting with the prototype title label.
- `res://scripts/` contains reusable GDScript files.
- `res://assets/models/`, `res://assets/textures/`, `res://assets/audio/`, and `res://assets/animations/` are ready for future art and audio.
- `res://assets/quaternius/sci_fi_essentials/` contains selected Quaternius Sci-Fi Essentials glTF props for placeholder environmental storytelling.
- `res://systems/portals/`, `res://systems/dialogue/`, and `res://systems/quests/` are placeholders for future gameplay systems.
- `res://characters/` contains future character folders for Brittanyverse, Nateverse, Brooklynverse, Maizeverse, and GL!TCH.
- `res://worlds/` contains future content folders for PTL HQ, Codeverse, NovaTone, NovaCanvas, and DreamFrame.
- `res://quests/` contains future quest folders for `episode_01` and `episode_02`.
- `res://docs/` contains project notes and learning references.

## Main.tscn

`Main.tscn` is the scene Godot runs first.

- `Main` is the root `Node3D`.
- `WorldContainer` holds exactly one active world scene. `SceneManager` replaces its child when the player travels.
- `PTL_HQ` is the first child of `WorldContainer`, so the prototype still starts inside headquarters.
- `Player` instances `Player.tscn`, which gives you a controllable third-person character.
- `SunLight` is a `DirectionalLight3D` that gives the room basic global lighting.
- `PrototypeUI` instances the UI scene with the title label.
- `ObjectiveUI` instances `ObjectiveUI.tscn`, which shows the active objective and short interaction messages.
- `NexusMenu` instances `nexus_menu.tscn`, which owns the interaction prompt and travel menu.
- `InvestigationJournal` instances `InvestigationJournal.tscn`, which opens with Tab and summarizes clues, lore, and investigation progress.
- `DialogueWindow` instances `DialogueWindow.tscn`, which stays available while worlds are swapped and displays NPC conversations.
- `main.gd` registers `WorldContainer` and the persistent player with `SceneManager` when the game starts.

## PTL_HQ.tscn

`PTL_HQ.tscn` is the first placeholder world scene. It is still made from simple Godot primitives, but it is arranged to feel more like a futuristic Parker Tech Labs HQ.

- `PTL_HQ` is the root `Node3D` for the lobby.
- `SpawnPoint` is where the persistent player appears after returning from another world.
- `WorldEnvironment` sets the dark ambient background color and enables a small glow effect for emissive materials.
- `Architecture` groups the physical floor, walls, entry header, center floor path, and Nexus room dividers.
- `Floor` is a large `StaticBody3D` with collision, while `LobbyFloorInset`, `NexusFloorInset`, `CenterPathFloor`, `CenterPathTealLine`, and `CenterPathPurpleLine` create simple primitive floor materials and a guided path toward the portal.
- `BackWall`, `LeftWall`, `RightWall`, and `FrontEntryHeader` are large placeholder walls that define the HQ space.
- `NexusRoomDividerLeft` and `NexusRoomDividerRight` frame the opening from the lobby into the portal room.
- `Lighting` groups teal and purple lobby lights, the Nexus room light, reception fill light, ceiling light panels, and ceiling ribs.
- `PTLLogoWall` contains the wall backing panel plus `Label3D` text for `PTL` and `PARKER TECH LABS`.
- `ReceptionDesk` is built from box meshes for the base, desktop, glowing front strip, and transparent placeholder display screen.
- `LobbyDetails` adds placeholder columns, wall accent strips, and angled architectural fins to make the lobby feel more futuristic while keeping it open.
- `TheNexusRoom` sits at the far end and contains the larger portal platform, glowing portal core, portal rings, purple back glow, portal light, support columns, and side accent strips.
- `InteractionArea` is an `Area3D` under `TheNexus`. It detects the player without physically blocking movement.
- `InteractionArea/CollisionShape3D` uses a large sphere to define how close the player must be before the prompt appears.
- Pressing `E` at `InteractionArea` completes the PTL HQ objective, opens the Nexus menu, and lets the player choose a destination.
- `QuaterniusOfficeProps` instances imported `Prop_Desk_L`, `Prop_Chair`, `Prop_Locker`, `Prop_Shelves_WideTall`, and `Prop_Shelves_ThinTall` models.
- `BrittanyVerse` is an interactable placeholder cast member near the lobby operations area.

## Player.tscn

`Player.tscn` is the controllable third-person character.

- `Player` is a `CharacterBody3D`, which is Godot's standard 3D character movement node.
- The `Player` node belongs to the `player` group so interactable objects can identify it without depending on a specific scene path.
- `CollisionShape3D` gives the player physical collision.
- `Body` is a placeholder capsule mesh so you can see the character.
- `CameraPivot` is a `Node3D` that holds the camera setup.
- `SpringArm3D` keeps the camera behind the player and can help avoid clipping into walls later.
- `Camera3D` is the active camera used while playing.

## PrototypeUI.tscn

`PrototypeUI.tscn` keeps interface elements separate from the 3D world.

- `PrototypeUI` is a `CanvasLayer`, so its children draw on top of the 3D scene.
- `TitleLabel` displays `PTL Universe Prototype`.

## NPC_Base.tscn

`NPC_Base.tscn` is the reusable starting point for non-player characters.

- `NPC_Base` is the root `Node3D`. A world can instance this scene and change its exported name, prompt, and dialogue without editing the base scene.
- `Body` is a capsule mesh and `Head` is a sphere mesh, keeping the NPC placeholder-friendly and easy to replace later.
- `NameLabel` is a `Label3D` above the character. `NPC_Base.gd` updates it from the exported `npc_name`.
- `InteractionArea` is an `Area3D` that detects when the player is close enough to talk.
- `InteractionArea/CollisionShape3D` uses a cylinder-shaped interaction range and does not physically block the player.

## NPC_Base.gd

`NPC_Base.gd` controls every instance of the reusable NPC scene.

- `npc_name`, both dialogue lines, `dialogue_clue_id`, `interaction_prompt`, and `investigation_step_id` are exported properties, so each NPC can be configured in its world scene.
- `_ready()` updates the floating name, connects the interaction area, and finds the shared prompt and dialogue UI through groups.
- `_on_body_entered()` checks for the `player` group and shows `Press E to talk to [name]`.
- `_unhandled_input()` opens the dialogue window when the player is nearby and presses `E`, then asks `InvestigationManager` whether the conversation advances the chain.
- `_on_body_exited()` hides the prompt when the player walks away.
- `_get_current_dialogue()` chooses the before-clue or after-clue line based on whether the configured clue has been discovered.

## Placeholder Cast Scenes

Each main cast scene instances `NPC_Base.tscn`, so it automatically has a floating name, proximity prompt, and dialogue support.

- `characters/brittanyverse/BrittanyVerse.tscn` uses a purple capsule body and teal glowing head. BrittanyVerse is placed in PTL HQ.
- `characters/nateverse/NateVerse.tscn` uses a blue capsule body and cyan glowing head. NateVerse is placed in Codeverse City.
- `characters/brooklynverse/BrooklynVerse.tscn` uses a pink capsule body and lavender glowing head. BrooklynVerse is placed in NovaCanvas Loft.
- `characters/maizeverse/MaizeVerse.tscn` uses a blue-green capsule body and white glowing head. MaizeVerse is placed in Wonder Labs.
- `characters/glitch/Glitch.tscn` uses a black capsule body and red glowing head. Gl!tch is hidden, has processing disabled, and has its interaction area disabled until a later reveal.

Future character art can replace the primitive `Body` and `Head` meshes without rewriting interaction code.

## DialogueWindow.tscn

`DialogueWindow.tscn` is the simple persistent conversation UI.

- `DialogueWindow` is a `CanvasLayer` in the `dialogue_ui` group, so NPCs can find it without fragile node paths.
- `DialoguePanel` anchors a compact dialogue box near the bottom-center of the screen.
- `SpeakerLabel` displays the NPC name and `DialogueLabel` displays the configured dialogue text.
- `CloseButton` closes the conversation and returns control to the player.

## dialogue_window.gd

`dialogue_window.gd` controls the shared dialogue window.

- `show_dialogue()` fills in the speaker and message, shows the panel, focuses the Close button, and pauses the 3D world.
- `close_dialogue()` hides the panel and unpauses the world.
- `_unhandled_input()` lets Escape close an open conversation.

## nexus_menu.tscn

`nexus_menu.tscn` is a separate reusable UI scene for Nexus interactions.

- `NexusMenu` is a `CanvasLayer` in the `nexus_menu` group. The portal finds it through this group instead of using a fragile cross-scene node path.
- `NexusMenu` always processes input, which lets its Cancel button and Escape key work while the rest of the scene tree is paused.
- `PromptPanel` appears near the bottom of the screen when the player enters the portal interaction area.
- `PromptLabel` displays `Press E to access The Nexus`.
- `MenuOverlay` adds a dark background behind the travel menu and starts hidden.
- `CenterContainer` keeps the menu centered at different window sizes.
- `MenuPanel` visually frames the travel options.
- `MenuContent` is a `VBoxContainer` that stacks the title, instructions, and buttons.
- `CodeverseButton`, `NovaToneButton`, `NovaCanvasButton`, and `WonderLabsButton` are placeholder destination choices.
- `CancelButton` closes the menu without selecting a destination.

## Placeholder World Scenes

Each placeholder world follows the same small structure so future worlds remain predictable.

- `CodeverseCity.tscn` uses a dark metallic floor, cyan/blue grid strips, digital skyline blocks, floating hologram quads, code labels, and a holographic district sign.
- `NovaToneStudio.tscn` uses purple/blue lighting, a primitive mixing desk with glowing faders, speaker cabinets with cylinder woofers, and a large soundwave panel built from box bars.
- `NovaCanvasLoft.tscn` uses warm pink/purple/teal lighting, primitive wood easels, glowing canvases, a large painted back canvas, and suspended sphere meshes as placeholder floating paint particles.
- `WonderLabs.tscn` uses Quaternius sci-fi props and a primitive scanner platform to block out a future lab destination.
- Each world root is a `Node3D` loaded into `Main/WorldContainer`.
- Each `SpawnPoint` is a `Marker3D` that tells `SceneManager` where to place the persistent player.
- Each `Floor` is a `StaticBody3D` with a collision shape and visible primitive mesh.
- Each lighting node and `WorldEnvironment` gives the placeholder world its own atmosphere.
- Each `WorldName` is a `Label3D` that clearly identifies the loaded destination.
- Each `ReturnPortal` instances the shared `systems/portals/ReturnPortal.tscn`.
- Codeverse contains the first clue object. NovaTone and NovaCanvas keep placeholder interactable props for future use.

### Codeverse City Visual Groups

- `GridLines` groups thin emissive box meshes arranged across the dark floor.
- `DigitalSkyline` groups simple box towers and bright facade accents.
- `FloatingCodePanels` combines transparent `QuadMesh` panels with `Label3D` code text.
- `HolographicSign` is a standalone glowing `Label3D` that helps the space read like a digital district.
- `QuaterniusTechProps` instances `Prop_Crate`, `Prop_Crate_Large`, `Prop_Crate_Tarp`, `Prop_SatelliteDish`, `Prop_Barrel1`, and `Enemy_EyeDrone`.
- `StaticEyeDroneScanner` uses the EyeDrone model only as a non-moving scanner prop.
- `CorruptedCodePanel` is an `Area3D` clue object near the left code panel. It unlocks `Signal Fragment A`.
- `CodeverseMentor` says `Something is corrupting the city systems.` before clue A and `This signal is spreading beyond Codeverse.` after clue A. The after-clue conversation unlocks `Signal Fragment B`.
- `NateVerse` is an additional interactable cast member placed away from the investigation mentor.

### NovaTone Studio Visual Groups

- `MixingDesk` groups the desk base, angled control surface, and glowing box-mesh faders.
- `Speakers` groups dark box cabinets with emissive cylinder meshes used as placeholder woofers.
- `SoundwavePanel` uses a dark backing panel and differently sized emissive bars to form a readable soundwave.
- `Lighting` combines purple and blue `OmniLight3D` nodes to create a studio atmosphere.
- `MusicConsole` remains a simple placeholder interactable around the mixing desk.
- `NovaToneGuide` says `The frequencies feel unstable.` before clue B and `This distortion sounds like corrupted code.` after clue B. The after-clue conversation unlocks `Signal Fragment C`.

### NovaCanvas Loft Visual Groups

- `Easels` groups thin wood-colored box meshes and glowing canvas panels.
- `BackCanvas` is a large neutral box panel decorated with pink and teal primitive strokes.
- `FloatingPaintParticles` groups small emissive sphere meshes suspended around the room.
- `Lighting` combines a warm directional key light with pink and teal fill lights.
- `GlowingCanvas` remains a simple placeholder interactable around the large back canvas.
- `NovaCanvasGuide` says `The canvas keeps reacting to invisible energy.` before clue C and `This energy feels alive.` after clue C. The after-clue conversation sets the objective to `Return to PTL HQ`.
- `BrooklynVerse` is an additional interactable cast member in the open studio area.

### Wonder Labs Visual Groups

- `ScannerPlatform` is a primitive glowing platform that frames the lab props.
- `QuaterniusLabProps` instances `Prop_Desk_Medium`, `Prop_Chair`, `Prop_Shelves_WideTall`, `Prop_Shelves_WideShort`, `Prop_KeyCard`, `Prop_Chest`, `Prop_HealthPack_Tube`, and `Prop_Syringe`.
- `AccessKeycard`, `ScannerHealthTube`, and `ScannerSyringe` are visual storytelling props only.
- `ReturnPortal` keeps the same portal-back-to-PTL-HQ behavior as the other placeholder worlds.
- `MaizeVerse` is an interactable cast member near the scanner platform. The existing lab floor provides enough room, so no additional room was needed.

## Quaternius Sci-Fi Essentials Assets

The imported kit assets live under `res://assets/quaternius/sci_fi_essentials/`.

- The original `License_Standard.txt` is included as `LICENSE.txt`.
- The project uses glTF models first, with their `.bin` files and required texture atlases kept beside them.
- Imported office props: `Prop_Desk_L`, `Prop_Desk_Medium`, `Prop_Desk_Small`, `Prop_Chair`, `Prop_Locker`, `Prop_Shelves_WideTall`, `Prop_Shelves_WideShort`, and `Prop_Shelves_ThinTall`.
- Imported tech props: `Prop_Crate`, `Prop_Crate_Large`, `Prop_Crate_Tarp`, `Prop_SatelliteDish`, `Prop_Barrel1`, and `Enemy_EyeDrone`.
- Imported lab props: `Prop_KeyCard`, `Prop_Chest`, `Prop_HealthPack_Tube`, and `Prop_Syringe`.
- No gun models are imported or used.

## ReturnPortal.tscn

`ReturnPortal.tscn` is a reusable walk-in portal shared by all placeholder worlds.

- `ReturnPortal` is an `Area3D` that detects the player without blocking movement.
- `CollisionShape3D` defines the walk-in detection area.
- `PortalRing`, `PortalCore`, and `PortalLight` create a visible placeholder portal from Godot primitives.
- `ReturnLabel` identifies the portal as the route back to PTL HQ.
- `return_portal.gd` checks for the `player` group and asks `SceneManager` to load PTL HQ.

## ObjectiveUI.tscn

`ObjectiveUI.tscn` is the persistent objective display.

- `ObjectiveUI` is a `CanvasLayer`, so it stays on top of the 3D world.
- `ObjectivePanel` sits in the top-left corner and displays the current objective plus its status.
- `MessagePanel` appears near the bottom of the screen when an objective interaction shows feedback.
- `MessageTimer` hides the message after a few seconds.

## InvestigationJournal.tscn

`InvestigationJournal.tscn` is the persistent investigation screen opened with Tab.

- `JournalOverlay` darkens the screen while the journal is open.
- `JournalPanel` contains the readable journal layout.
- `ActiveInvestigationLabel` shows the current investigation, starting with `The Corrupted Signal`.
- The active section shows the sequential investigation steps and their Pending, Active, or Complete state.
- `CluesLabel` lists discovered signal fragments and hides undiscovered clue names.
- `CompletedLabel` lists finished investigations.
- `LoreLabel` lists lore entries unlocked by world interactions.
- `CloseButton`, Tab, or Escape closes the journal.
- The journal pauses the 3D world while open and will not open on top of another paused menu.

## investigation_journal.gd

`investigation_journal.gd` controls the journal UI.

- `_unhandled_input()` listens for the `investigation_journal` action mapped to Tab.
- `open_journal()` refreshes the journal, displays it, and pauses the world.
- `close_journal()` hides the journal and unpauses the world.
- `refresh_journal()` rebuilds the active investigation, clue, completion, and lore text from `InvestigationManager`.

## objective_manager.gd

`objective_manager.gd` is an autoload, so it persists while worlds are swapped.

- `WORLD_OBJECTIVES` maps each world root name to its objective text.
- `set_world_objective()` is called by `SceneManager` after each world loads, then the active investigation can replace it with the current chain objective.
- `complete_current_objective()` marks the active objective complete and broadcasts a short message to the UI.
- `set_custom_objective()` lets the investigation system replace a world objective with `Return to PTL HQ`.
- `objective_changed` tells `ObjectiveUI` when to redraw the objective text.
- `message_shown` tells `ObjectiveUI` when to show an interaction message.

## objective_interactable.gd

`objective_interactable.gd` is a reusable script for simple objective objects.

- It extends `Area3D`, so each objective object can detect when the player is nearby.
- `interaction_prompt` controls the prompt shown while the player is close.
- `completion_message` controls the message shown after pressing `E`.
- `_unhandled_input()` listens for the shared `interact` action and completes the current objective.
- The script reuses the existing Nexus prompt UI so there is one consistent `Press E` prompt style.
- Optional clue fields tell `InvestigationManager` what clue and lore entry to unlock.
- Clue objects only work when `InvestigationManager` says that clue is the active step, so out-of-order interactions cannot complete unrelated later objectives.

## investigation_manager.gd

`investigation_manager.gd` is an autoload that stores investigation progress across world travel.

- `active_investigation` starts as `The Corrupted Signal`.
- `current_step` tracks the sequential clue, conversation, and return-to-HQ objectives.
- `discovered_clues` stores the three named signal fragments.
- `talked_to_npcs` stores required conversations.
- `completed_investigations` stores finished investigation names.
- `lore_entries` stores lore text unlocked by clue interactions.
- `discover_clue()` records clue A from the Codeverse panel and updates the objective.
- `complete_npc_step()` lets dialogue unlock clues B and C, then sets `Return to PTL HQ` after all three required conversations.
- `get_steps_text()` formats the Corrupted Signal chain for the Investigation Journal.
- `on_world_loaded()` keeps the chain objective active across travel and completes the investigation on the final return to PTL HQ.
- `complete_investigation()` moves `The Corrupted Signal` into completed investigations and shows `Unknown source detected: GL!TCH`.

## player.gd

`player.gd` controls movement.

- `move_speed` controls horizontal walking speed.
- `jump_velocity` controls jump strength.
- `turn_speed` controls how quickly the capsule turns toward its movement direction.
- `apply_gravity()` pulls the player down when not standing on the floor.
- `handle_jump()` launches the player upward when Space is pressed.
- `handle_movement()` reads WASD input and moves relative to the camera direction.
- `move_and_slide()` is the Godot `CharacterBody3D` method that applies the final movement while handling collisions.

## nexus_portal.gd

`nexus_portal.gd` is attached to `TheNexus/InteractionArea`.

- `_ready()` connects the area's `body_entered` and `body_exited` signals, then finds the shared Nexus menu through the `nexus_menu` group.
- `_on_body_entered()` checks for the `player` group and asks the menu to show the interaction prompt.
- `_on_body_exited()` hides the interaction prompt when the player leaves the area.
- `_unhandled_input()` listens for the `interact` action while the player is nearby and opens the Nexus menu.
- `prompt_text` is exported so the prompt wording can be changed from the Godot Inspector later.

## nexus_menu.gd

`nexus_menu.gd` controls both the prompt and travel menu.

- The scene-path constants point to the real placeholder world scenes, including Wonder Labs.
- `_ready()` connects each destination button to its scene path and hides the prompt/menu at startup.
- `set_interaction_prompt()` remembers whether the player is nearby and shows or hides the prompt.
- `open_menu()` hides the prompt, opens the travel menu, focuses the first option, and pauses the 3D world.
- `close_menu()` unpauses the world, hides the menu, and restores the prompt if the player is still nearby.
- `_on_destination_selected()` closes the menu and asks `SceneManager` to load the selected world.
- `_unhandled_input()` lets Escape close the menu.

## scene_manager.gd

`scene_manager.gd` is an autoload, which means Godot creates one persistent `SceneManager` node before `Main` starts.

- `register_world_host()` stores references to `Main/WorldContainer` and the persistent player.
- `travel_to()` loads a world scene, removes the previous world from `WorldContainer`, and adds the new world.
- `return_to_ptl_hq()` is a convenience function used by every return portal.
- `move_player_to_spawn()` finds the new world's `SpawnPoint`, moves the existing player there, and clears old movement velocity.
- After a world loads, `SceneManager` tells `ObjectiveManager` which objective should be active.
- `SceneManager` also notifies `InvestigationManager`, allowing PTL HQ return travel to complete an investigation.
- Only the world is replaced. The player, third-person camera, title UI, and Nexus menu remain alive.

## main.gd

`main.gd` is attached to the `Main` root node.

- `_ready()` registers `WorldContainer` and `Player` with the autoloaded `SceneManager`.
- This keeps scene-management setup in one obvious place without adding travel logic to the player.

## Controls

- `W` moves forward.
- `A` moves left.
- `S` moves backward.
- `D` moves right.
- `Space` jumps.
- `E` interacts with The Nexus while the player is nearby.
- `Escape` closes the Nexus travel menu.
- `Tab` opens or closes the Investigation Journal.
