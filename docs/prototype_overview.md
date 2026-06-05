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

## PTL_HQ.tscn

`PTL_HQ.tscn` is the first placeholder world scene.

- `PTL_HQ` is the root `Node3D` for the lobby.
- `Floor` is a `StaticBody3D` with a box collision shape and a visible box mesh.
- `BackWall`, `LeftWall`, and `RightWall` are `StaticBody3D` walls that block the player.
- `TheNexus` is a placeholder portal area.
- `PortalRing` is a glowing torus mesh that visually marks the portal.
- `PortalLight` is an `OmniLight3D` that makes the portal area feel active.

## Player.tscn

`Player.tscn` is the controllable third-person character.

- `Player` is a `CharacterBody3D`, which is Godot's standard 3D character movement node.
- `CollisionShape3D` gives the player physical collision.
- `Body` is a placeholder capsule mesh so you can see the character.
- `CameraPivot` is a `Node3D` that holds the camera setup.
- `SpringArm3D` keeps the camera behind the player and can help avoid clipping into walls later.
- `Camera3D` is the active camera used while playing.

## PrototypeUI.tscn

`PrototypeUI.tscn` keeps interface elements separate from the 3D world.

- `PrototypeUI` is a `CanvasLayer`, so its children draw on top of the 3D scene.
- `TitleLabel` displays `PTL Universe Prototype`.

## player.gd

`player.gd` controls movement.

- `move_speed` controls horizontal walking speed.
- `jump_velocity` controls jump strength.
- `turn_speed` controls how quickly the capsule turns toward its movement direction.
- `apply_gravity()` pulls the player down when not standing on the floor.
- `handle_jump()` launches the player upward when Space is pressed.
- `handle_movement()` reads WASD input and moves relative to the camera direction.
- `move_and_slide()` is the Godot `CharacterBody3D` method that applies the final movement while handling collisions.

## Controls

- `W` moves forward.
- `A` moves left.
- `S` moves backward.
- `D` moves right.
- `Space` jumps.
