@tool
extends EditorPlugin

const ACTIONS: Dictionary[String, Array] = {
	"forward": [KEY_W, "W"],
	"left": [KEY_A, "A"],
	"back": [KEY_S, "S"],
	"right": [KEY_D, "D"],
	"jump": [KEY_SPACE, "Space"],
}


func _enter_tree() -> void:
	var added_actions: Array[String] = []

	for action in ACTIONS.keys():
		var setting: String = "input/" + action

		if ProjectSettings.has_setting(setting):
			continue

		var event_key := InputEventKey.new()
		event_key.physical_keycode = ACTIONS[action][0]

		var input: Dictionary = {
			"deadzone": 0.2,
			"events": [event_key],
		}

		ProjectSettings.set_setting(setting, input)
		added_actions.append("    - %s: %s\n"%[action, ACTIONS[action][1]])

	if added_actions.size() < 1:
		return

	ProjectSettings.save()

	var dialog := ConfirmationDialog.new()
	dialog.size.x = 460
	dialog.exclusive = false
	dialog.unresizable = true
	dialog.dialog_autowrap = true
	dialog.initial_position = Window.WINDOW_INITIAL_POSITION_CENTER_MAIN_WINDOW_SCREEN

	var text: String = ("The following Actions are required by the Debug Console Plugin to function"
			+ " properly and have therefore been added to the Input Map of your Project:\n")

	for action in added_actions:
		text += action

	text += ("\nThese Actions will not appear in the Input Map tab until another Action is added or"
			+ " the Project is reloaded.")

	dialog.set_text(text)

	dialog.ok_button_text = "Save and Reload Project"
	dialog.cancel_button_text = "Reload Project Later"

	dialog.get_ok_button().pressed.connect(func(): EditorInterface.restart_editor(true))

	EditorInterface.get_base_control().add_child(dialog)

	dialog.popup()
	dialog.grab_focus()


func _exit_tree() -> void:
	pass
