extends Area2D

const OBJECT_TYPE := ObjectTypes.OBJECT_TYPES.Enemy
var hp := 2



func take_damage(damage: int = 1):
	hp -= damage
	if hp <= 0:
		die()

func take_turn():
	print("Enemy " + str(self) + " Taking Turn")

func die():
	queue_free()
