extends KinematicBody2D

onready var sprite = $Sprite
onready var ap = $AnimationPlayer
onready var swimTimer = $SwimTimer

export var time = 3

signal baited

enum {
	MOVE,
	CHANGE_DIR,
	BAITED
}

func _ready():
	swimTimer.wait_time = time

export var speed = 10
var state = MOVE
var dir = Vector2.RIGHT

func _process(delta):
	match state:
		MOVE:
			move(delta)
		BAITED:
			baited()

func move(delta):
	print(swimTimer.time_left)
	if swimTimer.time_left == 0:
		if sprite.flip_h == true:
			dir = Vector2.LEFT
			swimTimer.start(time)
		elif sprite.flip_h == false:
			dir = Vector2.RIGHT
			swimTimer.start(time)
	ap.play("Swim")
	position += dir * speed * delta
	if dir == Vector2.RIGHT:
		sprite.flip_h = true
	elif dir == Vector2.LEFT:
		sprite.flip_h = false

func change_dir():
	print(swimTimer.time_left)
	
func baited():
	ap.play("Chase")
	emit_signal("baited")
	print("baited")


func _on_Area2D_body_entered(body):
	if body.is_in_group("bait"):
		body.set_fish_sprite($Sprite.texture.resource_path)
		queue_free()
