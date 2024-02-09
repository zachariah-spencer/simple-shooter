extends CharacterBody2D

const OBJECT_TYPE := ObjectTypes.OBJECT_TYPES.Player
const GRID_PADDING := 16.0
const PLAYER_SIZE := 8.0
const CELL_SIZE := GRID_PADDING + PLAYER_SIZE
var speed = 8.0 * 16.0
var moving := false
var targeted_socket = null
var target_socket_position := Vector2.ZERO
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
@onready var anims := $Anims

signal player_turn_ended

func get_input():
	
	var enemy_at_target : bool = enemy_scanner.is_colliding()
	
	_get_targeted_socket()
	
	if enemy_at_target:
		print('HERE')
	
	if Input.is_action_just_pressed("move"):
		if targeted_socket and not moving and ap >= ap_costs["move"]:
			_move()
	
	if targeted_socket and Input.is_action_just_pressed("shoot") and ap >= ap_costs["shoot"]:
		_shoot()

func _get_targeted_socket():
	if not moving:
		if Input.is_action_just_pressed('right'):
			input_direction = Vector2.ZERO
			input_direction.x += 1
			crosshair.visible = true
			move_scanner.target_position = input_direction * 16
		elif Input.is_action_just_pressed('left'):
			input_direction = Vector2.ZERO
			input_direction.x -= 1
			crosshair.visible = true
			move_scanner.target_position = input_direction * 16
		elif Input.is_action_just_pressed('down'):
			input_direction = Vector2.ZERO
			input_direction.y += 1
			crosshair.visible = true
			move_scanner.target_position = input_direction * 16
		elif Input.is_action_just_pressed('up'):
			input_direction = Vector2.ZERO
			input_direction.y -= 1
			crosshair.visible = true
			move_scanner.target_position = input_direction * 16
		
		target_socket_position = self.global_position + (input_direction * CELL_SIZE)
		crosshair.global_position = target_socket_position
		
		
		move_scanner.enabled = true
		if move_scanner.is_colliding():
			targeted_socket = move_scanner.get_collider()
			move_scanner.enabled = false
			
			crosshair.global_position = targeted_socket.global_position
			crosshair.visible = true

func _check_for_enemy(input_dir):
	enemy_scanner.position = input_dir * 12
	enemy_scanner.target_position = input_dir * 16

func _move():
	_use_action_point()
	crosshair.visible = false
	moving = true
	anims.get_animation("move").track_set_key_value(0, 0, global_position)
	anims.get_animation("move").track_set_key_value(0, 1, targeted_socket.global_position)
	anims.play("move")
	targeted_socket = null

func _shoot():
	_use_action_point()
	var direction = global_position.direction_to(targeted_socket.global_position)
	var spawn_position = targeted_socket.global_position
	
	var bullet_scene = preload("res://scenes/Bullet.tscn")
	var bullet_instance = bullet_scene.instantiate()
	bullet_instance.global_position = spawn_position
	bullet_instance.prepare_shot(self, direction)
	get_tree().get_nodes_in_group("BulletContainer")[0].call_deferred("add_child", bullet_instance)
	
	crosshair.visible = false
	targeted_socket = null

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


func _on_anims_animation_finished(anim_name):
	if(anim_name == "move"):
		moving = false

func _use_action_point():
	ap -= 1
	Events.tick_elapsed.emit()
