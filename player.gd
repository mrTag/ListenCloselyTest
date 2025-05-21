extends Node3D

@export var MovementSpeed : float = 0.5
@export var MouseSensitivity : float = 1

@export var player_id := 1

var _multiplayer_authority_set : bool = false

func _ready():
	await get_tree().process_frame
	set_multiplayer_authority(player_id)
	await get_tree().process_frame
	_multiplayer_authority_set = true
	
	if player_id == multiplayer.get_unique_id():
		$Cam.make_current()
		$PlayerBox.visible = false
	else:
		$Cam.clear_current()
		var voip_peer_id = Lobby.players[player_id]["voip_peer_id"]
		Lobby.voip_connection.play_peer_on_audio_stream_player_3d(voip_peer_id, $AudioStreamPlayer3D)

func _process(delta):
	if not _multiplayer_authority_set or not is_multiplayer_authority():
		return
	
	translate_object_local(Vector3(
		Input.get_axis("right", "left") * MovementSpeed * delta,
		0,
		Input.get_axis("down", "up") * MovementSpeed * delta
	))

func _input(event):
	if not _multiplayer_authority_set or not is_multiplayer_authority():
		return
	if event is InputEventMouseMotion:
		var current_rotation := rotation
		current_rotation.y -= event.relative.x * MouseSensitivity
		current_rotation.x = max(
			-deg_to_rad(65), 
			min(deg_to_rad(65),
			current_rotation.x + event.relative.y * MouseSensitivity))
		rotation = current_rotation
