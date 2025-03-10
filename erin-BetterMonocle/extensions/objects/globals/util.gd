extends "res://objects/globals/util.gd"


func get_player() -> Player:
	var player = super()
	if player and is_instance_valid(player):
		player.see_descriptions = true
	return player
