extends CharacterBody2D

var speed = 8.0 * 16.0
var moving := false
var targeted_socket = null
var turn_active := true
var ap := 2
var max_ap := 2

var ap_costs = {
	"move" : 1
}

@onready var crosshair := $Crosshair
@onready var move_scanner := $MoveScanner
@onready var anims := $Anims

signal player_turn_ended

func get_input():
	_get_targeted_socket()
	if Input.is_action_just_pressed("move"):
		if not moving and ap >= ap_costs["move"]:
			_move()
	
	if targeted_socket and Input.is_action_just_pressed("shoot"):
		_shoot()
	
	## Basic attack functionality
	#if Input.is_action_just_pressed("shoot"):
		#var mouse_direction = self.global_position.direction_to(get_global_mouse_position())
		#var offset = mouse_direction * 5
		#
		#var bullet_scene = preload("res://scenes/Bullet.tscn")
		#var bullet_instance = bullet_scene.instantiate()
		#bullet_instance.global_position = self.global_position + offset
		#bullet_instance.prepare_shot(self, mouse_direction)
		#get_tree().get_nodes_in_group("BulletContainer")[0].call_deferred("add_child", bullet_instance)

func _get_targeted_socket():
	if not moving:
		var input_direction = Vector2.ZERO
		if Input.is_action_pressed('right'):
			input_direction.x += 1
		elif Input.is_action_pressed('left'):
			input_direction.x -= 1
		elif Input.is_action_pressed('down'):
			input_direction.y += 1
		elif Input.is_action_pressed('up'):
			input_direction.y -= 1
		
		move_scanner.position = input_direction * 12
		move_scanner.target_position = input_direction * 16
		move_scanner.enabled = true
		if move_scanner.is_colliding():
			targeted_socket = move_scanner.get_collider()
			move_scanner.enabled = false
			
			crosshair.global_position = targeted_socket.global_position
			crosshair.visible = true

func _move():
	ap -= 1
	crosshair.visible = false
	moving = true
	anims.get_animation("move").track_set_key_value(0, 0, global_position)
	anims.get_animation("move").track_set_key_value(0, 1, targeted_socket.global_position)
	anims.play("move")

func _shoot():
	var direction = global_position.direction_to(targeted_socket.global_position)
	var offset = direction * 5
	
	var bullet_scene = preload("res://scenes/Bullet.tscn")
	var bullet_instance = bullet_scene.instantiate()
	bullet_instance.global_position = self.global_position + offset
	bullet_instance.prepare_shot(self, direction)
	get_tree().get_nodes_in_group("BulletContainer")[0].call_deferred("add_child", bullet_instance)

func _check_action_points():
	if ap == 0:
		_end_turn()

func begin_turn():
	turn_active = true
	ap = max_ap

func _end_turn():
	print("Ending Player's Turn")
	emit_signal("player_turn_ended")
	turn_active = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if turn_active:
		get_input();
		_check_action_points()


func _on_anims_animation_finished(anim_name):
	if(anim_name == "move"):
		moving = false
