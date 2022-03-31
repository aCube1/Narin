extends Node

onready var player := $PinkMan

var player_info := """
Player:
Position: {pos_x} | {pos_y}
Velocity: {vel_x} | {vel_y}
Motion: {mot_x} | {mot_y}	
"""

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	$UI.offset = $PinkMan/Camera.offset

	$UI/Debug/PlayerInfo.text = player_info.format({
		"pos_x": player.position.x, "pos_y": player.position.y,
		"vel_x": player.velocity.x, "vel_y": player.velocity.y,
		"mot_x": player.motion.x, "mot_y": player.motion.y,
	})