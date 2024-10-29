
# Drokkit Tanks Game - Comprehensive Code Breakdown and Extension Guide

This document provides an in-depth look at each script in the Drokkit Tanks Game, explaining their functions, components, and providing suggestions on how to extend functionality.

---

## 1. Overview of Code Files and Structure

The game consists of three main scripts:

- **baddies.gd**: Manages enemies, including their health, faction, and resources.
- **auth.gd**: Handles player authentication via the Drokkit server.
- **tanks.gd**: Main player and gameplay logic, including movement, resources, alliances, and combat logs.

---

## 2. Detailed Breakdown of Code Files

### `baddies.gd` - Enemy Logic and Combat Integration

**Purpose**:  
`baddies.gd` controls enemy tanks by managing health, faction assignment, resource rewards, and combat logging. This script simulates the actions and interactions of enemy tanks within the game environment.

**Code Breakdown**:

1. **Variables**:
   - `health`: Starts at 100 and decreases when the enemy is hit.
   - `faction`: Assigned randomly on startup, impacting gameplay with potential faction-based strategies.
   - `resource_reward`: Defines resources (e.g., Gold) awarded to players upon destroying this enemy.

2. **Functions**:
   - `_ready()`: Assigns a faction to the enemy when spawned.
   - `update_position()`: Updates the position, potentially called by server or other mechanics.
   - `receive_shot()`: Reduces health by 20 and calls `die()` if health reaches zero.
   - `die()`: Logs the destruction event, rewards the player with resources, and respawns the enemy.

**How to Extend `baddies.gd`**:

- **Faction Abilities**: Add unique abilities based on faction types, e.g., "Warriors" enemies might have higher health or deal extra damage.
- **AI Logic**: Implement basic AI behavior, such as moving toward or away from players, to increase interaction complexity.
- **Reward Variability**: Differentiate rewards based on faction, difficulty level, or health remaining.

---

### `auth.gd` - Player Authentication with the Drokkit Server

**Purpose**:  
`auth.gd` handles player authentication by communicating with the Drokkit server. It manages login, retrieves a JWT token, and signals successful login to the main script.

**Code Breakdown**:

1. **Variables**:
   - `jwt_token`: Stores the player's authentication token for future requests.
   - `base_url`: Holds the base URL of the Drokkit server.

2. **Functions**:
   - `login(username, password)`: Initiates an HTTP request to log the player in. If successful, stores the token and emits a `login_complete` signal.

**How to Extend `auth.gd`**:

- **Token Refresh**: Add functionality to automatically refresh the token before expiration.
- **Error Handling**: Enhance error handling for cases like network issues or incorrect credentials.
- **User Registration**: Include a registration method for new users.

---

### `tanks.gd` - Player Actions, Factions, and Real-Time Server Interactions

**Purpose**:  
`tanks.gd` is the core script for player interactions, movement, faction management, alliances, and real-time data updates (like resources and combat logs) using WebSocket communication with the Drokkit server.

**Code Breakdown**:

1. **Variables**:
   - `websocket`: Manages WebSocket connection to handle real-time events.
   - `score`: Tracks player score based on gameplay actions.
   - `resources`: A dictionary tracking resource amounts like Gold, Wood, and Stone.
   - `faction` and `alliance`: Tracks player’s faction and alliance status.

2. **Functions**:
   - `_ready()`: Initiates authentication and connects WebSocket to the server.
   - `_on_connected()`: Triggers after a WebSocket connection is established, requesting leaderboard and resource data.
   - `set_faction()`: Sets player’s faction and sends it to the server.
   - `form_alliance()`: Creates an alliance with another player.
   - `log_combat_event()`: Logs combat events (e.g., destroying an enemy) on the server.
   - `handle_server_message()`: Processes incoming WebSocket messages and updates game state accordingly.

**How to Extend `tanks.gd`**:

- **Advanced Alliances**: Allow alliances between more than two factions, and add alliance-related bonuses or abilities.
- **Resource Management**: Implement resource usage for in-game upgrades, such as tank improvements or faction-specific abilities.
- **Expanded Leaderboard**: Track additional stats, such as longest kill streak or highest resource collection, to make the leaderboard more engaging.

---

## 3. Summary

This code setup provides a foundation for a multiplayer tank game integrated with the Drokkit server, supporting faction-based gameplay, alliances, resources, and combat logging. By following the extension suggestions, developers can expand functionality and increase game complexity, creating a deeper and more engaging player experience.
