----------------------------------------------------------------------------
--
-- Description :  Get documents trigger
--
-- Created by Alexey Agamalov
--
----------------------------------------------------------------------------

 DisableAlertTrigger =
 {
 };

 function DisableAlertTrigger:OnInit()
 end

 function DisableAlertTrigger:OnPlayerAction()

     --print("DisableAlertTrigger:OnPlayerAction");
     if ( Level.IsMissionFailed() != false ) then
       return;
     end;

     Level.AlertDisabled = true;

    if (AI.IsLocalAlert(1) != false or
        AI.IsLocalAlert(2) != false or
        AI.IsLocalAlert(3) != false or
        AI.IsLocalAlert(4) != false or
        AI.IsLocalAlert(5) != false) then

       Level.EnableAlarmSound( false );
       Level.AddSmallMessage( MissionText.Message_AlarmFinished, 10.0, 255, 200, 200); -- AHO, 16.09.2008  
     end

     Level.RemovePlayerAction("DSAL");
     Level.UnregisterTrigger( self.Object );
     Level.EnableLevelMark( 'ALRT', false );

     AI.DisableAlert( true );
 end

 function DisableAlertTrigger:OnEnterArea( sender )
     if ( Level.AlertDisabled != false ) then
       Level.UnregisterTrigger( self.Object );
       return;
     end;

     Level.EnableLevelMark( 'ALRT', true );
     Level.AddPlayerAction("DSAL", MissionText.Message_DisableAlert, self.ObjectName, false);
 end

 function DisableAlertTrigger:OnLeaveArea( sender )
     Level.RemovePlayerAction("DSAL");
 end