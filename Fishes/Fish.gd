extends KinematicBody2D

var swim_speed = 10
var baited_speed = 12
var time = 0

onready var timer = $Timer

var motion = Vector2()


enum state {
	swimming,
	idle,
	baited
}

var fish_state = state.swimming
#var fish_state = state.swimming

func process_state():
	match fish_state:
		state.idle:
			#print("Idle")
			process_idle()
		state.swimming:
			#print("Swimming")
			process_swimming()
		state.baited:
			#print("Baited")
			process_baited()

func process_baited():
	pass

func process_swimming():
	motion.x = swim_speed

func process_idle():
	pass

func timer_rand():
	timer.start(rand_range(2,6))
	print(timer.wait_time)

func _ready():
	timer_rand()
	
func _process(delta):
	process_state()
	motion = move_and_slide(motion)

	
