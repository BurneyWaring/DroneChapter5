extends Sprite

var top_drone
var top_drone_treatment
var side_drone_treatment
var frame_count
var rand_num_gen = RandomNumberGenerator.new()
var flightmode_on = true
var treatment_on = false
var velocity
var side_drone
var droprate
var theta
var t
var dropArea = 12*12 #82 #corrected estimate
var fieldArea = 1400*320
var percentTreated = 0.0
var areaTreated = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	top_drone = $TopDroneBody
	frame_count = 0
	side_drone = $SideDroneBody
	droprate = 0.2
	side_drone.tankvolume = 100
	t=0
	theta = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	side_drone.position.y = 70  #just a convenient height
	frame_count += 1

	if flightmode_on:
		t += delta
		theta = 0.1*t
		velocity = 0.05*Vector2(700*sin(5*theta), 120*cos(3*theta))
		velocity = stepify(sqrt(velocity.x*velocity.x + velocity.y*velocity.y), 0.1)
	else:
		velocity = 0
	
	top_drone.position = Vector2(700*sin(5*theta), -190 + 120*cos(3*theta))	
	side_drone.position.x = top_drone.position.x
	
	if treatment_on:
		if side_drone.tankvolume <= 0:
			treatment_on = false
		if frame_count % 20 == 0:
			var top_drone_treatment_scene = load("res://TopDroneTreatment.tscn")
			top_drone_treatment = top_drone_treatment_scene.instance(-1)
			add_child(top_drone_treatment)
			top_drone_treatment.scale = Vector2(0.015,0.015)
			
			var spread = Vector2(0, rand_num_gen.randf_range(-20.0, 20.0))
			top_drone_treatment.position = top_drone.position + spread
			
			var side_drone_treatment_scene = load("res://SideDroneTreatment.tscn")
			side_drone_treatment = side_drone_treatment_scene.instance()
			add_child(side_drone_treatment)
			side_drone_treatment.scale = Vector2(0.025, 0.025)
			side_drone_treatment.position.x = top_drone_treatment.position.x
			side_drone_treatment.position.y = 110
			
			side_drone.tankvolume += -droprate
			
			areaTreated += dropArea
			percentTreated = (areaTreated/fieldArea) * 100.0
			percentTreated = stepify(percentTreated, 0.1)
		
	$InfoBoard.text = "Tank Volume = " + str(side_drone.tankvolume)
	$InfoBoard.text =  $InfoBoard.text + "\n Speed = " + str(velocity)
	$InfoBoard.text =  $InfoBoard.text + "\n AreaTreated = " + str(percentTreated) + " %"
	
	#to include image analysis
	if side_drone.tankvolume <0:
		imageprocess()
		

func _on_DroneControlButton_pressed():
	pass # Replace with function body.
	flightmode_on = !flightmode_on


func _on_DroneTreatmentButton_pressed():
	pass # Replace with function body.
	treatment_on = !treatment_on


func _on_ExitButton_pressed():
	pass # Replace with function body.	
	get_tree().quit()
	
func imageprocess():
			$TopDroneBody.visible = false
			$SideDroneBody.visible = false
			var white = 0
			var green = 0
			get_tree().paused = true  #this stops _process from being called any more
			var image = get_tree().get_root().get_texture().get_data()
			image.lock() #this is necessary to prevent simulation from freezing up when trying to look at all the pixels
			image.flip_y()
			image.save_png("test pic.png")  #this is useful to see the image that will be processed
#			var size = image.get_size()
			var countmisses = 0
			var totalpixels = 0
			for j in range(4,256): #this is the range of pixels that in y direction are originally green (top edge is light green)
				for i in range(1,1023): #this is the range of pixels that in x direction are originally green (left and right edges are gray)
					var pixel = image.get_pixel(i, j)
					totalpixels += 1
					if(pixel[0]==1 and pixel[1]==1 and pixel[2]==1):
						white += 1
					elif(pixel[0]==0 and pixel[1]==1 and pixel[2]==0): 
						green += 1
					else:
						#these are a few pixels with dithered colors that are not green or white
						countmisses += 1

			prints("not green or white", countmisses)
			#check the accuracy
#            prints("white, green", white, green)
#            prints("check", white+green+countmisses, totalpixels)
			percentTreated = white*100.0/totalpixels 
			$InfoBoard.text += "\nAreaTreated(by pixel analysis) = " + str(stepify(percentTreated, 0.1)) + " %"



