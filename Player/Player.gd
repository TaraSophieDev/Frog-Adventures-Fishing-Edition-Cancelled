extends KinematicBody2D

onready var frogSprite = $FrogSprite
onready var baitSprite = $FrogSprite/Bait/Sprite
onready var ap = $AnimationPlayer
onready var sp = $SwimmingPlayer

var speed = 25

var motion = Vector2()

func _ready():
	sp.play("swimming")
	pass

func _physics_process(delta):
	
	if Input.is_action_pressed("right"):
		motion.x = speed
		frogSprite.flip_h = true
		baitSprite.flip_h = true
		ap.play("bait_right")
	elif Input.is_action_pressed("left"):
		motion.x = -speed
		frogSprite.flip_h = false
		baitSprite.flip_h = false
		ap.play("bait_left")
	else:
		motion.x = 0
		
	motion = move_and_slide(motion)
