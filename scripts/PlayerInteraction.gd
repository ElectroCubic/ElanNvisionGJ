extends Node2D

signal speed_modified(multiplier: float)

var ice_multiplier: float = 1.5
var normal_multiplier: float = 1.0

func _ready():
	Globals.gameTimer()

func _process(_delta):
	$UI.update_timer_text()
	
	if Globals.timeCounter <= 0:
		print("Game Over")
		get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_player_collided(collision):
	
	if collision.get_collider() is TileMap:
		var tile_pos = collision.get_collider().local_to_map($Player.position)
		tile_pos = tile_pos - Vector2i(collision.get_normal())
		
		var tile_data = collision.get_collider().get_cell_tile_data(0,tile_pos)
		
		if not (tile_data == null) and tile_pos:
			var custom_data = tile_data.get_custom_data_by_layer_id(0)
	
			if custom_data == 2:
				speed_modified.emit(ice_multiplier)
			else:
				speed_modified.emit(normal_multiplier)
					
