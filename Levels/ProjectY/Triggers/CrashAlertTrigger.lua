-----------------------------------------------------------------------------
--
-- Description :  Crash alert trigger
--
-- Created by Sergey Gvozdev
--
-----------------------------------------------------------------------------
-- Der lokal ALarm im Zyklotron-Labor kann nun immer wieder ausgelöst werden.
-- AHO, 06.09.2008
-----------------------------------------------------------------------------

 CrashAlertTrigger =
 {
 };

 function CrashAlertTrigger:OnInit()
 end

 function CrashAlertTrigger:OnPlayerAction()

     if ( Level.IsMissionFailed() != false ) then
       return;
     end;

     -- Beides deaktiviert von AHO, 06.09.2008
     -- Level.RemovePlayerAction("CRAL");
     -- Level.UnregisterTrigger( self.Object );

     Level.EnableLevelMark( 'MAK6', false );
     local soldier = AI.FindNPC('MS06');

     if (AI.IsDefault(soldier) != false) then

       local properties = Level.CreateCustomParams();
       Level.SetValue(properties, "CustomString_1", 'AN72');
       Level.SetValue(properties, "CustomString_2", 'AN73');

       AI.RunScriptTask(soldier, "scripts:job\\AnchorJob2_run_att.lua", AI.LOGIC_NEUTRAL, properties);
     end

     -- Auf false gesetzt von AHO, 06.09.2008
     -- Level.CrashAlert = true;
     Level.CrashAlert = false;

     Level.PlayCrashAlertSound( true );

     AI.AddSound( AI.SOUND_TYPE_DEFAULT, 150.0, -434, -40, 210);
     AI.StartDecamouflage( 150.0, 250.0, 5 );
 end

 function CrashAlertTrigger:OnEnterArea( sender )

     if (Level.CrashAlert == false) then
        Level.AddPlayerAction("CRAL", MissionText.Message_CrashAlert, self.ObjectName, false);
     end
 end

 function CrashAlertTrigger:OnLeaveArea( sender )
     Level.RemovePlayerAction("CRAL");
 end