class_name Player
extends CharacterBody2D

@onready var move_state_machine: AnimationNodeStateMachinePlayback = \
$AnimationTree.get("parameters/MoveStateMachine/playback")
@onready var tool_state_machine: AnimationNodeStateMachinePlayback = \
$AnimationTree.get("parameters/ToolStateMachine/playback")

enum Tools {HOE, AXE, WATER}
var current_tool: Tools = Tools.AXE
const TOOL_COLLECTION = {
	Tools.HOE: "Hoe",
	Tools.AXE: "Axe",
	Tools.WATER: "Water"
}

var direction: Vector2
var can_move := true

@export_group("Movement")
@export var speed: int

func _physics_process(_delta: float) -> void:
	if can_move:
		get_input()
		velocity = direction * speed
		move_and_slide()
	animation()
	
func get_input() -> void:
	direction = Input.get_vector("left", "right", "up", "down")
	
	if Input.is_action_just_pressed("action"):
		tool_state_machine.travel(TOOL_COLLECTION[current_tool])
		$AnimationTree.set("parameters/OneShot/request", 
							AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		can_move = false
		await $AnimationTree.animation_finished
		can_move = true
		
	
	if Input.is_action_just_pressed("tool_forward") or Input.is_action_just_pressed("tool_backward"):
		var tool_axis = Input.get_axis("tool_backward", "tool_forward")
		current_tool = posmod(current_tool + tool_axis, Tools.size()) as Tools

func animation() -> void:
	var target_vector: Vector2 = Vector2(round(direction.x), round(direction.y))
	if direction:
		move_state_machine.travel("Move")
		$AnimationTree.set("parameters/MoveStateMachine/Move/blend_position", target_vector)
		$AnimationTree.set("parameters/MoveStateMachine/Idle/blend_position", target_vector)
		for state in TOOL_COLLECTION.values():
			$AnimationTree.set("parameters/ToolStateMachine/{state}/blend_position".format({"state": state}), target_vector)
	else:
		move_state_machine.travel("Idle")
