extends RigidBody2D

onready var player = get_node("..")
onready var frogSprite = player.get_node("FrogSprite")
onready var aP = $AnimationPlayer

var motion = Vector2()
var speed = 15
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
	match state:
		IDLE:
			sleeping = true
		MOVING:
			#$Camera2D.current = true
			sleeping = false
			move(delta)
			#motion.y += gravity
		BAITED:
			baited()
		CATCHING:
			catching()
		

	#motion = move_and_slide(motion)

func move(delta):
	if Input.is_action_just_pressed("a_button"):
		#check if x coords is smaller than the frog x coords and otherwise
		print("player pos: ", player.position.x, " Bait Pos: ", global_position.x)
		if global_position.x > player.position.x - 1:
			apply_impulse(Vector2(0,0), Vector2(-speed, 0))
			$Sprite.flip_h = true
		if global_position.x < player.position.x + 1:
			apply_impulse(Vector2(0,0), Vector2(speed, 0))
			$Sprite.flip_h = false
		apply_central_impulse(Vector2.UP * jump_force)
		yield(get_tree().create_timer(0.25), "timeout")

	#sets sprite to y velocity
	if get_linear_velocity().y < 0.1:
		$Sprite.frame = 0
	elif get_linear_velocity().y > 0.1:
		$Sprite.frame = 1
	elif get_linear_velocity().y == 0:
		$Sprite.frame = 1




func baited():
	pass

func catching():
	pass



func _ready():
	pass


func _on_bait_activation():
	yield(get_tree().create_timer(1.05), "timeout")
	state = MOVING

