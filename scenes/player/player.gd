extends CharacterBody2D

@onready var move_state_machine: AnimationNodeStateMachinePlayback = $AnimationTree.get("parameters/MoveStateMachine/playback")
@onready var tool_state_machine: AnimationNodeStateMachinePlayback = $AnimationTree.get("parameters/ToolStateMachine/playback")

const SPEED = 150.0
var direction := Vector2.ZERO
var can_move := true

enum Tools {AXE, HOE, WATER_CAN}
var current_tool := Tools.AXE
const tool_connection = {
	Tools.AXE: "axe",
	Tools.HOE: "hoe",
	Tools.WATER_CAN: "water"
}

func _physics_process(_delta: float) -> void:
	if can_move:
		get_input()
	velocity = direction * SPEED * int(can_move)
	move_and_slide()
	animation()


func get_input() -> void:
	direction = Input.get_vector("left", "right", "up", "down")

	if Input.is_action_just_pressed("action"):
		tool_state_machine.travel(tool_connection[current_tool])
		$AnimationTree.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		can_move = false

	if Input.is_action_just_pressed("tool_backward") or Input.is_action_just_pressed("tool_forward"):
		var tool_direction = Input.get_axis("tool_backward", "tool_forward") as int
		current_tool = posmod(current_tool + tool_direction, Tools.size()) as Tools
		print(current_tool)


func animation() -> void:
	if direction:
		var target_vector: Vector2 = Vector2(round(direction.x), round(direction.y))
		move_state_machine.travel("move")
		$AnimationTree.set("parameters/MoveStateMachine/move/blend_position", target_vector)
		$AnimationTree.set("parameters/MoveStateMachine/idle/blend_position", target_vector)
		for state in tool_connection.values():
			$AnimationTree.set("parameters/ToolStateMachine/%s/blend_position" % state, target_vector)

	else:
		move_state_machine.travel("idle")


func _on_animation_tree_animation_finished(_anim_name: StringName) -> void:
	can_move = true
