extends Sprite

var velocity
var fan_scene
var xy_sign_collection


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	velocity = Vector2(50,0)
	
	for i in range(4):
		fan_scene = load("res://TopDroneFan.tscn")
		var fan = fan_scene.instance()
		add_child(fan)
		xy_sign_collection = [[1,1], [-1,1], [-1,-1], [1,-1]]
		var x_sign = xy_sign_collection[i][0] #x_sign has value of 1
		var y_sign = xy_sign_collection[i][1] #y_sign has value of -1
		fan.position = Vector2(x_sign*220, y_sign*142)
		fan.scale = Vector2(1,1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	pass
	position +=  velocity * delta


