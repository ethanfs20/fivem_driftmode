# Drift Mode Resource for FiveM

## Description

Drift Mode is a script resource for FiveM that allows players to enable a special drifting mode for vehicles, enhancing the driving experience and making it perfect for adrenaline-pumping drift sessions. The resource modifies vehicle handling properties and adds realistic smoke particles during drifting, creating a more immersive and exciting drifting experience for players.

## Features

- Easy Enable/Disable: Drift Mode can be toggled on or off with a simple chat command or a designated keybind.

- Permission System: The resource comes with a flexible permission system, allowing server owners to grant or restrict access to the Drift Mode command.

- Vehicle Whitelist: Server owners can specify a whitelist of vehicle models in the configuration file, allowing only whitelisted vehicles to access Drift Mode.

- Vehicle Class Whitelist: Additionally, a whitelist of vehicle classes can be set up in the configuration file for more fine-grained control over vehicle types allowed to use Drift Mode.

- Customizable Keybind: The resource offers the option to use a keybind instead of the chat command for enabling Drift Mode.

- Realistic Drifting: Drift Mode modifies key handling properties of vehicles, resulting in a more realistic and satisfying drifting experience.

- Impressive Drift Effects: During drifting, the resource adds realistic smoke particles to create clouds of smoke, enhancing the visual experience.

## Installation

1. Download the Drift Mode resource from the GitHub repository.

2. Place the "driftmode" folder in your FiveM server's "resources" directory.

3. Adjust the configuration file (config.lua) to customize the resource settings according to your server's preferences.

4. Ensure that you have set up the permission system correctly to control access to Drift Mode.

5. Add "start driftmode" to your server.cfg to enable the Drift Mode resource when the server starts.

## Configuration

The "config.lua" file allows you to customize various settings for the Drift Mode resource:

- `permissionsBased` (boolean): Set to true if you want to enable permission-based access to Drift Mode.

- `permissionName` (string): The ACE permission required to use Drift Mode if permissionsBased is true.

- `vehicleWhitelist` (boolean): Set to true if you want to use a whitelist of vehicle models for Drift Mode.

- `models` (table): The list of vehicle models allowed to use Drift Mode (if vehicleWhitelist is true). Add the vehicle model names as strings.

- `vehicleClassWhitelist` (boolean): Set to true if you want to use a whitelist of vehicle classes for Drift Mode.

- `classes` (table): The list of vehicle classes allowed to use Drift Mode (if vehicleClassWhitelist is true). Add the vehicle classes as integers.

- `keybind` (boolean): Set to true if you want to enable the keybind option for Drift Mode.

- `key` (string): The key to be used as the keybind for enabling Drift Mode (if keybind is true).

## Usage

To enable Drift Mode in-game, players can use either the chat command or the designated keybind:

- Chat Command: Type "/driftmode" in the chat to enable or disable Drift Mode.

- Keybind: If the keybind option is enabled, players can use the specified key to toggle Drift Mode on or off.

## Contributions and Support

Contributions, bug reports, and feature requests are welcome! Feel free to submit a pull request or open an issue on the GitHub repository.

If you encounter any issues or have questions about using the Drift Mode resource, don't hesitate to reach out for support.

## License

This resource is licensed under the [MIT License](https://github.com/ethanfs20/driftmode/edit/main/LICENSE.md). You are free to use, modify, and distribute the resource as long as you include the original license file.

## Credits

Author: Ethan4t0r
GitHub Repository: https://github.com/ethanfs20/driftmode/edit/main/README.md

A special thanks to the FiveM community for the support and feedback!
