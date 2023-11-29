class_name PlayerTurnState
extends State


@onready var player = $"../.."
@onready var animation_player = $"../../AnimationPlayer"


const NORMAL_COLOR = Color(1, 1, 1, 1)


func _ready():
	set_process(false)


func _enter_state():
	set_process(true)


func _exit_state():
	set_process(false)


func _process(_delta):
	if not player.is_card_held:
		if player.card_drop_location == player.Location.TRASH:
			Events.trash_card.emit()
			SoundManager.play_trash_card_sfx()			
			player.slow_end_turn()			
		elif player.card_drop_location == player.Location.USE:
			Events.use_card.emit()
			SoundManager.play_use_card_sfx()					
		elif player.card_drop_location != player.Location.NONE:
			Events.swapped_card.emit(player.card_drop_location)
			player.slow_end_turn()			

		player.card_drop_location = player.Location.NONE
