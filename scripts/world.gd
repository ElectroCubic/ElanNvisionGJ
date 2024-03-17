extends Node2D

class_name World

signal speed_modified(multiplier: float)

var ice_multiplier: float = 1.5
var normal_multiplier: float = 1.0

@onready var player: CharacterBody2D = $Player

func _ready():
	Globals.connect("timeOut", restart)
	$UI/Failed.visible = false
	
	if Globals.time_running:
		$UI/TimerDisplay.visible = true
		if not Globals.lvlSwitch:
			Globals.gameTimer()
	else:
		$UI/TimerDisplay.visible = false

func _process(_delta):
	if Globals.timeCounter <= 0:
		Globals.time_running = false
		Globals.is_game_over = true

func _on_player_collided(collision):
	
	if collision.get_collider() is TileMap:
		var tile_pos = collision.get_collider().local_to_map($Player.position)
		tile_pos = tile_pos - Vector2i(collision.get_normal())
		
		var tile_under_pos = tile_pos + Vector2i(0,1)
		var tile_above_pos = tile_pos - Vector2i(0,1)
		var tile_data = collision.get_collider().get_cell_tile_data(0,tile_pos)
		var tile_under_data = collision.get_collider().get_cell_tile_data(0,tile_under_pos)
		var tile_above_data = collision.get_collider().get_cell_tile_data(0,tile_above_pos)
		
		if not (tile_data == null) and tile_pos:
			var custom_data = tile_data.get_custom_data_by_layer_id(0)
		
			if custom_data == 2:
				speed_modified.emit(ice_multiplier)
			else:
				speed_modified.emit(normal_multiplier)
				
		if not (tile_under_data == null) and tile_under_pos:
			var custom_under_data = tile_under_data.get_custom_data_by_layer_id(0)
			
			if custom_under_data == 3:
				player.death()
			
		if not (tile_above_data == null) and tile_above_pos:
			var custom_above_data = tile_above_data.get_custom_data_by_layer_id(0)
			
			if custom_above_data == 3:
				player.death()

func _on_ui_retry():
	Globals.lvlSwitch = false
	$UI/GameOverScreen.visible = false
	if not Globals.is_tutorial:
		Globals.time_running = true	
	Globals.is_game_over = false
	get_tree().reload_current_scene()

func _on_ui_restart():
	Globals.lvlSwitch = false
	$UI/Failed.visible = false
	Globals.is_game_over = false
	Globals.time_running = true
	Globals.timeCounter = 300
	get_tree().change_scene_to_file("res://scenes/levels/level1.tscn")
	
func restart():
	$UI/Failed.visible = true
