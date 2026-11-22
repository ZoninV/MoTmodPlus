----------------------------------------------------------------------------
--
-- Description :  Get documents trigger
--
-- Created by Alexey Agamalov
--
----------------------------------------------------------------------------

 GetDocumentsTrigger =
 {
 };
          
 function GetDocumentsTrigger:OnInit()
 end

 function GetDocumentsTrigger:OnPlayerAction()

     Level.RemovePlayerAction("DOCS");

     if (Level.DocsInSeif == false) then
       return;
     end

     if ( Level.IsMissionFailed() != false ) then
       return;
     end;

     local diplomat = AI.FindNPC( 'DPM1' );
     if (diplomat == nil) then
        return;
     end

     if (AI.KnowPlayerPosition(diplomat) != false) then
        return;
     end

     Level.UnregisterTrigger( self.Object );
     Level.SeifTrigger = nil;

     Level.DocsChanged = true;

     local door = Level.FindDoor( 'SFDR' );
     if ( door != nil ) then
       Level.SetDoorNotifyScript( door, false );
     end;

     if (Level.IsMissionTaskCompleted( 'KILL' ) ) then

         Level.SetupLeaveTask();

     end

     Level.PlayMenuSound("task_finish"); -- Liz Shaw
     Level.CompleteMissionTask('DOCS', 15.0 );
     Level.EnableLevelMark( 'DOCS', false );
     Level.EnableLevelMark( 'DISH', false );
     local dpmActor = Level.FindActor( 'DPM1' );
     if (dpmActor != nil) then
        Actor.SetMarkAsFriend( dpmActor, true );
     end;

     -- Player now takes the real documents into his inventory. AHO, 28.09.2008 (fixed UID & guards)
     local player = Level.GetPlayer();
     if (player != nil) then
        local real_docs = Level.CreateItem( "Custom", "Equipment" );
        if (real_docs != nil) then
           Entity.SetUniqueID( real_docs, 'RDOC' );
           Level.SetCustomItemName( real_docs, MissionText.real_docs );
           Level.SetCustomItemIcon( real_docs, "ammo_doc" );
           local pouch = Actor.GetEmptyPouch(player);
           if (pouch != nil and pouch != -1) then
              Actor.PutPouch( player, pouch, real_docs );
           end;
        end;
     end;

     Level.AutoSave();
 end

 function GetDocumentsTrigger:OnEnterArea( sender )

     if ( Level.DocsChanged != false ) then
       Level.UnregisterTrigger( self.Object );
       Level.SeifTrigger = nil;
       return;
     end;

     Level.SeifTrigger = self;

     if (Level.DocsInSeif == false) then

        return;

     end

     local seifDoor = Level.FindDoor( 'SFDR' );
     if ( seifDoor != nil and Level.IsDoorOpened( seifDoor ) == false ) then
 
       return;

     end;

     local diplomat = AI.FindNPC( 'DPM1' );
     if (diplomat == nil) then
        return;
     end

     if (AI.KnowPlayerPosition(diplomat) == false) then

        Level.AddPlayerAction("DOCS", MissionText.Message_ChangeDocs, self.ObjectName, false);

     end

 end

 function GetDocumentsTrigger:OnLeaveArea( sender )

     Level.RemovePlayerAction("DOCS");
     Level.SeifTrigger = nil;

 end