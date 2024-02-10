extends CharacterBody2D

const OBJECT_TYPE := ObjectTypes.OBJECT_TYPES.Player
const GRID_PADDING := 16.0
const PLAYER_SIZE := 8.0
const CELL_SIZE := GRID_PADDING + PLAYER_SIZE
var speed = 8.0 * 16.0
var moving := false
var targeted_socket = null
var target_socket_position := Vector2.ZERO
var new_global_position := Vector2.ZERO
var input_direction := Vector2.ZERO
var turn_active := true
var ap := 3
var max_ap := 3

var ap_costs = {
	"move" : 1,
	"shoot" : 1
}

@onready var crosshair := $Crosshair
@onready var move_scanner := $MoveScanner
@onready var enemy_scanner := $EnemyScanner
@onready var move_timer := $MoveTimer

signal player_turn_ended

func get_input():
	
	var enemy_at_target : bool = enemy_scanner.is_colliding()
	
	_get_targeted_socket()
	if enemy_at_target:
		print('HERE')
	
	if Input.is_action_just_pressed("move"):
		if not move_scanner.is_colliding():
			if ap >= ap_costs["move"] and not moving:
				_move()
	
	if Input.is_action_just_pressed("shoot"):
			if ap >= ap_costs["shoot"]:
				_shoot()

func _set_direction(vector_component: String, amount: int):
	input_direction = Vector2.ZERO
	if vector_component == "x":
		input_direction.x += amount
	elif vector_component == "y":
		input_direction.y += amount
	
	crosshair.visible = true
	move_scanner.target_position = input_direction * 16
	enemy_scanner.target_position = input_direction * 32
	target_socket_position = self.global_position + (input_direction * CELL_SIZE)
	crosshair.global_position = target_socket_position

func _get_targeted_socket():
	if not moving:
		if Input.is_action_just_pressed('right'):
			_set_direction("x", 1)
		elif Input.is_action_just_pressed('left'):
			_set_direction("x", -1)
		elif Input.is_action_just_pressed('down'):
			_set_direction("y", 1)
		elif Input.is_action_just_pressed('up'):
			_set_direction("y", -1)

func _check_for_enemy(input_dir):
	enemy_scanner.position = input_dir * 12
	enemy_scanner.target_position = input_dir * 16

func _move():
	_use_action_point()
	crosshair.visible = false
	moving = true
	new_global_position = target_socket_position
	move_timer.start()

func _shoot():
	_use_action_point()
	
	var direction = global_position.direction_to(target_socket_position)
	var bullet_scene = preload("res://scenes/Bullet.tscn")
	var bullet_instance = bullet_scene.instantiate()
	
	bullet_instance.global_position = global_position
	bullet_instance.prepare_shot(self, direction)
	get_tree().get_first_node_in_group("BulletContainer").call_deferred("add_child", bullet_instance)
	
	crosshair.visible = false

func _check_action_points():
	if ap == 0:
		_end_turn()

func begin_turn():
	turn_active = true
	ap = max_ap

func _end_turn():
	print("Ending Player's Turn")
	emit_signal("player_turn_ended")
	crosshair.visible = false
	turn_active = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if turn_active:
		get_input();
		_check_action_points()
	
	if moving:
		global_position = global_position.lerp(new_global_position, 0.25)



func _use_action_point():
	ap -= 1
	Events.tick_elapsed.emit()


func _on_move_timer_timeout():
	moving = false
	global_position = new_global_position
