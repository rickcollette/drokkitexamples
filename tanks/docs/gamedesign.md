
# Drokkit Tanks Game -  Game Design and Implementation Guide

This document details the `Drokkit Tanks Game`, highlighting its code, functionality, server integration, faction and alliance system, resource management, combat logs, and real-time leaderboard updates.

---

## Table of Contents

1. Overview
2. Code Files and Structure
    - `baddies.gd`
    - `auth.gd`
    - `tanks.gd`
3. Key Game Features
    - Factions and Alliances
    - Resources and Rewards
    - Real-Time Combat Logs
    - Leaderboard Integration
4. WebSocket and Server Communication
5. Implementation Walkthrough

---

## 1. Overview

The `Drokkit Tanks Game` is a multiplayer game leveraging the Drokkit server for faction-based battles, alliances, combat logs, and resource management. The game is designed to showcase real-time gameplay with score tracking, resource allocation, and leaderboards.

---

## 2. Code Files and Structure

The game consists of three main scripts:

- **baddies.gd**: Manages enemies, including their health, faction, and resources.
- **auth.gd**: Handles player authentication via Drokkit server.
- **tanks.gd**: Main player and gameplay logic, including movements, resources, alliances, and combat logs.

### `baddies.gd`

```gdscript
# Enemies handler with faction, resource rewards, and combat log integration
extends KinematicBody2D

var health = 100
var faction = ""  # Enemy faction type
var resource_reward = 50  # Reward for destroying the enemy

func _ready():
    var factions = ["Industrialists", "Warriors", "Technologists", "Traders"]
    faction = factions[randi() % factions.size()]
    print("Enemy assigned to faction:", faction)

func update_position(new_position: Vector2):
    position = new_position

func receive_shot():
    health -= 20
    print("Enemy tank hit! Health remaining:", health)
    
    if health <= 0:
        die()

func die():
    print("Enemy destroyed! Rewarding resources and logging combat event.")
    var player_tank = get_parent().get_node("PlayerTank")
    player_tank.score += 100
    player_tank.resources["Gold"] += resource_reward  # Example resource reward
    player_tank.update_score()
    player_tank.log_combat_event(faction, "Destroyed enemy tank")
    health = 100  # Respawn or reset health
```

---

### `auth.gd`

```gdscript
# Authentication handler
extends Node
var jwt_token = ""
var base_url = "https://your-drokkit-server.com"
signal login_complete

func login(username: String, password: String) -> void:
    var request = HTTPRequest.new()
    add_child(request)
    var body = { "username": username, "password": password }
    
    request.request(base_url + "/login", body, HTTPClient.METHOD_POST)
    yield(request, "request_completed")
    
    if request.response_code == 200:
        var response = parse_json(request.get_body_as_string())
        jwt_token = response.token
        print("Login successful")
        emit_signal("login_complete")
    else:
        print("Login failed:", request.response_code)
```

---

### `tanks.gd`

```gdscript
# Primary game code with faction-based gameplay, resources, alliances, and combat logs
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
    auth.login("player_username", "player_password")
    yield(auth, "login_complete")
    
    websocket.connect("connected_to_server", self, "_on_connected")
    websocket.connect("data_received", self, "_on_data_received")
    websocket.connect("connection_closed", self, "_on_connection_closed")
    websocket.connect_to_url("wss://your-drokkit-server.com/ws/play?token=" + auth.jwt_token)

    set_faction("Warriors")

func _on_connected(protocol):
    is_connected = true
    request_leaderboard()
    request_resources()

func _on_connection_closed():
    is_connected = false

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

func set_faction(faction_type: String):
    faction = faction_type
    var message = { "action": "set_faction", "faction_type": faction }
    websocket.get_peer(1).put_packet(to_json(message).to_utf8())

func form_alliance(other_player_id: int):
    var message = { 
        "action": "form_alliance", 
        "game_instance_id": player_id, 
        "name": "Alliance of " + faction, 
        "faction_ids": [player_id, other_player_id] 
    }
    websocket.get_peer(1).put_packet(to_json(message).to_utf8())

func request_resources():
    var message = { "action": "get_resources", "player_id": player_id }
    websocket.get_peer(1).put_packet(to_json(message).to_utf8())

func update_resources(data: Dictionary):
    for resource in data.get("resources", {}):
        resources[resource["type"]] = resource["amount"]
    print("Updated resources:", resources)

func log_combat_event(enemy_faction: String, event_description: String):
    var message = { 
        "action": "log_combat", 
        "game_instance_id": player_id, 
        "attacker_id": player_id, 
        "defender_faction": enemy_faction, 
        "event_detail": event_description 
    }
    websocket.get_peer(1).put_packet(to_json(message).to_utf8())
```

---

## 3. Key Game Features

### Factions and Alliances

- Each player and enemy has a faction (Industrialists, Warriors, Technologists, or Traders), influencing gameplay strategy.
- Players can form alliances with others, adding depth to multiplayer interactions.

### Resources and Rewards

- Destroying enemies rewards players with resources, tracked server-side and used for faction advantages.
- Players can request their resource status, which updates in real-time.

### Real-Time Combat Logs

- Combat events are logged in real time and can be reviewed post-match, adding depth to gameplay history and engagement.

### Leaderboard Integration

- Players can view the leaderboard, which is regularly updated with real-time game scores and performance metrics.

---

## 4. WebSocket and Server Communication

### WebSocket Flow

- Players establish a WebSocket connection for all real-time events.
- Game actions (movements, attacks, alliances) are instantly broadcasted and received through WebSocket, ensuring smooth multiplayer interactions.

### Key Endpoints

- **Leaderboard**: `GET /leaderboard`
- **Resource Update**: Updates player resources following in-game actions.
- **Alliance Formation**: Handles alliance requests and responses.

---

## 5. Implementation Walkthrough

The implementation covers faction assignments, real-time combat logs, and leaderboard updates, showcasing Drokkit's server capabilities for dynamic, multiplayer gameplay.
