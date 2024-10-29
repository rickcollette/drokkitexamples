# tanks.gd
# primary game code with faction-based gameplay, resources, alliances, and combat logs
extends Node2D

var websocket = WebSocketClient.new()
var player_id = 1  # Temporary player ID, to be assigned dynamically by the server
var speed = 100  # Tank movement speed
var auth = preload("res://auth.gd").new()
var is_connected = false
var score = 0  # Player's score
var leaderboard = []  # Store leaderboard data
var resources = { "Gold": 0, "Wood": 0, "Stone": 0 }  # Player resources
var faction = ""  # Player's faction type
var alliance = ""  # Player's alliance status

func _ready():
    # Authenticate the player
    auth.login("player_username", "player_password")
    yield(auth, "login_complete")
    
    # Connect to WebSocket once authenticated
    websocket.connect("connected_to_server", self, "_on_connected")
    websocket.connect("data_received", self, "_on_data_received")
    websocket.connect("connection_closed", self, "_on_connection_closed")
    websocket.connect_to_url("wss://your-drokkit-server.com/ws/play?token=" + auth.jwt_token)

    # Set initial faction
    set_faction("Warriors")  # Example, could be dynamically assigned or chosen

func _on_connected(protocol):
    is_connected = true
    print("WebSocket connected. Ready to send and receive updates.")
    request_leaderboard()  # Request leaderboard data on connect
    request_resources()     # Request initial resource data on connect

func _on_connection_closed():
    is_connected = false
    print("Connection closed, attempting to reconnect...")

func _on_data_received():
    var message = websocket.get_packet().get_string_from_utf8()
    var data = parse_json(message)
    handle_server_message(data)

func handle_server_message(data: Dictionary):
    match data.get("action"):
        "update_position":
            update_enemy_position(data)
        "shoot":
            handle_enemy_shoot(data)
        "leaderboard":
            update_leaderboard(data)
        "resource_update":
            update_resources(data)
        "alliance_update":
            update_alliance(data)

func update_enemy_position(data: Dictionary):
    var enemy_tank = get_node("EnemyTank")
    enemy_tank.position = Vector2(data.position.x, data.position.y)

func handle_enemy_shoot(data: Dictionary):
    var enemy_tank = get_node("EnemyTank")
    enemy_tank.receive_shot()
    score += 100  # Award points for a hit
    update_score()

# Request leaderboard data from server
func request_leaderboard():
    var message = { "action": "get_leaderboard" }
    websocket.get_peer(1).put_packet(to_json(message).to_utf8())

func update_leaderboard(data: Dictionary):
    leaderboard = data.get("leaderboard", [])
    display_leaderboard()

func display_leaderboard():
    print("Leaderboard:")
    for entry in leaderboard:
        print(entry["player"], entry["score"])

# Set player's faction
func set_faction(faction_type: String):
    faction = faction_type
    print("Player faction set to:", faction)
    var message = { "action": "set_faction", "faction_type": faction }
    websocket.get_peer(1).put_packet(to_json(message).to_utf8())

# Alliance creation with another player
func form_alliance(other_player_id: int):
    var message = { 
        "action": "form_alliance", 
        "game_instance_id": player_id, 
        "name": "Alliance of " + faction, 
        "faction_ids": [player_id, other_player_id] 
    }
    websocket.get_peer(1).put_packet(to_json(message).to_utf8())
    print("Alliance formed with player ID:", other_player_id)

func update_alliance(data: Dictionary):
    alliance = data.get("alliance_name", "")
    print("Alliance updated:", alliance)

# Request resource data from server
func request_resources():
    var message = { "action": "get_resources", "player_id": player_id }
    websocket.get_peer(1).put_packet(to_json(message).to_utf8())

func update_resources(data: Dictionary):
    for resource in data.get("resources", {}):
        resources[resource["type"]] = resource["amount"]
    print("Updated resources:", resources)

# Log combat event
func log_combat_event(enemy_faction: String, event_description: String):
    var message = { 
        "action": "log_combat", 
        "game_instance_id": player_id, 
        "attacker_id": player_id, 
        "defender_faction": enemy_faction, 
        "event_detail": event_description 
    }
    websocket.get_peer(1).put_packet(to_json(message).to_utf8())
    print("Combat event logged:", event_description)

# Tank movement and shooting
func _process(delta):
    if is_connected:
        var move_direction = Vector2()
        
        # Process movement input
        if Input.is_action_pressed("move_forward"):
            move_direction.y -= 1
        if Input.is_action_pressed("move_backward"):
            move_direction.y += 1
        if Input.is_action_pressed("move_left"):
            move_direction.x -= 1
        if Input.is_action_pressed("move_right"):
            move_direction.x += 1
        
        # Normalize movement to ensure constant speed
        if move_direction != Vector2():
            position += move_direction.normalized() * speed * delta
            send_position_update()
        
        # Process shooting input
        if Input.is_action_just_pressed("fire"):
            shoot()
            send_shoot_action()

# Send position update to server
func send_position_update():
    var message = { 
        "player_id": player_id, 
        "action": "update_position", 
        "position": { "x": position.x, "y": position.y }
    }
    websocket.get_peer(1).put_packet(to_json(message).to_utf8())

# Update score on the server
func update_score():
    var message = { "player_id": player_id, "action": "update_score", "score": score }
    websocket.get_peer(1).put_packet(to_json(message).to_utf8())

# Shooting action - local animation or effects can be added here
func shoot():
    print("Player shooting")
    # Play shooting animation or add shooting effects

# Send shooting action to server
func send_shoot_action():
    var message = { "player_id": player_id, "action": "shoot" }
    websocket.get_peer(1).put_packet(to_json(message).to_utf8())
