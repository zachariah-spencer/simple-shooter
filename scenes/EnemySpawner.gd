extends Marker2D

@onready var enemy_scene = preload("res://scenes/Enemy.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	
	var enemy_instance = enemy_scene.instantiate()
	enemy_instance.global_position = global_position
	get_tree().get_first_node_in_group("EnemyContainer").call_deferred("add_child", enemy_instance)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
