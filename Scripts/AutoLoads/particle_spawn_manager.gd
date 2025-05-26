class_name particle_manager

static var particle_repo : Array[Dictionary] = [
	{"name" : "dust", "scene" : "res://Particles/dust_particles.tscn"},
	{"name" : "soul debris", "scene" : "res://Particles/debris_particles.tscn"},
	{"name" : "walk dust", "scene" : "res://Particles/walk_dust_particles.tscn"},
	{"name" : "hit dust", "scene" : "res://Particles/hit_dust.tscn"},
	{"name" : "death dust", "scene" : "res://Particles/death_dust.tscn"},
]

static func spawn_particle(particles : Array[String], parent : Node2D, spawnpos := Vector2(0, 0), amount : int = 1):
	var new_particles : Array
	
	for count in amount:
		for particle in particles:
			var particle_instance
			
			for entry in particle_repo:
				if entry["name"] == particle:
					particle_instance = load(entry["scene"]).instantiate()
			
			if particle_instance != null:
				particle_instance.global_position = spawnpos
				particle_instance.emitting = true
				parent.add_child(particle_instance)
				
				new_particles.append(particle_instance)
				
	
	return new_particles
