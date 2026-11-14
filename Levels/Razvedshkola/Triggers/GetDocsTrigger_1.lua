----------------------------------------------------------------------------
--
-- Description :  Get documents trigger
--
-- Created by Alexey Agamalov
--
----------------------------------------------------------------------------

 GetDocsTrigger_1 =
 {

 };
          
 function  GetDocsTrigger_1:OnInit()

 end

 function GetDocsTrigger_1:OnPlayerAction()

     if ( Level.IsMissionFailed() != false ) then
       return;
     end;

     local normal = {};
     local pos = {};
             
     normal.x,normal.y,normal.z = Trigger.GetNormal( self.Object );
     pos.x,pos.y,pos.z          = Trigger.GetPosition( self.Object );

     Actor.BlendTransform( Level.GetPlayer(), pos.x, pos.y, pos.z, normal.x, normal.y, normal.z, 3.0);

     Level.StartPlayerCustomAnim("Custom_SearchBookshelf", 0, true, true, 'GDOC' );

     AI.StartDecamouflage( 60.0, 80.0, 7.0 );

     Level.InstallDpc("Level.DoGetDocsTimer()", 7.0);

     Level.RemovePlayerAction("DOCS");
     Level.UnregisterTrigger( self.Object );

 end

 function Level.DoGetDocsTimer()

     Level.Docs[1] = true;

     if ( Level.Docs[2] == true ) then

        Level.CheckLeaveTask('KART');
        Level.PlayMenuSound("task_finish"); -- Liz Shaw
        Level.CompleteMissionTask('KART', 15.0 );

     end;

     Level.EnableLevelMark( 'KAR1' , false );

 end

 function GetDocsTrigger_1:OnEnterArea( sender )

     if ( Level.Docs[1] != false ) then

       Level.UnregisterTrigger( self.Object );
       return;

     end;

     --Level.SeifTrigger = self;

     --if ( Level.SeifDoor != nil and Level.IsDoorOpened( Level.SeifDoor ) == false ) then
 
     --  return;

     --end;

     Level.AddPlayerAction("DOCS", MissionText.Message_Docs, self.ObjectName, false);
 end

 function GetDocsTrigger_1:OnLeaveArea( sender )
     Level.RemovePlayerAction("DOCS");
     --Level.SeifTrigger = nil;
 end