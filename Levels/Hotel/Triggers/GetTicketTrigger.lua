----------------------------------------------------------------------------
--
-- Description :  Get ticket trigger
--
-- Created by Sergey Gvzodev
--
----------------------------------------------------------------------------

 GetTicketTrigger =
 {
 };
          
 function GetTicketTrigger:OnInit()
 end

 function GetTicketTrigger:OnPlayerAction()

     local ticket = Level.FindItem( 'PAS1' );
     if (ticket != nil) then
        Level.DeleteItem( ticket );
     end

     Level.RemovePlayerAction("TICK");
     Level.UnregisterTrigger( self.Object );

     Level.GiveTicket();

 end

 function GetTicketTrigger:OnEnterArea( sender )

     Level.AddPlayerAction("TICK", MissionText.Message_GetTicket, self.ObjectName, false);

 end

 function GetTicketTrigger:OnLeaveArea( sender )
     Level.RemovePlayerAction("TICK");
 end