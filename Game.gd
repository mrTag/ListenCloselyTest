extends Node3D

var player_scene = preload("res://player.tscn")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Lobby.server_disconnected.connect(_on_server_disconnected)
	# Preconfigure game.

	Lobby.player_loaded.rpc_id(1) # Tell the server that this peer has loaded.

func _on_server_disconnected():
	get_tree().change_scene_to_file("res://StartScreen.tscn")

# Called only on the server.
func start_game():
	await get_tree().process_frame
	for player_id in Lobby.players:
		var player_obj = player_scene.instantiate()
		player_obj.name = str(player_id)
		player_obj.player_id = player_id
		print("player_id set to %s"%player_id)
		add_child(player_obj)
