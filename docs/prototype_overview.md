# PTL Universe Prototype Overview

This project is a small Godot 4 third-person exploration prototype for the Parker Tech Labs Universe.

## Folder Structure

- `res://scenes/main/` contains the main entry scene that starts the prototype.
- `res://scenes/worlds/` contains world or level scenes, starting with the PTL HQ lobby.
- `res://scenes/characters/` contains character scenes, starting with the player.
- `res://scenes/ui/` contains UI scenes, starting with the prototype title label.
- `res://scripts/` contains reusable GDScript files.
- `res://assets/models/`, `res://assets/textures/`, `res://assets/audio/`, and `res://assets/animations/` are ready for future art and audio.
- `res://systems/portals/`, `res://systems/dialogue/`, and `res://systems/quests/` are placeholders for future gameplay systems.
- `res://docs/` contains project notes and learning references.

## Main.tscn

`Main.tscn` is the scene Godot runs first.

- `Main` is the root `Node3D`.
- `World` instances `PTL_HQ.tscn`, which builds the prototype lobby.
- `Player` instances `Player.tscn`, which gives you a controllable third-person character.
- `SunLight` is a `DirectionalLight3D` that gives the room basic global lighting.
- `PrototypeUI` instances the UI scene with the title label.
- `NexusMenu` instances `nexus_menu.tscn`, which owns the interaction prompt and travel menu.

## PTL_HQ.tscn

`PTL_HQ.tscn` is the first placeholder world scene. It is still made from simple Godot primitives, but it is arranged to feel more like a futuristic Parker Tech Labs HQ.

- `PTL_HQ` is the root `Node3D` for the lobby.
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
- `CodeverseButton`, `NovaToneButton`, and `NovaCanvasButton` are placeholder destination choices.
- `CancelButton` closes the menu without selecting a destination.

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

- `_ready()` connects each button to its action and hides the prompt/menu at startup.
- `set_interaction_prompt()` remembers whether the player is nearby and shows or hides the prompt.
- `open_menu()` hides the prompt, opens the travel menu, focuses the first option, and pauses the 3D world.
- `close_menu()` unpauses the world, hides the menu, and restores the prompt if the player is still nearby.
- `_on_destination_selected()` prints the selected destination to Godot's Output panel, then closes the menu.
- `_unhandled_input()` lets Escape close the menu.

## Controls

- `W` moves forward.
- `A` moves left.
- `S` moves backward.
- `D` moves right.
- `Space` jumps.
- `E` interacts with The Nexus while the player is nearby.
- `Escape` closes the Nexus travel menu.
