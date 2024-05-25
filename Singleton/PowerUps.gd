extends Node

# Ability flags
var bounce_unlocked = false
var wall_jump_unlocked = false

# Functions to unlock abilities
func unlock_bounce_ability():
	bounce_unlocked = true

func false_unlock_bounce_ability():
	bounce_unlocked = false
	
func unlock_wall_jump_ability():
	wall_jump_unlocked = true

func false_unlock_wall_jump_ability():
	wall_jump_unlocked = false
