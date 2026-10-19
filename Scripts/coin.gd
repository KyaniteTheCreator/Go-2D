extends Node2D

@export var value: int = 1

func _ready():
	add_to_group("Coins")

func _on_area_2d_body_entered(body):
	if body is Player:
		GameController.coin_collected(value)

		visible = false
		$Area2D.set_deferred("monitoring", false)

func reset_coin():
	visible = true
	$Area2D.set_deferred("monitoring", true)
