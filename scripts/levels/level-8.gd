extends Level

signal cutscene_finished

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var dialogue_label: Label = $UI/DialogueLabel

var _dialogues = [
	{ text = "Oh goodness, you scared me!", time = 4.0 },
	{ text = "Wait, who are you?", time = 4.0 },
	{ text = "Oh no. Were you in here while I was sleeping?", time = 6.0 },
	{ text = "Oh my! I’m terribly sorry.", time = 4.0 },
	{ text = "You see, I cast a time repetition spell on my tower every night when I fall asleep,", time = 10.0 },
	{ text = "so that I can get even more sleep in even less time.", time = 7.0 },
	{ text = "I never meant to catch a stranger in my tower!", time = 6.0 },
	{ text = "I never get visitors, so I thought it was safe…", time = 6.0 },
	{ text = "I hope you’ll forgive an old rat like me for such an unfortunate mishap…", time = 6.0 },
]

var speed: float = 60.0 / 65.0

var destination: Vector2 = Vector2(100.0, 0)
const START: Vector2 = Vector2(0.0, 0.0)

@onready var tween_positions: Array[Vector2] = [
	START,
	destination
]

var is_cutscene_active = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.play("sleep")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if is_cutscene_active:
		return
	if body is ThrowableItem or body is Player:
		is_cutscene_active = true
		start_cutscene()


func start_cutscene() -> void:
	print("Cutscene start")
	
	## play wake animation
	sprite.play("wake")
	await sprite.animation_finished
	print("wake finished")
	
	sprite.position.y += 4;
	
	var destination = Vector2(384.0/2.0, sprite.position.y)
	sprite.play("run")
	var tween: Tween = create_tween()
	tween.tween_property(sprite, "position", destination, 1)
	await tween.finished
	print("done")
	
	sprite.play("idle")
	for dlg in _dialogues:
		dialogue_label.text = dlg.text
		dialogue_label.visible = true
		await get_tree().create_timer(dlg.time).timeout
		dialogue_label.visible = false
	
	emit_signal("cutscene_finished")
	
