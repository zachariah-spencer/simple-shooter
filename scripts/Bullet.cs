using Godot;
using System;

public partial class Bullet : CharacterBody2D
{
	public const float Speed = 8.0f * 16.0f;
	private Vector2 Direction = Vector2.Zero;

    public void SetDirection(Vector2 Direction)
		{
			this.Direction = Direction;
		}

    public override void _PhysicsProcess(double delta)
	{
		Velocity = Direction * Speed;
		MoveAndSlide();
	}
	
}
