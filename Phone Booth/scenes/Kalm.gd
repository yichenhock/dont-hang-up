extends Spatial

var ray_origin = Vector3()
var ray_target = Vector3()

# Called when the node enters the scene tree for the first time.
func _ready():
	print ($kalm_mask.rotation_degrees)
	
func _process(delta): 
	pass
#	print ($kalm_mask.rotation_degrees)
#	$kalm_mask.rotation_degrees.x = lerp($kalm_mask.rotation_degrees.x, get_global_mouse_position().x-(750/2),delta*0.04)

func _physics_process(delta):
	var space_state = get_world().direct_space_state
	var ray = space_state.intersect_ray(ray_origin,ray_target,[$kalm_mask],1,true,true)
	
	# get angle and update position
	if ray: 
		var ray_collision_point = ray.position
		var object_position = $kalm_mask.get_translation()
		ray_collision_point = object_position-ray_collision_point
		var angle = Vector2(ray_collision_point.x,ray_collision_point.z).angle_to(Vector2(object_position.x,object_position.z))
		$kalm_mask.set_rotation(Vector3(0,angle,0))

func _input(event): 
	if event is InputEventMouseMotion:
		ray_origin = $Camera.project_ray_origin(get_viewport().get_mouse_position())
		ray_target = $Camera.project_ray_normal(get_viewport().get_mouse_position())*1000
		print(ray_origin, " ",ray_target)
