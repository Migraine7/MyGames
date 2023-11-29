extends Node


@onready var animation_player = $AnimationPlayer as AnimationPlayer
@onready var game_music = $GameMusic as AudioStreamPlayer

@onready var trash_card_sound = $TrashCardSound
@onready var use_card_sound = $UseCardSound
@onready var draw_card_sound = $DrawCardSound
@onready var swap_card_sound = $SwapCardSound
@onready var ring_bell_sound = $RingBellSound


const GAME_MUSIC_VOLUME = -40.0
const MUTE_VOLUME = -80.0


func play_trash_card_sfx():
	trash_card_sound.play()


func play_use_card_sfx():
	use_card_sound.play()


func play_draw_card_sfx():
	draw_card_sound.play()


func play_swap_card_sfx():
	swap_card_sound.play()
	
	
func play_ring_bell_sfx():
	ring_bell_sound.play()
