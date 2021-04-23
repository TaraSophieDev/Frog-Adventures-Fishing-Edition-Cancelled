extends RigidBody2D


onready var player = get_tree().get_nodes_in_group("player")[0]
onready var aP = $AnimationPlayer
onready var baitSprite = $BaitSprite
onready var fishSprite = $BaitSprite/FishSprite
#onready var cam = get_viewport().get_camera()

#var frogSprite = player.get_node("Player/FrogSprite")

var motion = Vector2()
var speed = 15
var jump_force_moving = 70
var jump_force = 80
#var player = is_in_group("player")


enum {
	IDLE,
	MOVING,
	BAITED,
	CATCHING
}

var state = IDLE

func _physics_process(delta):
	
	if baitSprite.flip_h == true:
		fishSprite.position = Vector2(5, 0)
	else:
		fishSprite.position = Vector2(-5, 0)
	
	#self.position.y = clamp(self.position.y, -80, 80)
	match state:
		IDLE:
			sleeping = true
		MOVING:
			sleeping = false
			move(delta)
			#motion.y += gravity
		BAITED:
			baited()
		CATCHING:
			catching()
		

	#motion = move_and_slide(motion)

func move(delta):
	#$Camera2D.current = true
	if Input.is_action_just_pressed("a_button"):
		#check if x coords is smaller than the frog x coords and otherwise
		print("player pos: ", player.position.x, " Bait Pos: ", global_position.x)
		if global_position.x > player.position.x - 1:
			apply_impulse(Vector2(0,0), Vector2(-speed, 0))
			baitSprite.flip_h = true
			fishSprite.flip_h = false
		if global_position.x < player.position.x + 1:
			apply_impulse(Vector2(0,0), Vector2(speed, 0))
			baitSprite.flip_h = false
			fishSprite.flip_h = true
		apply_central_impulse(Vector2.UP * jump_force_moving)
	if Input.is_action_just_pressed("left") || Input.is_action_just_pressed("right"):
		apply_central_impulse(Vector2.UP * jump_force)

	#sets sprite to y velocity
	if get_linear_velocity().y < 0.1:
		baitSprite.frame = 0
	elif get_linear_velocity().y > 0.1:
		baitSprite.frame = 1
	elif get_linear_velocity().y == 0:
		baitSprite.frame = 1




func baited():
	pass

func catching():
	pass



func _ready():
	pass


func activate_bait():
	$CollisionShape2D.disabled = false
	state = MOVING

func set_fish_sprite(var spritePath):
	print(spritePath)
	fishSprite.texture = load(spritePath)

func _on_Area2D_body_entered(body):
	if body.is_in_group("fish"):
		body.queue_free()
