----------------------------------------------------------------------------
--
-- Description :  Broke radio station trigger
--
-- Created by Sergey Gvozdev
--
----------------------------------------------------------------------------

 ShnapsPoisonTrigger =
 {
 };

 function ShnapsPoisonTrigger:OnInit()
 end

 function ShnapsPoisonTrigger:OnPlayerAction( actionId )

     if ( Actor.HasCustomEquipment( Level.GetPlayer(), 'POIS' ) == false ) then
        Level.AddSmallMessage( MissionText.Poison_Need, 8.0, 255, 255, 255 );
        return false;        
     end

     local normal = {};
     local pos = {};
             
     normal.x,normal.y,normal.z = Trigger.GetNormal( self.Object );
     pos.x,pos.y,pos.z          = Trigger.GetPosition( self.Object );

     Actor.BlendTransform( Level.GetPlayer(), pos.x, pos.y, pos.z, normal.x, normal.y, normal.z, 3.0);

     Level.StartPlayerCustomAnim("Custom_UsePoison", 0, true, true, 'SPTG');

     AI.StartDecamouflage( 50.0, 100.0, 4.0 );

     Level.InstallDpc("Level.ShnapsPoisonTimer()", 4.0);

     Level.RemovePlayerAction("SPTG");
     Level.UnregisterTrigger( self.Object );

 end

 function Level.ShnapsPoisonTimer()

     Level.ShnapsPoisoned = true;

     local job = nil;
     job = AI.GetScriptJob( AI.FindNPC( 'GO01' ) );
     Job.SetCustomFlag( job, Job.TCF_CAN_BE_DISABLED, false );
     job = AI.GetScriptJob( AI.FindNPC( 'LIQ2' ) );
     Job.SetCustomFlag( job, Job.TCF_CAN_BE_DISABLED, false );

     Level.EnableLevelMark( 'MAK7', false );
 end

 function ShnapsPoisonTrigger:OnEnterArea( sender )
     if (Level.ShnapsPoisoned == false) then
       Level.AddPlayerAction("SPTG", MissionText.Message_Poison, self.ObjectName, false);
     end
 end

 function ShnapsPoisonTrigger:OnLeaveArea( sender )
     Level.RemovePlayerAction("SPTG");
 end