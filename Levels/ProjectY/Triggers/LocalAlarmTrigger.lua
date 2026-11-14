----------------------------------------------------------------------------
--
-- Description :  Activate local alarm at control room
--
-- Created by Sergey Gvozdev
--
----------------------------------------------------------------------------

 LocalAlarmTrigger =
 {
 };
          
 function LocalAlarmTrigger:OnInit()
 end

 function LocalAlarmTrigger:OnPlayerAction()

     if ( Level.IsMissionFailed() != false ) then
       return;
     end;

     local normal = {};
     local pos = {};
             
     normal.x,normal.y,normal.z = Trigger.GetNormal( self.Object );
     pos.x,pos.y,pos.z          = Trigger.GetPosition( self.Object );

     Actor.BlendTransform( Level.GetPlayer(), pos.x, pos.y, pos.z, normal.x, normal.y, normal.z, 3.0);

     Level.StartPlayerCustomAnim("Custom_Radio", 0, true, true, 'CLLA');

     AI.StartDecamouflage( 50.0, 80.0, 5.0 );

     Level.InstallDpc("Level.LocalAlarmTimer()", 5.0);

     Level.RemovePlayerAction("CLLA");
     Level.UnregisterTrigger( self.Object );

 end

 function Level.LocalAlarmTimer()

     Level.EnableLevelMark( 'MAK4', false );
     local officer = AI.FindNPC('MO03');

     if (AI.IsDefault(officer) != false) then

       local properties = Level.CreateCustomParams();
       Level.SetValue(properties, "CustomString_1", 'AN78');

       AI.RunScriptTask(officer, "scripts:job\\AnchorJob_safe.lua", AI.LOGIC_DEFAULT, properties);
     end

     Level.LocalAlarm = true;
 end                                                      

 function LocalAlarmTrigger:OnEnterArea( sender )

     if (Level.LocalAlarm == false) then
        Level.AddPlayerAction("CLLA", MissionText.Message_AlarmSignal, self.ObjectName, false);
     end
 end

 function LocalAlarmTrigger:OnLeaveArea( sender )
     Level.RemovePlayerAction("CLLA");
 end