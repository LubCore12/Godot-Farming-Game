class_name Player
extends CharacterBody2D

@onready var move_state_machine: AnimationNodeStateMachinePlayback = \
$AnimationTree.get("parameters/MoveStateMachine/playback")

var direction: Vector2

@export_group("Movement")
@export var speed: int

func _physics_process(_delta: float) -> void:
	get_input()
	velocity = direction * speed
	move_and_slide()
	animation()
	
func get_input() -> void:
	direction = Input.get_vector("left", "right", "up", "down")

func animation() -> void:
	var target_vector: Vector2 = Vector2(round(direction.x), round(direction.y))
	if direction:
		move_state_machine.travel("Move")
		$AnimationTree.set("parameters/MoveStateMachine/Move/blend_position", target_vector)
	else:
		move_state_machine.travel("Idle")
		$AnimationTree.set("parameters/MoveStateMachine/Idle/blend_position", target_vector)
