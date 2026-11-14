----------------------------------------------------------------------------
--
-- Description :  Broke radio station trigger
--
-- Created by Sergey Gvozdev
--
----------------------------------------------------------------------------

 BrokeRadioTrigger =
 {
 };

 function BrokeRadioTrigger:OnInit()
 end

 function BrokeRadioTrigger:OnPlayerAction()

     local normal = {};
     local pos = {};
             
     normal.x,normal.y,normal.z = Trigger.GetNormal( self.Object );
     pos.x,pos.y,pos.z          = Trigger.GetPosition( self.Object );

     Actor.BlendTransform( Level.GetPlayer(), pos.x, pos.y, pos.z, normal.x, normal.y, normal.z, 3.0);

     Level.StartPlayerCustomAnim("Custom_Radio", 0, true, true, 'BKRD');
     AI.AddSound( AI.SOUND_TYPE_DEFAULT, 150.0, 125, 28, 2229);

     if (AI.GetPlayerForm() != "RAD1") then 
        AI.StartDecamouflage( 30.0, 100.0, 5.0 );
     end

     Level.InstallDpc("Level.BrokeRadioTimer()", 5.0);

     Level.RemovePlayerAction("BKRD");
     Level.UnregisterTrigger( self.Object );

 end

 function Level.BrokeRadioTimer()

     Level.RadioBroken = true;

     Level.EnableLevelMark( 'MAK6', false );
 end

 function BrokeRadioTrigger:OnEnterArea( sender )
     if (Level.RadioBroken == false) then
       Level.AddPlayerAction("BKRD", MissionText.Message_Station, self.ObjectName, false);
     end
 end

 function BrokeRadioTrigger:OnLeaveArea( sender )
     Level.RemovePlayerAction("BKRD");
 end