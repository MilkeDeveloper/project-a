using Godot;

public partial class StarCourt : Node2D
{
	[Export] private CharacterBody2D player;
	[Export] private NavigationAgent2D navigation_component;
	private Vector2[] petagon_points = new Vector2[] {
		new Vector2(100, -200),
		new Vector2(100, 0),
		new Vector2(-100, -100),
		new Vector2(100, -100),
		new Vector2(0, 0),
	};

	private Vector2 player_position = new Vector2(0, 0);
	private int current_target_index = 0;
	private float move_speed = 900.0f;
	private bool is_moving = false;

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
	{
		SetProcess(false);
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		if(is_moving == true) {
			Vector2 target =  player_position + petagon_points[current_target_index];

			navigation_component.Call("set_destination", target);

			float distance_to_target = player.GlobalPosition.DistanceTo(target);
            GD.Print("Distance to target: ", distance_to_target);
			
			if(player.GlobalPosition.DistanceTo(target) <= 10.0f) {
				GD.Print("target reached");
				GD.Print("current target index: ", current_target_index);
				
				current_target_index = (current_target_index + 1) % petagon_points.Length;
				if(current_target_index == 0) {
					is_moving = false;
				}	
			}
		}
	}

	public void start_petagon_court(Vector2 p_position) {
		player_position = p_position;
		is_moving = true;
		current_target_index = 0;
		SetProcess(true);
	}
}

