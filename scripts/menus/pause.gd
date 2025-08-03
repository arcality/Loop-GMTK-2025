extends Control

signal restart_loop

func _process(delta: float) -> void:
	testEsc()

func _ready() -> void:
	hide()
	$Blur.play("RESET")

func resume():
	get_tree().paused = false
	$".".hide()
	$Blur.play_backwards("blur")

func pause():
	get_tree().paused = true
	$PanelContainer/SettingsMenu/MainVolSlider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")))
	$PanelContainer/SettingsMenu/MusicVolSlider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("MUSIC")))
	$PanelContainer/SettingsMenu/SfxVolSlider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")))
	$".".show()
	$Blur.play("blur")

func testEsc():
	if Input.is_action_just_pressed("Escape") and !get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("Escape") and get_tree().paused:
		resume()


func _on_resume_pressed() -> void:
	resume()


func _on_restart_loop_pressed() -> void:
	resume()
	restart_loop.emit()


func _on_settings_pressed() -> void:
	$PanelContainer/MainButtons.visible = false
	$PanelContainer/SettingsMenu.visible = true


func _on_back_pressed() -> void:
	$PanelContainer/MainButtons.visible = true
	$PanelContainer/SettingsMenu.visible = false


func _on_main_vol_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Master"), value)


func _on_music_vol_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("MUSIC"), value)


func _on_sfx_vol_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("SFX"), value)


func _on_quit_pressed() -> void:
	get_tree().paused = false
	hide()  # hide the pause menu just in case
	get_tree().reload_current_scene()
