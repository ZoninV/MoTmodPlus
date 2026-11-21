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

     if ( Level.IsMissionFailed() != false ) then
       return;
     end;

     Level.EnableExitTask( self.ScriptCommand );
     Level.PlayMenuSound("task_finish"); -- Liz Shaw
     Level.CompleteMissionTask( self.ScriptCommand, 15.0 );
     Level.EnableLevelMark( self.ScriptCommand, false );
     Level.RemoveTaskMarks();

     Level.RemovePlayerAction("DOCS");
     Level.UnregisterTrigger( self.Object );
     Level.SeifTrigger = nil;

     local door = nil;

     if ( self.ScriptCommand == 'SEF1' ) then 
         door = Level.SeifLabDoor;
     elseif ( self.ScriptCommand == 'SEF2' ) then
         door = Level.SeifKabDoor;
     end;

     if ( door != nil ) then
       Level.SetDoorNotifyScript( door , false );
     end;

     -- Documents now shown in inventory if there is space. AHO, 28.09.2008 (fixed UID & guards)
     local player = Level.GetPlayer();
     if (player != nil) then
        local docs = Level.CreateItem( "Custom", "Equipment" );
        if (docs != nil) then
           if ( self.ScriptCommand == 'SEF1' ) then
              Entity.SetUniqueID( docs, 'DOC1' );
           else
              Entity.SetUniqueID( docs, 'DOC2' );
           end;
           Level.SetCustomItemName( docs, MissionText.docs );
           Level.SetCustomItemIcon( docs, "ammo_doc" );
           local pouch = Actor.GetEmptyPouch(player);
           if (pouch != nil and pouch != -1) then
              Actor.PutPouch( player, pouch, docs );
           end;
        end;
     end;

 end

 function GetDocumentsTrigger:OnEnterArea( sender )

     if ( Level.IsMissionTaskCompleted( self.ScriptCommand ) == true ) then

         Level.UnregisterTrigger( self.Object );
         Level.SeifTrigger = nil;
         return;

     end;

     Level.SeifTrigger = self;

     local door = nil;

     if ( self.ScriptCommand == 'SEF1' ) then 
         door = Level.SeifLabDoor;
     elseif ( self.ScriptCommand == 'SEF2' ) then
         door = Level.SeifKabDoor;
     end;

     if ( door != nil and Level.IsDoorOpened( door ) == false ) then
       return;
     end;

     Level.AddPlayerAction("DOCS", MissionText.Message_Docs, self.ObjectName, false);
 end

 function GetDocumentsTrigger:OnLeaveArea( sender )
     Level.RemovePlayerAction("DOCS");
     Level.SeifTrigger = nil;
 end