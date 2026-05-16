extends CharacterBody2D

@onready var move_state_machine: AnimationNodeStateMachinePlayback = $AnimationTree.get("parameters/MoveStateMachine/playback")

const SPEED = 300.0
var direction := Vector2.ZERO

enum Tools {AXE, HOE, WATER_CAN}
var current_tool := Tools.AXE

func _physics_process(_delta: float) -> void:
	get_input()
	velocity = direction * SPEED
	move_and_slide()
	animation()


func get_input() -> void:
	direction = Input.get_vector("left", "right", "up", "down")
	if Input.is_action_just_pressed("tool_forward"):
		current_tool = posmod(current_tool + 1, Tools.size()) as Tools
		print(current_tool)
	if Input.is_action_just_pressed("tool_backward"):
		current_tool = posmod(current_tool - 1, Tools.size()) as Tools
		print(current_tool)


func animation() -> void:
	if direction:
		var target_vector: Vector2 = Vector2(round(direction.x), round(direction.y))
		move_state_machine.travel("move")
		$AnimationTree.set("parameters/MoveStateMachine/move/blend_position", target_vector)
		$AnimationTree.set("parameters/MoveStateMachine/idle/blend_position", target_vector)
	else:
		move_state_machine.travel("idle")