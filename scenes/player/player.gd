extends CharacterBody2D

@onready var move_state_machine: AnimationNodeStateMachinePlayback = $AnimationTree.get("parameters/MoveStateMachine/playback")

const SPEED = 300.0
var direction := Vector2.ZERO


func _physics_process(_delta: float) -> void:
	get_input()
	velocity = direction * SPEED
	move_and_slide()
	animation()

func get_input():
	direction = Input.get_vector("left", "right", "up", "down")

func animation():
	if direction:
		var target_vector: Vector2 = Vector2(round(direction.x), round(direction.y))
		move_state_machine.travel("move")
		$AnimationTree.set("parameters/MoveStateMachine/move/blend_position", target_vector)
		$AnimationTree.set("parameters/MoveStateMachine/idle/blend_position", target_vector)
	else:
		move_state_machine.travel("idle")