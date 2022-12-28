extends Node2D

onready var bgSprite = get_node("bg_sprite")
onready var bgTextureSize = bgSprite.texture.get_size()
onready var viewportContainer = get_node("ViewportContainer")
onready var viewport = get_node("ViewportContainer/Viewport")


func _ready():
	get_viewport().connect("size_changed", self, "_root_viewport_size_changed")
	_root_viewport_size_changed()

func _root_viewport_size_changed():
	var newSize = get_viewport().size
	var bgSpriteSize = newSize.y / bgTextureSize.y
	bgSprite.scale = Vector2(bgSpriteSize,bgSpriteSize)
	viewportContainer.rect_size = newSize
	viewportContainer.rect_position = -(newSize/2)
	viewport.size = newSize
