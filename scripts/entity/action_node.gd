extends Node2D

@export var projectile_config: ProjectileData 
@export var Projectile: PackedScene
@export var entity: CharacterBody2D

var direction: Vector2
var damage: int

func fire_projectile(_attacker: CharacterBody2D):
	Combat.enemy = entity
	damage = entity.damage
	direction = entity.get_node("sprite").global_position.direction_to(_attacker.global_position)
	
	var projectile = Projectile.instantiate()
	
	projectile.position = entity.get_node("sprite").global_position
	projectile.projectile_data.texture = projectile_config.texture
	projectile.projectile_data.Projectile_logic = projectile_config.Projectile_logic
	projectile.var_direction =  direction
	projectile.var_speed = projectile_config.projectile_speed
	projectile.var_max_distance = projectile_config.max_distance
	projectile.var_attacker = entity
	projectile.var_damage = randi_range(damage * 0.8, damage)
	
	entity.get_parent().add_child(projectile)
