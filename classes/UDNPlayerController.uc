class UDNPlayerController extends UTPlayerController;

Reliable Client Function ClientSetHUD(Class<Hud> NewHudType)
{
    Super.ClientSetHUD(Class'HudFix');
}

state PlayerWalking
{
ignores SeePlayer, HearNoise, Bump;

   function ProcessMove(float DeltaTime, vector NewAccel, eDoubleClickDir DoubleClickMove, rotator DeltaRot)
   {
      local Rotator tempRot;

      if( Pawn == None )
      {
         return;
      }

      if (Role == ROLE_Authority)
      {
         // Update ViewPitch for remote clients
         Pawn.SetRemoteViewPitch( Rotation.Pitch );
      }

      Pawn.Acceleration.X = -1 * PlayerInput.aStrafe * DeltaTime * 100 * PlayerInput.MoveForwardSpeed;
      Pawn.Acceleration.Y = 0;
      Pawn.Acceleration.Z = 0;
      
      tempRot.Pitch = Pawn.Rotation.Pitch;
      tempRot.Roll = 0;
      if(Normal(Pawn.Acceleration) Dot Vect(1,0,0) > 0)
      {
         tempRot.Yaw = 0;
         Pawn.SetRotation(tempRot);
      }
      else if(Normal(Pawn.Acceleration) Dot Vect(1,0,0) < 0)
      {
         tempRot.Yaw = 32768;
         Pawn.SetRotation(tempRot);
      }

      CheckJumpOrDuck();
   }
}

function UpdateRotation( float DeltaTime )
{
   local Rotator   DeltaRot, ViewRotation;

   ViewRotation = Rotation;

   // Calculate Delta to be applied on ViewRotation
   DeltaRot.Yaw = Pawn.Rotation.Yaw;
   DeltaRot.Pitch   = PlayerInput.aLookUp;

   ProcessViewRotation( DeltaTime, ViewRotation, DeltaRot );
   SetRotation(ViewRotation);
}   

defaultproperties
{
}