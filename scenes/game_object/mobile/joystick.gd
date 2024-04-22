extends Area2D

@onready var big_circle = $BigCircle
@onready var small_circle = $BigCircle/SmallCircle

@onready var max_distance = $CollisionShape2D.shape.radius

var touched = false

func _ready():
	if OS.get_name() != "Android":
		queue_free()

func _input(event):
	if event is InputEventScreenTouch:
		var distance = event.position.distance_to(big_circle.global_position)
		if !touched:
			if distance < max_distance:
				touched = true
		else:
			small_circle.position = Vector2.ZERO
			touched = false

func _process(delta):
	if touched:
		small_circle.global_position = get_global_mouse_position()
		small_circle.position = big_circle.position + (small_circle.position - big_circle.position).limit_length(max_distance)

func get_velocity():
	var joy_velocity = Vector2.ZERO
	joy_velocity.x = small_circle.position.x / max_distance
	joy_velocity.y = small_circle.position.y / max_distance
	return joy_velocity
