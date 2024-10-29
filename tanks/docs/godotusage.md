
# Drokkit Tanks Game - Godot Usage Guide

This document provides a step-by-step guide for setting up and running the Drokkit Tanks Game in Godot, including project setup, script attachment, scene configuration, and integration with the Drokkit server.

---

## Table of Contents

1. Prerequisites
2. Setting Up the Godot Project
3. Importing and Attaching Scripts
4. Configuring the Scenes and Nodes
5. Running the Game
6. Testing Server Interactions

---

## 1. Prerequisites

- **Godot Engine** (version 3.2 or later).
- **Drokkit Server**: Ensure the server is set up and running, with database and WebSocket endpoints accessible.
- **Network Connectivity**: Verify that your local network allows WebSocket connections and HTTP requests to the Drokkit server.

---

## 2. Setting Up the Godot Project

1. Open **Godot Engine** and create a new project, naming it "Drokkit Tanks Game".
2. Set up the project’s file structure by adding folders for your scripts and assets:
    - `Scripts/` for all script files
    - `Scenes/` for game scenes

---

## 3. Importing and Attaching Scripts

Place the provided scripts in your **Scripts/** directory and attach them to the corresponding nodes in the scene.

- **`baddies.gd`**: Manages enemies and their resources. Attach this to each enemy tank node.
- **`auth.gd`**: Handles user login and token retrieval. Attach it to a global node accessible in all scenes.
- **`tanks.gd`**: Manages player actions, including faction settings, alliances, and combat logs.

Place each file within the **Scripts/** directory and attach them as follows:

- **Attach `tanks.gd`**: Attach `tanks.gd` to the main player tank node, and ensure it’s the primary script managing movement and server communication.
- **Attach `baddies.gd`**: Attach `baddies.gd` to each enemy tank in the scene.
- **Attach `auth.gd`**: Attach `auth.gd` to a persistent node, such as an `AutoLoad` singleton, so it is accessible for authentication across the project.

---

## 4. Configuring the Scenes and Nodes

### Main Scene Configuration

1. **Create Player and Enemy Tanks**:
   - Add a `KinematicBody2D` node for the player tank and assign the `tanks.gd` script.
   - Add enemy tanks (`KinematicBody2D` nodes), and assign `baddies.gd` to each.

2. **Set up WebSocket and HTTP Requests**:
   - Create a `WebSocketClient` node for WebSocket connections, configuring the URL with the server’s WebSocket endpoint.
   - Add an `HTTPRequest` node for login and leaderboard requests.

3. **Input Mapping**:
   - Configure input actions in **Project Settings > Input Map**:
     - `move_forward` - Up Arrow or W
     - `move_backward` - Down Arrow or S
     - `move_left` - Left Arrow or A
     - `move_right` - Right Arrow or D
     - `fire` - Space or Left Mouse Button

### Other Node Configurations

- **Player Faction and Alliance**: Use the `set_faction()` and `form_alliance()` functions in `tanks.gd` to assign faction and create alliances during gameplay.

---

## 5. Running the Game

1. **Start the Drokkit Server**: Ensure that your server is running and accessible.
2. **Launch the Godot Project**:
   - Press **F5** to run the project or launch it from the editor’s **Play** button.
   - Upon launch, the `auth.gd` script will handle login, and the `tanks.gd` script will initialize player faction and WebSocket connections.
3. **Testing Gameplay**:
   - Move the player tank using the configured keys.
   - Engage enemy tanks and observe the updates in resources, faction handling, and alliances.

---

## 6. Testing Server Interactions

### Leaderboard

- Trigger the leaderboard request through `tanks.gd` by calling `request_leaderboard()`.
- Check the console for leaderboard data received from the server.

### Resource Management

- Resource rewards are granted each time an enemy tank is destroyed, which can be seen in the console logs.

### Combat Logs

- Combat events are logged in real-time, providing detailed battle data accessible after gameplay.

This guide enables running and testing the Drokkit Tanks Game with full server integration in Godot. Enjoy exploring Drokkit’s faction-based multiplayer tank game!
