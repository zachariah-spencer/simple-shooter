using Godot;
using System;

public partial class player : CharacterBody2D
{

	[Export]
	public int Speed { get; set; } = 8 * 16;

	
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{

	}

	// Gets user input for player character
	public void GetInput(){
		Vector2 inputDirection = Input.GetVector("left", "right", "up", "down");
		Velocity = inputDirection * Speed;
	}



	// Called every physics frame. 'delta' is the elapsed time since the previous frame.
	public override void _PhysicsProcess(double delta)
	{
		GetInput();
		MoveAndSlide();
	}
}
