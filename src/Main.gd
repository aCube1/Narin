extends Node

onready var player := $PinkMan

var player_info := """
Player:
Position: {pos_x} | {pos_y}
Velocity: {vel_x} | {vel_y}
"""

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	$UI.offset = $PinkMan/Camera.offset

	$UI/Debug/PlayerInfo.text = player_info.format({
		"pos_x": player.position.x, "pos_y": player.position.y,
		"vel_x": player.velocity.x, "vel_y": player.velocity.y,
	})
