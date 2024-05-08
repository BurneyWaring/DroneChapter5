extends Sprite

var omega

func _ready():
	omega = 800

func _process(delta):
	rotation_degrees += omega * delta
