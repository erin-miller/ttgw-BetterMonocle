extends "res://objects/globals/util.gd"

func get_player() -> Player:
	var player = super()
	if not is_instance_valid(player):
		return null
	player.see_descriptions = true
	return player
