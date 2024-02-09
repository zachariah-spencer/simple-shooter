extends Area2D

const OBJECT_TYPE := ObjectTypes.OBJECT_TYPES.Projectile

var speed := 8.0 * 16.0
var direction := Vector2.ZERO
var from : Node2D
var targeted_socket = null
var object_id 

@onready var anims := $Anims
@onready var scanner := $Scanner

func _ready():
	Events.tick_elapsed.connect(_travel)
	scanner.target_position = direction * 32

func prepare_shot(from, direction):
	self.from = from
	self.direction = direction

func _travel():
	
	if scanner.is_colliding():
		targeted_socket = scanner.get_collider()
		anims.get_animation("bullet_travel").track_set_key_value(0, 0, global_position)
		anims.get_animation("bullet_travel").track_set_key_value(0, 1, targeted_socket.global_position)
		anims.play("bullet_travel")
	else:
		queue_free()


func _on_area_entered(area):
	if "OBJECT_TYPE" in area:
		if area.OBJECT_TYPE == ObjectTypes.OBJECT_TYPES.Enemy:
			var enemy = area
			
			enemy.take_damage()
	queue_free()
