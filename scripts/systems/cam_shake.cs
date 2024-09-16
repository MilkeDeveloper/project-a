using Godot;

public partial class cam_shake : Camera2D
{
	private float intensity = 0.0f;
	private float duration = 0.0f;
	private Vector2 original_position = Vector2.Zero;

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		if (duration > 0.0f)
		{
			float random_x = (float)GD.RandRange(-intensity, intensity);
   			float random_y = (float)GD.RandRange(-intensity, intensity);

			Position = original_position + new Vector2(random_x, random_y);
			duration -= (float)delta;
		}
		else
		{
			duration = 0.0f;
			Position = original_position;
		}
	}

	// Função para iniciar o camera shake
	public void apply_shake(float duration, float intensity)
	{
		this.intensity = intensity;
		this.duration = duration;
		original_position = Position;
	}
}
