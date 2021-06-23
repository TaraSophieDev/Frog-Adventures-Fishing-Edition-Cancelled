extends KinematicBody2D

onready var frogSprite = $FrogSprite
onready var swimP = $SwimmingPlayer
onready var swingP = $SwingPlayer
onready var baitSpawn = $BaitSpawn
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
var player_points: int = 0


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
	
	#sets bait spawn pos
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
		#instanciate bait
	bait_instance = bait_scene.instance()
	
	#sets bait instance to spawn pos
	if frogSprite.flip_h == true:
		bait_instance.position = baitSpawn.position
	elif frogSprite.flip_h == false:
		bait_instance.position = baitSpawn.position
	
	#spawns bait
	add_child(bait_instance)
	
	#waits for letting the bait move and thrown out
	yield(get_tree().create_timer(1.10), "timeout")
	
	#starts function to activate bait collision and movement
	bait_instance.activate_bait()
	bait_instance.show()
	bait_instance.sleeping = true
	
	#sets throw dir
	if frogSprite.flip_h == false:
		bait_instance.get_node("BaitSprite").flip_h = true
		#bait.global_position = baitSpawnLeft.get_global_position()
		bait_instance.sleeping = false
		bait_instance.visible = true
		bait_instance.apply_impulse(Vector2(0, 0), Vector2(-200, 0))
		state = FISHING
	if frogSprite.flip_h == true:
		bait_instance.get_node("BaitSprite").flip_h = false
		#bait.global_position = baitSpawnRight.get_global_position()
		bait_instance.sleeping = false
		bait_instance.visible = true
		bait_instance.apply_impulse(Vector2(0, 0), Vector2(200, 0))
		state = FISHING


func get_points(bait_points: int):
	print("test", bait_points)
	player_points += bait_points

func _on_Area2D_body_entered(body):
	#checks if the bait can be catched
	if body.is_in_group("bait") and is_instance_valid(bait_instance) and state == FISHING:
		bait_instance.queue_free()
		state = MOVING
