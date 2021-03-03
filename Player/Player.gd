extends KinematicBody2D

onready var sprite = $Sprite

var speed = 25

var motion = Vector2()

func _ready():
	pass

func _physics_process(delta):
	
	if Input.is_action_pressed("right"):
		motion.x = speed
		sprite.flip_h = true
	elif Input.is_action_pressed("left"):
		motion.x = -speed
		sprite.flip_h = false
	else:
		motion.x = 0
		
	motion = move_and_slide(motion)
