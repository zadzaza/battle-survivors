extends Node2D

@onready var collision: CollisionShape2D = $Area/Collision
@onready var texture: Sprite2D = $Texture
@onready var area_range: Area2D = $Area
@onready var random_stream: RandomStreamPlayer2DComponent = $RandomStreamPlayer2DComponent
@onready var rng: RandomNumberGenerator = RandomNumberGenerator.new()

var vial_type = "unknown"

func _ready():
	area_range.area_entered.connect(on_area_entered)
	choose_vial_type()
	
func choose_vial_type():
	rng.randomize()
	
	if rng.randf() < 0.97:
		texture.texture = load("res://scenes/game_object/vials/experience_vial.png")
	else:
		texture.texture = load("res://scenes/game_object/vials/health_vial.png")
		
	if texture.texture.resource_path == "res://scenes/game_object/vials/experience_vial.png":
		vial_type = "experience_vial"
	elif texture.texture.resource_path == "res://scenes/game_object/vials/health_vial.png":
		vial_type = "health_vial"

func tween_collect(percent: float, start_position: Vector2):
	var player = get_tree().get_first_node_in_group('player')
	if player == null:
		return
	
	global_position = start_position.lerp(player.global_position, percent)
	var direction_from_start = player.global_position - start_position
	
	var target_rotation = direction_from_start.angle() + deg_to_rad(90)
	rotation = lerp_angle(rotation, target_rotation, 1 - exp(-2 * get_process_delta_time()))


func collect():
	GameEvents.emit_vial_collected(1, vial_type)
	queue_free()

func disable_collision():
	collision.disabled = true


func on_area_entered(area: Area2D) -> void:
	Callable(disable_collision).call_deferred()
	Callable($ShadowComponent.queue_free).call_deferred()
	
	var tween = create_tween() 
	tween.set_parallel()
	tween.tween_method(
		tween_collect.bind(global_position),
		0.0,
		1.0,
		.5
	).set_ease(
		Tween.EASE_IN
	).set_trans(
		Tween.TRANS_BACK
	)
	tween.tween_property(texture, 'scale', Vector2.ZERO, .05).set_delay(.45)
	tween.chain()
	tween.tween_callback(collect)
	
	random_stream.play_random()
