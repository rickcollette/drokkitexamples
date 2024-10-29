# baddies.gd
# Enemies handler with faction, resource rewards, and combat log integration
extends KinematicBody2D

var health = 100
var faction = ""  # Enemy faction type
var resource_reward = 50  # Reward for destroying the enemy

func _ready():
    # Assign a faction type randomly to demonstrate factional variety
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
    # Reward player with resources and log the event
    var player_tank = get_parent().get_node("PlayerTank")
    player_tank.score += 100
    player_tank.resources["Gold"] += resource_reward  # Example resource reward
    player_tank.update_score()
    player_tank.log_combat_event(faction, "Destroyed enemy tank")  # Log combat
    health = 100  # Respawn or reset health
