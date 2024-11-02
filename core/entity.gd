class_name Entity
extends CharacterBody2D

signal HPChanged
signal Death
signal Bash

@export var alive : bool = true
@export var hp_max : int = 100
@export var hp : int = 100 :
	set(health):
		if not alive:
			return
		var old_hp = hp
		hp = clamp(health, 0, hp_max)
		if old_hp != hp:
			HPChanged.emit()
		if hp == 0:
			alive = false
			Death.emit()
@export var hp_regen : int = 2

func bash(time : float):
	if $BashTimer.is_stopped():
		$BashTimer.start(time)
	else:
		$BashTimer.stop()
		$BashTimer.start($BashTimer.time_left + time)
	Bash.emit()

func is_bashed() -> bool:
	return not $BashTimer.is_stopped()

func _on_regen_timer_timeout() -> void:
	if not is_bashed():
		hp += hp_regen
