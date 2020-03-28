class_name ZoriyaSettings
# Helper wrapper for convenient getting game settings


static func get_gravity() -> float:
	return ProjectSettings.get_setting("physics/3d/default_gravity")


static func get_velocity_interpolate_speed() -> int:
	return ProjectSettings.get_setting("physics/3d/velocity_interpolate_speed")


static func get_motion_interpolate_speed() -> int:
	return ProjectSettings.get_setting("physics/3d/motion_interpolate_speed") 
