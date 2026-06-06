extends Node

## Keeps the player and UI alive while swapping the active world scene.
## Main registers its WorldContainer and Player once when the game starts.

const PTL_HQ_PATH := "res://scenes/worlds/PTL_HQ.tscn"

var world_container: Node3D
var player: CharacterBody3D


func register_world_host(container: Node3D, persistent_player: CharacterBody3D) -> void:
	world_container = container
	player = persistent_player


func travel_to(world_scene_path: String) -> void:
	if world_container == null or player == null:
		push_error("SceneManager has not been registered by Main.")
		return

	var packed_world := load(world_scene_path) as PackedScene
	if packed_world == null:
		push_error("Could not load world scene: %s" % world_scene_path)
		return

	# Remove the current world, but keep Main, the player, camera, and UI alive.
	for child in world_container.get_children():
		child.queue_free()

	var new_world := packed_world.instantiate() as Node3D
	world_container.add_child(new_world)
	move_player_to_spawn(new_world)


func return_to_ptl_hq() -> void:
	travel_to(PTL_HQ_PATH)


func move_player_to_spawn(world: Node3D) -> void:
	var spawn_point := world.find_child("SpawnPoint", true, false) as Marker3D
	if spawn_point == null:
		push_warning("World '%s' does not contain a SpawnPoint Marker3D." % world.name)
		return

	player.global_transform = spawn_point.global_transform
	player.velocity = Vector3.ZERO
