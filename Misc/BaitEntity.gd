extends KinematicBody2D

onready var player = get_node("..")
onready var frogSprite = player.get_node("FrogSprite")

var motion = Vector2()
var speed = 200
var gravity = 5
#var player = is_in_group("player")


enum {
	MOVING,
	BAITED,
	CATCHING
}

var state = MOVING

func _physics_process(delta):
	match state:
		MOVING:
			move(delta)
			motion.y += gravity

		BAITED:
			baited()
		CATCHING:
			catching()
		

	motion = move_and_slide(motion)

func move(delta):
	if Input.is_action_just_pressed("a_button"):
		if frogSprite.flip_h == false:
			motion.x = -speed
		if frogSprite.flip_h == true:
			motion.x = speed
		motion.y -= 40
		yield(get_tree().create_timer(0.5), "timeout")
	else:
		motion.x = 0


func baited():
	pass

func catching():
	pass



func _ready():
	pass
