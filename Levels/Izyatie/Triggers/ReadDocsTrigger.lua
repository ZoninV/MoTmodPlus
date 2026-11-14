----------------------------------------------------------------------------
--
-- Description :  Read documents trigger
--
-- Created by Alexey Agamalov
--
----------------------------------------------------------------------------

 ReadDocsTrigger =
 {
 };
          
 function ReadDocsTrigger:OnInit()
 end

 function ReadDocsTrigger:OnPlayerAction()

     if ( Level.IsMissionFailed() != false ) then
       return;
     end;

     Level.PlayMenuSound("task_finish"); -- Liz Shaw
     Level.CompleteMissionTask('FIND', 15.0 );
     Level.EnableLevelMark( 'DOCS', false );
     Level.EnableLevelMark( 'RAUL', true );

     Level.RemovePlayerAction("DOCS");
     Level.UnregisterTrigger( self.Object );

 end

 function ReadDocsTrigger:OnEnterArea( sender )

     if ( Level.IsMissionTaskCompleted('FIND') == true ) then

       Level.UnregisterTrigger( self.Object );
       return;

     end;

     Level.AddPlayerAction("DOCS", MissionText.Message_Read, self.ObjectName, false);
 end

 function ReadDocsTrigger:OnLeaveArea( sender )
     Level.RemovePlayerAction("DOCS");
 end