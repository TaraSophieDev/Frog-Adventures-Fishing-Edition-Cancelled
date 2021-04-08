extends KinematicBody2D

onready var frogSprite = $FrogSprite
#onready var baitSprite = $FrogSprite/Bait/Sprite
onready var swimP = $SwimmingPlayer
onready var swingP = $SwingPlayer
onready var bSLeft = $BaitSpawnLeft
onready var bSRight = $BaitSpawnRight

onready var bait = get_node("BaitEntity")


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

	if Input.is_action_just_pressed("a_button"):
		state = THROWING


func playThrowingAnim():
	swingP.play("swing")
	spawnBait()
	state = FISHING
	
func spawnBait():
	#var bait_instance = bait.instance()
	yield(get_tree().create_timer(1.10), "timeout")
	bait.show()
	if frogSprite.flip_h == false:
		bait.get_node("Sprite").flip_h = true
		bait.position = bSLeft.get_global_position()
		state = FISHING
	if frogSprite.flip_h == true:
		bait.get_node("Sprite").flip_h = false
		bait.position = bSRight.get_global_position()
		state = FISHING
	#get_tree().get_root().add_child(bait_instance)
