extends Control

@export var true_hero : TrueHero :
	set(our_hero):
		true_hero = our_hero
		if true_hero != null:
			true_hero.HPChanged.connect(hp_changed)
			$Bars/HPBar/Labels/ValueRegeneration.text = tr("+%dPER_SEC" % true_hero.hp_regen)
			true_hero.SPChanged.connect(sp_changed)
			$Bars/SPBar/Labels/ValueRegeneration.text = tr("+%dPER_SEC" % true_hero.sp_regen)

func hp_changed():
	$Bars/HPBar.value = true_hero.hp
	$Bars/HPBar/Labels/Value.text = str(true_hero.hp)

func sp_changed():
	$Bars/SPBar.value = true_hero.sp
	$Bars/SPBar/Labels/Value.text = str(true_hero.sp)

func _on_fps_refresh_timer_timeout() -> void:
	$FPSCounter/Counter.text = "%.0f" % round(Engine.get_frames_per_second())
