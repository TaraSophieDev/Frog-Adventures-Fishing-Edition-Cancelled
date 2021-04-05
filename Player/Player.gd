extends KinematicBody2D

onready var frogSprite = $FrogSprite
onready var baitSprite = $FrogSprite/Bait/Sprite
onready var swimP = $SwimmingPlayer
onready var swingP = $SwingPlayer


enum {
	MOVING,
	THROWING,
	FISHING,
	CATCHING
}
var speed = 25

var motion = Vector2()
var state = MOVING

func _ready():
	swimP.play("swimming")
	pass

func _process(delta):
	match state:
		MOVING:
			move()
		THROWING:
			playThrowingAnim()
		FISHING:
			print("Fishing")
		CATCHING:
			pass
	
	#Checks if a button is activated		
	if Input.is_action_just_pressed("a_button"):
		state = THROWING
	
	motion = move_and_slide(motion)

func move():
	if Input.is_action_pressed("right"):
		motion.x = speed
		frogSprite.flip_h = true
	elif Input.is_action_pressed("left"):
		motion.x = -speed
		frogSprite.flip_h = false
	else:
		motion.x = 0

func playThrowingAnim():
	swingP.play("swing")
	state = FISHING
