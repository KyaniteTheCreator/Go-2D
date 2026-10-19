extends RigidBody2D

@onready var game_contoller: Node = %GameContoller

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body):
	if (body.name == "Player"):
		var y_delta = position.y - body.position.y
		var x_delta = body.position.x  - position.x 
		if (y_delta > 30) :
			print("Destroy enemy")
			queue_free()
			body.jump()
		else:
			print("Decrease player health")
			GameController.decrease_health()
			if (x_delta > 0):
				body.jump_side(500)
			else:
				body.jump_side(-500)
