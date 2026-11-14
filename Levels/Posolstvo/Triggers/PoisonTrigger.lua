----------------------------------------------------------------------------
--
-- Description :  Poison trigger
--
-- Created by Sergey Gvozdev
--
----------------------------------------------------------------------------

 PoisonTrigger =
 {
 };

 function PoisonTrigger:OnInit()
 end

 function PoisonTrigger:OnPlayerAction( id )
    if (id == self.ScriptCommand) then

       if ( Actor.HasCustomEquipment( Level.GetPlayer(), 'POIS' ) == false ) then
          Level.AddSmallMessage( MissionText.Poison_Need, 8.0, 255, 255, 255 );
          return false;        
       end

       Level.PoisonCup = self.ScriptCommand;

       local normal = {};
       local pos = {};
             
       normal.x,normal.y,normal.z = Trigger.GetNormal( self.Object );
       pos.x,pos.y,pos.z          = Trigger.GetPosition( self.Object );

       Actor.BlendTransform( Level.GetPlayer(), pos.x, pos.y, pos.z, normal.x, normal.y, normal.z, 3.0);

       Level.StartPlayerCustomAnim("Custom_UsePoison", 0, true, true, 'POIS');

       AI.StartDecamouflage( 50.0, 100.0, 4.0 );
       Level.RemovePlayerAction(self.ScriptCommand);

       Level.EnableLevelMark( 'COFF', false );
    end
 end

 function PoisonTrigger:OnEnterArea( sender )

     local player = Level.GetPlayer();
     if ( player == nil ) then
         return;
     end;
      
     --print("Enter");
     if (Level.PoisonCup == '' and
         Level.CanPoison != false) then
        Level.AddPlayerAction(self.ScriptCommand, MissionText.Message_Poison, self.ObjectName, false);
     end

--     Level.EnableLevelMark( 'COFF', false );
 end

 function PoisonTrigger:OnLeaveArea( sender )
     Level.RemovePlayerAction(self.ScriptCommand);
 end