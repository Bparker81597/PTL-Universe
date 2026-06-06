extends Node3D

## Registers the persistent world container and player with SceneManager.

@onready var world_container: Node3D = $WorldContainer
@onready var player: CharacterBody3D = $Player


func _ready() -> void:
	SceneManager.register_world_host(world_container, player)
