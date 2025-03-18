extends Node

func _ready() -> void:
	Util.s_player_assigned.connect(_enable_descriptions)

func _enable_descriptions(player: Player) -> void:
	if not player.see_descriptions:
		player.see_descriptions = true