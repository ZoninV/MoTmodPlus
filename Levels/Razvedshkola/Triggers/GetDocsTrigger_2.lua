----------------------------------------------------------------------------
--
-- Description :  Get documents trigger
--
-- Created by Alexey Agamalov
--
----------------------------------------------------------------------------

 GetDocsTrigger_2 =
 {

 };
          
 function  GetDocsTrigger_2:OnInit()

 end

 function GetDocsTrigger_2:OnPlayerAction()

     if ( Level.IsMissionFailed() != false ) then
       return;
     end;

     Level.Docs[2] = true;

     if ( Level.Docs[1] == true ) then

        Level.CheckLeaveTask('KART');
        Level.PlayMenuSound("task_finish"); -- Liz Shaw
        Level.CompleteMissionTask('KART', 15.0 );

     else

        Level.SetMissionTaskFloor('KART', 3);

     end;

     Level.EnableLevelMark( 'KAR2' , false );

     Level.RemovePlayerAction("DOCS");
     Level.UnregisterTrigger( self.Object );

     Level.SeifTrigger = nil;
 end

 function GetDocsTrigger_2:OnEnterArea( sender )

     if ( Level.Docs[2] != false ) then

       Level.SeifTrigger = nil;
       Level.UnregisterTrigger( self.Object );
       return;

     end;

     Level.SeifTrigger = self;

     if ( Level.SeifDoor != nil and Level.IsDoorOpened( Level.SeifDoor ) == false ) then
 
       return;

     end;

     Level.AddPlayerAction("DOCS", MissionText.Message_Docs, self.ObjectName, false);
 end

 function GetDocsTrigger_2:OnLeaveArea( sender )
     Level.RemovePlayerAction("DOCS");
     Level.SeifTrigger = nil;
 end