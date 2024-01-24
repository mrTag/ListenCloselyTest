extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	Lobby.player_connected.connect(_on_player_connected)
	Lobby.player_disconnected.connect(_on_player_disconnected)

func _on_player_connected(player_id:int, _player_info):
	if player_id == multiplayer.get_unique_id():
		if player_id == 1:
			%MessageLabel.text = "Server created successfully\n"
			%StartGameButton.disabled = false
	else:
		%MessageLabel.text += "Player connected (id: %s)\n"%player_id

func _on_player_disconnected(player_id:int):
	%MessageLabel.text += "Player disconnected (id: %s)\n"%player_id

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
