using Godot;
using System;

public partial class Movement : CharacterBody3D
{
    [Export]
    public float gravity = 20;
    [Export]
    public float speed = 20;
    [Export]
    public float runSpeedMultiplier = 2f;
    [Export]
    public float jumpForce = 5;
    [Export]
    public int jumpEnduranceCost = 5; 
    [Export]
    public float acceleration = 1f;
    [Export]
    public float sensitivity = 0.01f;
    [Export]
    public float climbSpeed = 3f; 

    [Export]
    public int maxEndurance = 100; 

    [Export]
    public int currentEndurance = 50; 

    [Export]
    public int enduranceRegenRate = 5; 
    [Export]
    public int dashSpeed = 100;
    [Export]
    public int dashEnduranceCost = 5;  
    
    private bool isWalking = false;
    private bool isRunning = false;
    private bool isClimbing = false;
    private bool isDashing = false;
    private bool isJumping = false;
    private bool isUsingEndurance = false;
    private bool canUseEndurance = true;
    private Timer regenDelayTimer;
    private Timer regenTimer;
    private Timer dashTimer;
    private Timer jumpTimer;
    private Vector3 dashDirection = Vector3.Zero;
    private ProgressBar enduranceBar;


    public Camera3D camera;

    private Vector3 velocity = Vector3.Zero;

    public override void _Ready()
    {
        camera = GetNode<Camera3D>("FirstCamera");
        regenDelayTimer = GetNode<Timer>("Endurance/regenDelayTimer");
        regenTimer = GetNode<Timer>("Endurance/regenTimer");
        dashTimer = GetNode<Timer>("Endurance/dashTimer");
        jumpTimer = GetNode<Timer>("Endurance/jumpTimer");

        Callable regen_endurance_delay_callable = new Callable(this, MethodName.on_regen_endurance_delay_timeout);
        regenDelayTimer.Connect("timeout", regen_endurance_delay_callable);

        Callable regen_endurance_callable = new Callable(this, MethodName.regen_endurance);
        regenTimer.Connect("timeout", regen_endurance_callable);

        Callable dash_callable = new Callable(this, MethodName.on_dash_timer_timeout);
        dashTimer.Connect("timeout", dash_callable);

        Callable jump_callable = new Callable(this, MethodName.on_jump_timer_timeout);
        jumpTimer.Connect("timeout", jump_callable);

        enduranceBar = GetNode<ProgressBar>("UI/Endurance/EnduranceBar");
        enduranceBar.Value = currentEndurance;
        enduranceBar.MaxValue = maxEndurance;
        regenTimer.Start();
    }

    public override void _Input(InputEvent @event)
    {
        if (@event is InputEventMouseMotion){
            InputEventMouseMotion mouse_motion = @event as InputEventMouseMotion;
            RotateY(-mouse_motion.Relative.X * sensitivity);
        }
    }

    public void is_running(){
        if (Input.IsActionPressed("Run") && canUseEndurance)
        {
            isRunning = true;
        }
        else
        {
            isRunning = false;
        }
    }

    public void groundMovement(Vector3 direction){
        is_running();
        dash(direction);
        if (isDashing){
            isWalking = false;
            velocity.X = dashDirection.X * dashSpeed;
            velocity.Z = dashDirection.Z * dashSpeed;
        }
        else{
            if(direction != Vector3.Zero){
                isWalking = true;
                velocity.X = direction.X * speed;
                velocity.Z = direction.Z * speed;
            }else{
                isWalking = false;
                velocity.X = Mathf.MoveToward(velocity.X, 0, acceleration);
                velocity.Z = Mathf.MoveToward(velocity.Z, 0, acceleration);
                //velocity = Vector3.Zero;
            }
            if (isRunning && direction != Vector3.Zero)
            {
                velocity.X *= runSpeedMultiplier;
                velocity.Z *= runSpeedMultiplier;
                currentEndurance -= 1;
            }
        }
    }

    public void jumpMovement(double delta){
        if (IsOnFloor() && currentEndurance >= jumpEnduranceCost){
            isJumping = true;
            jumpTimer.Start();
        }
    }

    public void is_climbing(double delta){
        RayCast3D wall_check_high = GetNode<RayCast3D>("WallCheck/wall_check_high");
        RayCast3D wall_check_down = GetNode<RayCast3D>("WallCheck/wall_check_low");
        bool can_climb = false;
        if (wall_check_down.IsColliding() && canUseEndurance){
                can_climb = true;
        }
        
        if (!isClimbing && can_climb && Input.IsActionPressed("Up")){
            isClimbing = true;
        }else if (isClimbing && !Input.IsActionJustReleased("Up")){
            isClimbing = false;
        }else if (isClimbing && !can_climb){
            isClimbing = false;
        }else if (!isClimbing && Input.IsActionJustPressed("Up") && !Input.IsActionJustPressed("Dash")){
            jumpMovement(delta);
            currentEndurance -= jumpEnduranceCost;
        }

        if(wall_check_down.IsColliding() && !wall_check_high.IsColliding()){
            
            velocity.Y = 10;
            currentEndurance -= 1;
        }else if(isClimbing){
            gravity = 0;
            Vector3 direction = Vector3.Zero;
            float vertical_movement = Input.GetActionRawStrength("Front") - Input.GetActionRawStrength("Back");
            float lateral_movement = Input.GetActionRawStrength("Right") - Input.GetActionRawStrength("Left");
            float rot = -(Mathf.Atan2(wall_check_down.GetCollisionNormal().Z,wall_check_down.GetCollisionNormal().X) - (Mathf.Pi/2));
            direction = new Vector3(lateral_movement, vertical_movement, 0).Rotated(Vector3.Up, rot).Normalized();
            velocity.X = direction.X * climbSpeed;
            velocity.Y = direction.Y * climbSpeed;
            //currentEndurance -= 1;
        }
        else {
            gravity = 20;
        }
        
        if(isJumping){
            velocity.Y = jumpForce;
        }
        else if (!IsOnFloor()){
            velocity.Y -= gravity * (float)delta;
        }
        else if (!isClimbing){
            velocity.Y = 0;
        }
    }

    public void regen_endurance(){
        if(currentEndurance + enduranceRegenRate <= maxEndurance){
            currentEndurance += enduranceRegenRate;
        }
        if (currentEndurance < maxEndurance && !isUsingEndurance){
            regenTimer.Start(); // Regen until full
        }
    }

    public void on_regen_endurance_delay_timeout()
    {
        if(! isUsingEndurance){
            regenTimer.Start();
        }
    }

    public void is_using_endurance(){
        if (isClimbing || isRunning){
            isUsingEndurance = true;
        }
        else{
            isUsingEndurance = false;
        }
    }

    public void can_use_endurance(){
        if(currentEndurance <= 0){
            canUseEndurance = false;
        }
        else{
            canUseEndurance = true;
        }
    }

    public void dash(Vector3 direction){
        if(Input.IsActionJustPressed("Dash")){
            if(!isDashing && currentEndurance >= dashEnduranceCost && IsOnFloor()){
                isDashing = true;
                currentEndurance -= dashEnduranceCost;
                dashTimer.Start();
                if(direction != Vector3.Zero){
                    dashDirection = direction;
                }else{
                    dashDirection = -Transform.Basis.Z;
                }
            }
        }
    }

    public void on_dash_timer_timeout()
    {
        isDashing = false;
        velocity = Vector3.Zero;
        dashTimer.Stop();
    }

    public void on_jump_timer_timeout()
    {
        isJumping = false;
        velocity.Y = 0;
        jumpTimer.Stop();
    }

    public override void _Process(double delta)
    {
        enduranceBar.Value = currentEndurance;
    }

    public override void _PhysicsProcess(double delta)
    {
        Vector2 input_dir = Input.GetVector("Left", "Right", "Front", "Back");
        Vector3 direction = (GlobalTransform.Basis * new Vector3(input_dir.X, 0, input_dir.Y)).Normalized();
        can_use_endurance();
        is_climbing(delta);
        if(! isClimbing){
            groundMovement(direction);
        }
        
        Velocity = velocity;
        is_using_endurance();
        if (isUsingEndurance && !regenTimer.IsStopped()){
            regenTimer.Stop();
            regenDelayTimer.Stop();
        }
        else if (! isUsingEndurance && regenDelayTimer.IsStopped()){
            regenDelayTimer.Start();
        }
        MoveAndSlide();
    }
}
