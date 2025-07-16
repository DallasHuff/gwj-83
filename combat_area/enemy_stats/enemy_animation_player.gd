extends AnimationPlayer

func setup(sprites: SpriteFrames) -> void:
	for anim_name in sprites.get_animation_names():
		# Get duration of animation in AnimatedSprite2D
		var frame_count := sprites.get_frame_count(anim_name)
		var frames_per_second := sprites.get_animation_speed(anim_name)
		var seconds := frame_count / frames_per_second
		# Set duration of animation in AnimationPlayer
		get_animation(anim_name).length = seconds
		# If there's logic associated with this animation, set the logic track
		# to a length comparable to the animation length
		if get_animation(anim_name).get_track_count() > 1:
			get_animation(anim_name).track_set_key_time(1, 0, seconds * 0.75)
	