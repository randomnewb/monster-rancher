extends Control

@onready var ITEM_SPRITE2D_SCENE = preload("res://UI/ItemSprite2D.tscn")
@onready var inventory_display = $InventoryDisplay

func _on_player_mini_game_won():
	var item_sprite2d_scene = ITEM_SPRITE2D_SCENE.instantiate();
	self.add_child.call_deferred(item_sprite2d_scene);
	item_sprite2d_scene.frame = Global.reward;
	item_sprite2d_scene.position = Vector2((inventory_display.position.x + (Global.inventory.size() * 5)), inventory_display.position.y);
