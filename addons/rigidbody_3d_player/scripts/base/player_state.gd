class_name PlayerState
extends State

const IDLE: String = "Idle"
const WALK: String = "Walk"
const FALL: String = "Fall"

var player: Player = null


func _ready() -> void:
	await owner.ready
	player = owner
