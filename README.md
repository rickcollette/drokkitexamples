
# Drokkit Tanks Game

Drokkit Tanks Game is a multiplayer tank battle game developed in Godot, integrating real-time WebSocket interactions with the Drokkit server. The game features faction-based combat, alliances, resource rewards, and combat logging.

## Features

- **Faction-Based Gameplay**: Players and enemies belong to various factions, affecting combat dynamics.
- **Alliances**: Players can form alliances with others to gain strategic advantages.
- **Real-Time WebSocket Interaction**: The game communicates with the Drokkit server for real-time updates on position, combat events, and leaderboards.
- **Resource Rewards and Leaderboards**: Players earn resources through gameplay and can check their ranks on the leaderboard.

## Project Structure

- **`baddies.gd`**: Manages enemies, including health, faction assignment, and resource rewards.
- **`auth.gd`**: Handles player authentication with the Drokkit server.
- **`tanks.gd`**: Core gameplay logic for player actions, faction management, alliances, and resource tracking.

## Documentation

- [How to Use this](docs/godotusage.md)
- [Tanks Game Design](docs/gamedesign.md)
- [Breakdown of the Code](docs/codebreakdown.md)

## Setup

1. **Godot Engine**: Ensure you have Godot Engine 3.2+ installed.
2. **Drokkit Server**: Set up and run the Drokkit server, ensuring the database and WebSocket endpoints are accessible.
3. **Project Setup**: Clone this repository, and open it in Godot.

## Running the Game

1. **Authentication**: Players authenticate through `auth.gd`, which connects to the Drokkit server and retrieves a JWT token.
2. **WebSocket Connection**: `tanks.gd` establishes a WebSocket connection for real-time events.
3. **Gameplay**: Move the player tank, destroy enemies, form alliances, and earn resources.

## Extending the Game

- **New Factions and Abilities**: Add more factions with unique abilities to enhance gameplay variety.
- **Expanded Leaderboard Stats**: Track additional player stats, like highest kill streaks.
- **AI Improvements**: Enhance enemy AI to add challenge and depth to battles.

---

For a comprehensive breakdown of the code and details on extending the functionality, refer to the [Drokkit Tanks Code Breakdown Guide](./Drokkit_Tanks_Code_Breakdown_Guide.md).
