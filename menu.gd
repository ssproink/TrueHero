extends Control

func _on_continue_game_pressed() -> void:
	pass

func _on_new_game_pressed() -> void:
	pass

func _on_exit_pressed() -> void:
	get_tree().quit()

func _ready() -> void:
	prepare_language_selection()

var translations : Dictionary = {}

func prepare_language_selection():
	var current_locale_selected = false
	for locale_id : String in TranslationServer.get_loaded_locales():
		var locale_name = TranslationServer.get_locale_name(locale_id)
		translations[locale_name] = locale_id
		$OtherButtons/Language.get_popup().add_item(locale_name)
		if locale_id == OS.get_locale_language():
			$OtherButtons/Language.selected = $OtherButtons/Language.get_popup().item_count - 1
	$OtherButtons/Language.get_popup().id_pressed.connect(_on_locale_selected)

func _on_locale_selected(id : int):
	var locale_name = $OtherButtons/Language.get_popup().get_item_text(id)
	TranslationServer.set_locale(translations[locale_name])
