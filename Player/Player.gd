extends KinematicBody2D

onready var frogSprite = $FrogSprite
onready var baitSprite = $FrogSprite/Bait/Sprite
onready var swimP = $SwimmingPlayer
onready var swingP = $SwingPlayer
onready var bSLeft = $BaitSpawnLeft
onready var bSRight = $BaitSpawnRight

onready var bait = preload("res://Misc/BaitEntity.tscn")


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
	spawnBait()
	state = FISHING
	
func spawnBait():
	var bait_instance = bait.instance()
	yield(get_tree().create_timer(1.10), "timeout")
	if frogSprite.flip_h == false:
		bait_instance.get_node("Sprite").flip_h = true
		bait_instance.position = bSLeft.get_global_position()
	if frogSprite.flip_h == true:
		bait_instance.get_node("Sprite").flip_h = false
		bait_instance.position = bSRight.get_global_position()
	get_tree().get_root().add_child(bait_instance)
