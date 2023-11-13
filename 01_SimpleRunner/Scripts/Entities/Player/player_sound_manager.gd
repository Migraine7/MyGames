extends Node


@onready var jump_sound_player = $JumpSoundPlayer
@onready var hurt_sound_player = $HurtSoundPlayer


func play_jump_sound():
	jump_sound_player.play()


func play_hurt_sound():
	hurt_sound_player.play()
