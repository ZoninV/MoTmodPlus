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

     -- Files are now shown in inventory if there is space. AHO, 28.09.2008 (fixed UID & guards)
     local player = Level.GetPlayer();
     if (player != nil) then
        local files1 = Level.CreateItem( "Custom", "Equipment" );
        if (files1 != nil) then
           Entity.SetUniqueID( files1, 'FLS1' );
           Level.SetCustomItemName( files1, MissionText.files );
           Level.SetCustomItemIcon( files1, "ammo_doc" );
           local pouch = Actor.GetEmptyPouch(player);
           if (pouch != nil and pouch != -1) then
              Actor.PutPouch( player, pouch, files1 );
           end;
        end;
     end;

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