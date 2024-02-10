extends Area2D

const OBJECT_TYPE := ObjectTypes.OBJECT_TYPES.Projectile
const GRID_PADDING := 16.0
const PLAYER_SIZE := 8.0
const CELL_SIZE := GRID_PADDING + PLAYER_SIZE

var direction := Vector2.ZERO
var from : Node2D
var target_socket_position := Vector2.ZERO
var range := 3

func _ready():
	Events.tick_elapsed.connect(_travel)
	_travel()

func prepare_shot(from, direction):
	self.from = from
	self.direction = direction
	

func _physics_process(delta):
	if not target_socket_position.is_equal_approx(global_position):
		global_position = global_position.lerp(target_socket_position, 0.4)
	else:
		global_position = target_socket_position

func _travel():
	target_socket_position = self.global_position + (direction * CELL_SIZE)
	range -= 1
	
	if range < 0:
		queue_free()


func _on_area_entered(area):
	if "OBJECT_TYPE" in area:
		if area.OBJECT_TYPE == ObjectTypes.OBJECT_TYPES.Enemy:
			var enemy = area
			
			enemy.take_damage()
	queue_free()
