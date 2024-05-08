extends Sprite
var gravity = 9.8
var vy  = 0 
var vx = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	pass
	vy += 0.5*gravity*pow(delta,2)
	
	if(position.y >= 280):
		position.y = 280
		
	else:
		position.y += vy
		position.x += vx
