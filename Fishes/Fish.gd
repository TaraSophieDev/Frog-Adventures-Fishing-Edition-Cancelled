extends KinematicBody2D

onready var sprite = $Sprite

enum {
	IDLE,
	NEW_DIR,
	MOVE
}

func _ready():
	randomize()

var SPEED = 5
var state = IDLE
var dir = Vector2.RIGHT

func _process(delta):
	match state:
		IDLE:
			pass
		NEW_DIR:
			dir = choose([Vector2.RIGHT, Vector2.LEFT])
			state = choose([IDLE, MOVE])
		MOVE:
			move(delta)

func move(delta):
	position += dir * SPEED * delta
	print(dir.x)
	if dir.x == 1:
		sprite.flip_h = true
	elif dir.x == -1:
		sprite.flip_h = false

func choose(array):
	array.shuffle()
	return array.front()


func _on_Timer_timeout():
	$Timer.wait_time = choose([0.25, 0.5, 1])
	print($Timer.wait_time)
	state = choose([IDLE, NEW_DIR, MOVE])
