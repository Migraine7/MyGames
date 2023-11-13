class_name Player
extends CharacterBody2D


# Player Child Nodes
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var collision_shape_2d = $CollisionShape2D


# State Machine
@onready var state_machine = $StateMachine as StateMachine
@onready var player_idle_state = $StateMachine/PlayerIdleState as PlayerIdleState
@onready var player_run_state = $StateMachine/PlayerRunState as PlayerRunState
@onready var player_jump_state = $StateMachine/PlayerJumpState as PlayerJumpState
@onready var player_hurt_state = $StateMachine/PlayerHurtState as PlayerHurtState


# Global variables
@export var speed = 100.0
@export var jump_velocity = -280.0


# Local variables
var is_started_moving = false
var is_dead = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready():
	Events.game_started.connect(state_machine.change_state.bind(player_run_state))
	player_run_state.player_jumped.connect(state_machine.change_state.bind(player_jump_state))
	player_jump_state.player_landed.connect(state_machine.change_state.bind(player_run_state))


func _on_collision_detector_area_entered(area):
	state_machine.change_state(player_hurt_state)
