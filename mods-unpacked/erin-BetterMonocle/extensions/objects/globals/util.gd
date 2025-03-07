extends "res://objects/globals/util.gd"


func get_player() -> Player:
	var player = super()
	if player:
		player.see_descriptions = true
	return player
	
