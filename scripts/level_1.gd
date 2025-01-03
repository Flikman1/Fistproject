extends Node2D

@onready var light = $DirectionalLight2D
@onready var Pointlight = $PointLight2D
@onready var Pointlight1 = $PointLight2D2
@onready var scoreDay = $CanvasLayer/ScoreDay
@onready var anim_time = $Light/AnimationPlayer
@onready var anim = $CanvasLayer/AnimationPlayer

enum {
	MORNING,
	DAY,
	EVENING,
	NIGHT
}

var state = MORNING
var day_count: int

func _ready() -> void:
	$Light/DirectionalLight2D.enabled = true
	day_count = 0
	set_day_text()
	# Запускаем цикл с утра
	morning_state()

func morning_state():
	# Увеличиваем число дней только здесь, один раз за новый цикл
	day_count += 1
	set_day_text()
	anim_time.play("Morning")
	await anim_time.animation_finished
	state = DAY
	day_state()

func day_state():
	anim_time.play("Day")
	await anim_time.animation_finished
	state = EVENING
	evening_state()

func evening_state():
	anim_time.play("evening")
	await anim_time.animation_finished
	# После окончания анимации уже можно менять характеристики света
	var tween1 = get_tree().create_tween()
	tween1.tween_property(Pointlight, "energy", 1, 20)
	tween1.tween_property(Pointlight1, "energy", 1, 20)
	state = NIGHT
	night_state()

func night_state():
	anim_time.play("Night")
	await anim_time.animation_finished
	state = MORNING
	# Переходим к новому дню
	morning_state()

func set_day_text():
	scoreDay.text = "DAY " + str(day_count)
	anim.play("Day_text_1")
	anim.play("Day_text_2")
