# godot-rigidbody_3d_player

A RigidBody3D based first person character controller implementation packaged in a Godot plugin for easier reuse across projects.

## Installation

### Dependencies:

godot-rigidbody_3d_player requires the following addons to be present in your project in order to funtion:
- [godot-nbfsm](https://github.com/snddude/godot-nbfsm)

After ensuring that you have satisfied all the necessary dependencies, download the [latest release](https://github.com/snddude/godot-rigidbody_3d_player/releases/latest) of the plugin (comes in a zip archive) and extract it into your project's "addons/" folder. After that, go to Project -> Project Settings -> Plugins and enable "RigidBody3D Player".

## Usage

You can either instantiate or create an inherited scene of the player scene that is provided by the plugin, depending on whether or not you want to extend it's functionality. The player's behaviour is state machine based (hence the dependency). The state machine based player implementation is mostly inspired by GDQuest's example from his [node based finite state machine tutorial](https://www.gdquest.com/tutorial/godot/design-patterns/finite-state-machine/). How exactly to build up from this basic implementation is entirely up to you.

## License

This plugin is distributed under the [MIT License](https://en.wikipedia.org/wiki/MIT_License).
