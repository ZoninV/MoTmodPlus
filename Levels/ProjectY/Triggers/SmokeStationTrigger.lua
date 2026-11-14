----------------------------------------------------------------------------
--
-- Description :  Smoke station trigger
--
-- Created by Sergey Gvozdev
--
-----------------------------------------------------------------------------
-- Die Panne in der Smokestation kann jetzt mehrfach vorgetäuscht werden
-- Das ist so realistischer! 
-- AHO 06.09.2008
----------------------------------------------------------------------------

 SmokeStationTrigger =
 {
 };

 function SmokeStationTrigger:OnInit()

 end

 function SmokeStationTrigger:OnPlayerAction()

     if ( Level.IsMissionFailed() != false ) then
       return;
     end;

    -- Deaktiviert von AHO,06.09.2008
    --AHO-ORG Level.RemovePlayerAction("SMKS");
    --AHO-ORG Level.UnregisterTrigger( self.Object );

     Level.EnableLevelMark( 'MAK5', false );
     Level.PlayEffect( "levels\\projecty\\smoke.sef", 153.0, -3.0, -356.0 );
     Level.PlayCrashAlertSound_2(true);

     local girl = AI.FindNPC('MP07');

     if (girl != nil) then
       if (AI.GetAttention(girl) == AI.ATTENTION_RELAX and
           AI.GetPlayerRoom() == AI.GetRoom(girl)) then

         local properties = Level.CreateCustomParams();
         Level.SetValue(properties, "CustomString_1", 'AN66');
         Level.SetValue(properties, "CustomString_2", 'AN69');
         Level.SetValue(properties, "CustomString_3", 'AN67');

         AI.RunScriptTask(girl, "scripts:job\\AnchorJob3_run_safe_att.lua", AI.LOGIC_DEFAULT, properties);
       end
     end

    -- Deaktiviert von AHO,06.09.2008 
    --AHO ORG Level.StationSmoke = true;
     Level.StationSmoke = false;

     AI.StartDecamouflage( 50.0, 80.0, 0.5 );
 end

 function SmokeStationTrigger:OnEnterArea( sender )
     if (Level.StationSmoke == false) then
        Level.AddPlayerAction("SMKS", MissionText.Message_SmokeStation, self.ObjectName, false);
     end
 end

 function SmokeStationTrigger:OnLeaveArea( sender )
     Level.RemovePlayerAction("SMKS");
 end