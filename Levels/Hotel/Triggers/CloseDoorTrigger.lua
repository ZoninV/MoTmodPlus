----------------------------------------------------------------------------
--
-- Description :  Refr trigger
--
-- Created by Sergey Gvzodev
--
----------------------------------------------------------------------------

 CloseDoorTrigger =
 {
 };

 function CloseDoorTrigger:OnPlayerAction()

     Level.RemovePlayerAction("CLDR");

     if (Level.RefrDoorBlocked == false and
         Level.CheckCanCloseDoor() != false) then

       local door = Level.FindDoor( 'RFDR' );

       if (door != nil) then
          local state = Level.GetDoorState(door);

          if (state != 0 and
              state != 1) then

             return;

          end

          if (Level.IsDoorOpened(door) != false) then
             Level.CloseDoor( door, true, Level.GetPlayer() );
          end
       end

       Level.RefrDoorBlocked = true;

       local npc = AI.FindNPC('BC06');

       local properties = Level.CreateCustomParams();
       Level.SetValue(properties, "CustomString_1", 'AN58');
       Level.SetValue(properties, "CustomString_2", 'AN59');

       NPC.SetFlag( npc, NPC.F_CANT_OPEN_DOOR, true );
       AI.RunScriptTask(npc, "scripts:job\\AnchorJob2.lua", AI.LOGIC_NEUTRAL, properties);

       AI.SetJob(AI.FindNPC('HW06'), "job_new");

     end
 end

          
 function CloseDoorTrigger:OnInit()
 end

 function CloseDoorTrigger:OnEnterArea( sender )

     Level.CloseDoorTrigger = self;

     Level.EnableLevelMark('REFR', false);

     if (Level.RefrDoorBlocked == false) then
        if (Level.HasPlayerAction("CLDR") == false and
            Level.CheckCanCloseDoor() != false) then

           Level.AddPlayerAction("CLDR", MissionText.Message_CloseDoor, self.ObjectName, false);

        end
     end

 end

 function CloseDoorTrigger:OnLeaveArea( sender )

    Level.CloseDoorTrigger   = nil;
    Level.AtCloseDoorTrigger = false;
    Level.RemovePlayerAction("CLDR");

 end

