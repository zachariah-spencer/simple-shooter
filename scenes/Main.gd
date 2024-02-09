extends Node

enum TURN_ORDER{
	World,
	Player
}

var current_turn = TURN_ORDER.Player

@onready var player = $World/Player
@onready var player_spawn_position = $World/Map/PlayerSpawn

# Called when the node enters the scene tree for the first time.
func _ready():
	player.player_turn_ended.connect(_take_world_turn)
	player.global_position = player_spawn_position.global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if current_turn == TURN_ORDER.World and Input.is_action_just_pressed("debug_end_world_turn"):
		print("Ending World's Turn")
		_begin_player_turn()

func _begin_player_turn():
	current_turn == TURN_ORDER.Player
	player.begin_turn()
	print("Beginning Player's Turn")

func _take_world_turn():
	current_turn = TURN_ORDER.World
	
	#Trigger beginning of AI Logic here
	for enemy in get_tree().get_nodes_in_group("Enemies"):
		enemy.take_turn()
	
	print("Beginning World's Turn")

