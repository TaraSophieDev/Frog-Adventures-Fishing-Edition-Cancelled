extends KinematicBody2D

onready var frogSprite = $FrogSprite
#onready var baitSprite = $FrogSprite/Bait/Sprite
onready var swimP = $SwimmingPlayer
onready var swingP = $SwingPlayer
onready var baitSpawn = $BaitSpawn
#onready var baitSpawnLeft = $BaitSpawnLeft
#onready var baitSpawnRight = $BaitSpawnRight

#onready var bait = get_node("BaitEntity")
onready var bait_scene = preload("res://Misc/BaitEntity.tscn")
var bait_instance = null



enum {
	MOVING,
	THROWING,
	FISHING,
	CATCHING
}
export var speed = 30

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
			pass
		FISHING:
			pass
		CATCHING:
			pass
	
	if frogSprite.flip_h == true:
		baitSpawn.position = Vector2(25, -5)
	else:
		baitSpawn.position = Vector2(-20, -5)
		
	motion = move_and_slide(motion)
	
	
func _physics_process(delta):
	if Input.is_action_just_pressed("a_button") and state == MOVING:
		playThrowingAnim(delta)        
		motion.x = 0
		state = THROWING
	

func move():
	#bait.visible = false
	frogSprite.frame = 0
	#Movement
	if Input.is_action_pressed("right"):
		motion.x = speed
		frogSprite.flip_h = true
	elif Input.is_action_pressed("left"):
		motion.x = -speed
		frogSprite.flip_h = false
	else:
		motion.x = 0


func playThrowingAnim(delta):
	state = THROWING
	swingP.play("swing")
	spawnBait(delta)

	
func spawnBait(delta):
	if is_instance_valid(bait_instance):
		bait_instance.queue_free()
	bait_instance = bait_scene.instance()
	if frogSprite.flip_h == true:
		bait_instance.position = baitSpawn.position
	elif frogSprite.flip_h == false:
		bait_instance.position = baitSpawn.position
	add_child(bait_instance)
	yield(get_tree().create_timer(1.10), "timeout")
	bait_instance.activate_bait()
	bait_instance.show()
	bait_instance.sleeping = true
	if frogSprite.flip_h == false:
		bait_instance.get_node("BaitSprite").flip_h = true
		#bait.global_position = baitSpawnLeft.get_global_position()
		bait_instance.sleeping = false
		bait_instance.visible = true
		bait_instance.apply_impulse(Vector2(0, 0), Vector2(-100, 0))
		state = FISHING
	if frogSprite.flip_h == true:
		bait_instance.get_node("BaitSprite").flip_h = false
		#bait.global_position = baitSpawnRight.get_global_position()
		bait_instance.sleeping = false
		bait_instance.visible = true
		bait_instance.apply_impulse(Vector2(0, 0), Vector2(100, 0))
		state = FISHING

	#get_tree().get_root().add_child(bait_instance)




func _on_Area2D_body_entered(body):
	if body.is_in_group("bait") and is_instance_valid(bait_instance) and state == FISHING:
		bait_instance.queue_free()
		state = MOVING
