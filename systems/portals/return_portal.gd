extends Area3D

## Sends the persistent player back to PTL HQ when they enter this area.


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		SceneManager.return_to_ptl_hq()
