using Godot;
using System;

public partial class Player : CharacterBody2D
{

	[Export]
	public int Speed { get; set; } = 8 * 16;

	public void GetInput()
	{
		Vector2 inputDirection = Input.GetVector("left", "right", "up", "down");
		Velocity = Velocity.Lerp(inputDirection * Speed, (float) 0.1);

		if(Input.IsActionJustPressed("shoot")){
			GD.Print("Mouse Button Clicked!");

			var bulletScene = GD.Load<PackedScene>("res://scenes/Bullet.tscn");
			var bulletInstance = bulletScene.Instantiate<Bullet>();
			bulletInstance.Position = this.Position;
			bulletInstance.SetDirection(Vector2.Right);

			AddChild(bulletInstance);

		}
	}
	public override void _PhysicsProcess(double delta)
	{
		GetInput();
		MoveAndSlide();
	}

}
