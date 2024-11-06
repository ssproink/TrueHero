class_name TrueHero
extends Entity

const SPEED = 500

signal SPChanged

@export var max_sp : int = 100
@export var sp : int = 100 :
	set(stamina):
		if not alive:
			return
		var old_sp = sp
		sp = clamp(stamina, 0, 100)
		if sp != old_sp:
			SPChanged.emit()
@export var sp_regen : int = 5
@export var level : int = 0 # For reviving in the last camp.

enum Skill { NONE, DODGE, ATTACK }
var current_skill = Skill.NONE
var cast_time : Dictionary = {
	Skill.DODGE: 1.0,
	Skill.ATTACK: 0.5,
}
var skill_cost : Dictionary = {
	Skill.DODGE: 20,
	Skill.ATTACK: 10,
}

func can_spend_stamina(sp : int) -> bool:
	return sp <= self.sp

func _on_regen_timer_timeout() -> void:
	if not is_bashed():
		hp += hp_regen
		sp += sp_regen

func use_skill(skill : Skill):
	if is_busy() or not can_spend_stamina(skill_cost[skill]):
		return
	current_skill = skill
	$SkillTimer.start(cast_time[skill])
	sp -= skill_cost[skill]

func is_busy() -> bool:
	return current_skill != Skill.NONE and current_skill != Skill.ATTACK

func _on_skill_timer_timeout() -> void:
	current_skill = Skill.NONE

func _on_bashed() -> void:
	$SkillTimer.stop()
	current_skill = Skill.NONE

func _ready() -> void:
	Bash.connect(_on_bashed)

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		velocity = Vector2.ZERO
		use_skill(Skill.DODGE)
	else:
		if Input.is_action_just_pressed("attack"):
			use_skill(Skill.ATTACK)
		var move_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		if move_direction and not is_bashed() and not is_busy():
			velocity = move_direction * SPEED
		else:
			velocity = Vector2.ZERO
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		look_at(get_global_mouse_position())
