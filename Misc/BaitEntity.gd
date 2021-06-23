extends RigidBody2D


onready var player = get_tree().get_nodes_in_group("player")[0]
onready var aP = $AnimationPlayer
onready var baitSprite = $BaitSprite
onready var fishSprite = $BaitSprite/FishSprite
onready var fightTimer = $FightTimer
onready var fishAnimation = $FishAnimation
#onready var cam = get_viewport().get_camera()

#var frogSprite = player.get_node("Player/FrogSprite")
export var time: float = 2

var motion = Vector2()
var speed: int = 15
var fight_speed: int = 150
var jump_force_moving: int = 50
var jump_force: int = 50
var points: int = 0
var bait_points: int
#var player = is_in_group("player")


enum {
	IDLE,
	MOVING,
	FIGHTING,
	CATCHING
}

var state = IDLE

func _ready():
	fightTimer.wait_time = time

func _physics_process(delta):
	#sets fish sprite position to baitSprite orientation
	if baitSprite.flip_h == true:
		fishSprite.position = Vector2(5, 0)
	else:
		fishSprite.position = Vector2(-5, 0)
		

	match state:
		IDLE:
			sleeping = true
		MOVING:
			sleeping = false
			move(delta)
		FIGHTING:
			fighting(delta)
			move(delta)
			#motion.y += gravity
		CATCHING:
			catching()
		

	#motion = move_and_slide(motion)

func move(delta):
	#$Camera2D.current = true
	if Input.is_action_just_pressed("a_button"):
		#check if x coords is smaller than the frog x coords and otherwise
		print("player pos: ", player.position.x, " Bait Pos: ", global_position.x)
		#sets impulse direction to player pos
		if global_position.x > player.position.x - 1:
			apply_impulse(Vector2(0,0), Vector2(-speed, 0))
			baitSprite.flip_h = true
			fishSprite.flip_h = false
		if global_position.x < player.position.x + 1:
			apply_impulse(Vector2(0,0), Vector2(speed, 0))
			baitSprite.flip_h = false
			fishSprite.flip_h = true
		apply_central_impulse(Vector2.UP * jump_force_moving)
	#checks if left or right is pressed to only add a central impulse to up dir
	if Input.is_action_just_pressed("left") || Input.is_action_just_pressed("right"):
		apply_central_impulse(Vector2.UP * jump_force)

	#sets sprite frame to y velocity
	if get_linear_velocity().y < 0.1:
		baitSprite.frame = 0
	elif get_linear_velocity().y > 0.1:
		baitSprite.frame = 1
	elif get_linear_velocity().y == 0:
		baitSprite.frame = 1



func fighting(delta):
	fishAnimation.play("Fighting")
	#fightTimer.start(time)
	if fightTimer.time_left == 0:
		#print("time left: ", fightTimer.time_left)
		if global_position.x > player.position.x:
			baitSprite.flip_h = false
			fishSprite.flip_h = true
			apply_impulse(Vector2(0,0), Vector2(fight_speed, 0))
			fightTimer.start(time)
		if global_position.x < player.position.x :
			baitSprite.flip_h = true
			fishSprite.flip_h = false
			apply_impulse(Vector2(0,0), Vector2(-fight_speed, 0))
			fightTimer.start(time)
		apply_central_impulse(Vector2.UP)
	
func catching():
	pass


func activate_bait():
	$CollisionShape2D.disabled = false
	state = MOVING

func set_fish_sprite(var spritePath):
	print(spritePath)
	fishSprite.texture = load(spritePath)
	state = FIGHTING

func set_points():
	print("test: ", points)
	points += bait_points
	
func get_points(fish_points: int):
	print("cringe")
	fish_points = bait_points

func _on_Area2D_body_entered(body):
	if body.is_in_group("fish"):
		body.queue_free()
		baitSprite.hide
	if body.is_in_group("player"):
		print("CBT")
		body.get_points(bait_points)
