extends Node3D

#the players' properties 
# base_speed sprint_speed acceleration
# jump velocity double jump
# raycast's length
# fire rate
@onready var clientInitialStage = $InitialLevel
@onready var hostInitialStage = $InitialLevel2
@onready var intialTimer = $InitialStageCountDown
@onready var gameWorld = $gameworld
var enet_peer = ENetMultiplayerPeer.new()
const player_scene = preload("res://addons/fpc/character.tscn")
@onready var canvas_layer = $CanvasLayer
var is_client: bool = false
var ip_address: String
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ip_address = IpAddress.ip_address
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_join_pressed() -> void:
	is_client = true
	canvas_layer.visible = false
	# enet_peer.create_client("192.168.0.104", 135)
	print("joining ip")
	enet_peer.create_client(ip_address, 135)
	multiplayer.multiplayer_peer = enet_peer
	add_player(multiplayer.get_unique_id())

	# multiplayer.multiplayer_peer = peer

func _on_host_pressed() -> void:
	is_client = false
	canvas_layer.visible = false
	enet_peer.create_server(135)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)
	add_player(multiplayer.get_unique_id())

func add_player(peer_id):
	var player = player_scene.instantiate()
	player.is_client = is_client
	player.name = str(peer_id)
	add_child(player)
