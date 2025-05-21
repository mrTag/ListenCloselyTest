extends Control

var lobby_voip_audioplayers : Dictionary

# Called when the node enters the scene tree for the first time.
func _ready():
	Lobby.player_connected.connect(_on_player_connected)
	Lobby.player_disconnected.connect(_on_player_disconnected)

func _exit_tree() -> void:
	for player_id in lobby_voip_audioplayers:
		Lobby.voip_connection.stop_peer_on_audio_stream_player(lobby_voip_audioplayers[player_id])

func _on_player_connected(player_id:int, _player_info):
	if player_id == multiplayer.get_unique_id():
		if player_id == 1:
			%MessageLabel.text = "Server created successfully\n"
			%StartGameButton.disabled = false
	else:
		%MessageLabel.text += "Player connected (id: %s)\n"%player_id
		var voip_player := AudioStreamPlayer.new()
		add_child(voip_player)
		Lobby.voip_connection.play_peer_on_audio_stream_player(_player_info["voip_peer_id"], voip_player)
		lobby_voip_audioplayers[player_id] = voip_player

func _on_player_disconnected(player_id:int):
	%MessageLabel.text += "Player disconnected (id: %s)\n"%player_id
	Lobby.voip_connection.stop_all_audio_stream_players_for_peer(Lobby.players[player_id]["voip_peer_id"])
	if lobby_voip_audioplayers.has(player_id):
		lobby_voip_audioplayers[player_id].queue_free()
		lobby_voip_audioplayers.erase(player_id)

func _on_start_server_button_pressed():
	%StartServerButton.disabled = true
	%ConnectToServerButton.disabled = true
	%IPAddressLineEdit.editable = false
	Lobby.create_game()


func _on_connect_to_server_button_pressed():
	%StartServerButton.disabled = true
	%ConnectToServerButton.disabled = true
	%IPAddressLineEdit.editable = false
	Lobby.join_game(%IPAddressLineEdit.text)


func _on_start_game_button_pressed():
	if multiplayer.is_server():
		%StartGameButton.disabled = true
		Lobby.load_game.rpc("res://mainscene.tscn")
