@tool
extends EditorPlugin

const ACTIONS: Dictionary[String, EditorActionMapper.InputEventType] = {
	"forward": EditorActionMapper.INPUT_EVENT_TYPE_KEY,
	"left": EditorActionMapper.INPUT_EVENT_TYPE_KEY,
	"back": EditorActionMapper.INPUT_EVENT_TYPE_KEY,
	"right": EditorActionMapper.INPUT_EVENT_TYPE_KEY,
	"jump": EditorActionMapper.INPUT_EVENT_TYPE_KEY,
}
const EVENTS: Dictionary[String, Variant] = {
	"forward": KEY_W,
	"left": KEY_A,
	"back": KEY_S,
	"right": KEY_D,
	"jump": KEY_SPACE,
}


func format_actions(actions: Array[String]) -> String:
	var ret: String = ""

	for action: String in actions:
		ret += "  - %s: %s\n" % [action, OS.get_keycode_string(EVENTS[action])]

	return ret


func _enable_plugin() -> void:
	EditorNotifier.get_confirmation(
			"The following actions have been added to the input map of your "
			+ "project:\n%s" % format_actions(EditorActionMapper.bulk_map_actions(ACTIONS, EVENTS))
			+ "These actions will not appear in the input map tab until "
			+ "another action is added or the editor is restarted.",
			"Save & Restart",
			"OK",
			EditorInterface.restart_editor.bind(true))


func _disable_plugin() -> void:
	EditorNotifier.get_confirmation(
			"The following actions have been removed from the input map of your "
			+ "project:\n%s" % format_actions(EditorActionMapper.bulk_unmap_actions(ACTIONS.keys()))
			+ "These actions will not disappear from the input map tab until "
			+ "another action is added or the editor is restarted.",
			"Save & Restart",
			"OK",
			EditorInterface.restart_editor.bind(true))
