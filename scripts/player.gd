extends KinematicBody2D

onready var anim = $AnimationPlayer

var speed = 30
var velocity = Vector2()

func _ready():
	pass

func _physics_process(delta):
	
	anim.play("IDLE")
	$AnimatedSprite.speed_scale = 0.08+speed/25
	velocity = Vector2()
	
	if Input.is_action_pressed("MOVE_UP"):
		anim.play("MOVE")
		velocity.y -= 1
	
	if Input.is_action_pressed("MOVE_DOWN"):
		anim.play("MOVE")
		velocity.y += 1
	
	if Input.is_action_pressed("MOVE_LEFT") and Input.is_action_pressed("MOVE_RIGHT"):
		pass
	else:
		if Input.is_action_pressed("MOVE_LEFT"):
			anim.play("MOVE_LEFT")
			velocity.x -= 1
		
		if Input.is_action_pressed("MOVE_RIGHT"):
			anim.play("MOVE_RIGHT")
			velocity.x += 1
	
	velocity = velocity.normalized() * speed

func _process(delta):
	move_and_collide(velocity * delta)
