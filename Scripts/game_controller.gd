extends Node

@onready var hearts = [
	get_node("/root/World/UI/Hearts/Heart1"),
	get_node("/root/World/UI/Hearts/Heart2"),
	get_node("/root/World/UI/Hearts/Heart3")
]

var total_coins: int = 0
var lives = 3

func decrease_health():
	lives -=1
	print(lives)
	for h in 3:
		if(h < lives):
			hearts[h].show()
		else:
			hearts[h].hide()
	if(lives == 0):
		get_tree().reload_current_scene()

func coin_collected(value: int):
	total_coins += value
	EventController.emit_signal("coin_collected", total_coins)

func reset_coins():
	total_coins = 0
	EventController.emit_signal("coin_collected", total_coins)
