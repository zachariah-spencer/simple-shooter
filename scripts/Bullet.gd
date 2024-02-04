extends CharacterBody2D

var speed := 8.0 * 16.0
var direction := Vector2.ZERO
var from : Node2D


func prepare_shot(from, direction):
	self.from = from
	self.direction = direction


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	pass


func _on_hitbox_body_entered(body):
	queue_free()
