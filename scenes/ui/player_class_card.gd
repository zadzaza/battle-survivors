extends PanelContainer

@onready var name_label: Label = %NameLabel
@onready var description_label: Label = %DescriptionLabel
@onready var select_button: Button = %SelectButton
@onready var texture: TextureRect = %Texture

var player_class: PlayerClass

func _ready() -> void:
	select_button.pressed.connect(on_select_pressed)
	ClassManager.class_selected.connect(on_class_selected)

func play_in() -> void:
	modulate = Color.TRANSPARENT
	modulate = Color.WHITE
	$AnimationPlayer.play('selected')

func update_progress():
	pass

func set_class_card(class_id):
	self.player_class = load(ClassManager.PLAYER_CLASSES[class_id])
	name_label.text = player_class.title
	texture.texture = load(player_class.texture_path)
	description_label.text = player_class.description

func on_class_selected(selected_class_id: String) -> void:
	if player_class.id == selected_class_id:
		select_button.text = "Выбрано"
	else:
		select_button.text = "Выбрать"

func on_select_pressed():
	ClassManager.set_class(player_class.id)
	play_in()
