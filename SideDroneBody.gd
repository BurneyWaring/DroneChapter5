extends Sprite
var tankvolume = 100.0
var tankscale

func _ready():
	pass # Replace with function body.
	tankscale = $Tanklevel.scale.y
	
func _process(delta):
#	pass
	$Tanklevel.scale.y = tankscale * tankvolume/100.0

