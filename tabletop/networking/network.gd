extends Node

var player_data = {}
#var player_names = {}
var player_finished_loading = []
var is_listen = true
const SERVER_PORT = 4242
const MAX_PLAYERS = 32
var server_ip
var self_info = {}
var player_speed: = 0.0
var chat = {}
var ping_time
var ping_timer := 0.0
var waiting_for_pong := false
var current_ping := 0
remotesync var map_seed: int
remotesync var selected_stage := 0
remotesync var gamemode := 0
enum Role{
	GAMEMASTER,
	WARRIOR,
}
remotesync var roles = {}

var rules = {
	"gamemaster_amount" : 1
}

var stages = [
	"res://Debug.tscn",
	"res://Tropica.tscn"
]

func _ready():
	get_tree().connect("network_peer_connected", self, "_on_network_peer_connected")
	get_tree().connect("network_peer_disconnected", self, "_on_network_peer_disconnected")
	get_tree().connect("connected_to_server", self, "_on_connected_to_server")
	get_tree().connect("connection_failed", self, "_on_connection_failed")
	get_tree().connect("server_disconnected", self, "_on_server_disconnected")
	for ip in IP.get_local_addresses():
		if ip.begins_with("192.168"):
			server_ip = ip


func _process(delta):
#	print(selecsted_stage)
	if get_tree().has_network_peer():
#		print(waiting_for_pong)
		if get_tree().is_network_server():
			rpc_unreliable("sync_player_data", player_data)
			rset_unreliable("selected_stage", selected_stage)
			rset_unreliable("gamemode", gamemode)
		elif not waiting_for_pong or ping_timer > 2.0: #only emitted once
			print("ping here")
			ping_timer = 0.0
			rpc_id(1, "ping")
			waiting_for_pong = true
		ping_timer += delta

func sync_transform(new_transform):
	pass

func _on_network_peer_connected(id): #emit on server and client
	pass


func _on_network_peer_disconnected(id): #emit on server and client
	player_data.erase(id)


func _on_connected_to_server(): #succeed connection to server emit on client only
	#actual dog shit move to 
	rpc_id(1, "register_player", self_info) #run on connected peer, sends info to host
	#host should send to every player in lobby, use sync_player_data()


func _on_connection_failed(): #fails connection to server emit on client only
	pass


func _on_server_disconnected():
	pass


remote func register_player(info):
	var id = get_tree().get_rpc_sender_id()
#	player_data[id] = info
	roles[id] = Role.WARRIOR
	print("player registered")


remote func sync_player_data(new_dict):
	player_data = new_dict


remotesync func load_game():
#	selected_stage = stage_id
	rset("roles", roles)
	map_seed = 0
	rset("map_seed", map_seed)
	print("entered gameworld")
	get_tree().change_scene("res://gameworld/gameworld.tscn")


remote func finished_loading():
	var finished_player = get_tree().get_rpc_sender_id()
	if (get_tree().get_network_unique_id() == 1 and
			get_tree().is_network_server() and
			finished_player in player_data and
			not finished_player in player_finished_loading):
		player_finished_loading.append(finished_player)


func host_game():
	var peer = NetworkedMultiplayerENet.new()
	var error_code = peer.create_server(SERVER_PORT, MAX_PLAYERS)
	get_tree().network_peer = peer
	roles[1] = Role.WARRIOR
	if is_listen:
		pass
	else:
		pass
	return error_code


func join_game():
	var peer = NetworkedMultiplayerENet.new()
	var error_code = peer.create_client(server_ip, SERVER_PORT)
	get_tree().network_peer = peer
	return error_code

remote func ping():
	rpc_id(get_tree().get_rpc_sender_id(), "pong")


remote func pong():
	waiting_for_pong = false
	current_ping = int(ping_timer * 1000.0)
	print(current_ping)
	ping_timer = 0.0


func send_message(content, target):
	pass
