extends CharacterBody2D

var speed = 8.0 * 16.0

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = velocity.lerp(input_direction * speed, 0.1);
	
	if Input.is_action_just_pressed("shoot"):
		var mouse_direction = self.global_position.direction_to(get_global_mouse_position())
		var offset = mouse_direction * 5
		
		var bullet_scene = preload("res://scenes/Bullet.tscn")
		var bullet_instance = bullet_scene.instantiate()
		bullet_instance.global_position = self.global_position + offset
		bullet_instance.prepare_shot(self, mouse_direction)
		get_tree().get_nodes_in_group("BulletContainer")[0].call_deferred("add_child", bullet_instance)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	get_input();
	move_and_slide();
