----------------------------------------------------------------------------
--
-- Description :  Manager trigger
--
-- Created by Sergey Gvzodev
--
----------------------------------------------------------------------------

 ManagerTrigger =
 {
 };

 function ManagerTrigger:OnPlayerAction()
   local manager = AI.FindNPC('HM03');

   if (Level.IsPlayerHotelVisitor() == false) then
      if (AI.IsDefault(manager) != false) then
         -- Install script job...
         local properties = Level.CreateCustomParams();
         Level.SetValue(properties, "CustomString_1", 'AN19');
         AI.RunScriptTask(manager, "scripts:job\\AnchorJob.lua", AI.LOGIC_DEFAULT, properties);

         Level.EnableLevelMark('RGST', false);
         Level.RemovePlayerAction("VTHT");
         Level.RemoveTimer( 'HMTM' );
         Level.UsedRegistrateTrigger = true;
      end
   end
 end

        
 function ManagerTrigger:OnInit()
 end

 function ManagerTrigger:OnEnterArea( sender )
   local player  = Level.GetPlayer();
   local manager = AI.FindNPC('HM03');

   if (Level.UsedRegistrateTrigger != false) then
       return;
   end

   if (AI.GetPlayerForm() != "Civilian") then
       return;
   end;
                                      
   if (Level.IsPlayerHotelVisitor() == false) then
      if (AI.IsDefault(manager) != false) then
         Level.AddPlayerAction("VTHT", MissionText.Message_Registrate, self.ObjectName, false);
      end
   end

   Level.ManagerTriggerName = self.ObjectName;

   -- Install timer
   Level.AddTimer( 'HMTM', "OnHotelManagerTimer", 1, true );
 end

 function ManagerTrigger:OnLeaveArea( sender )
   Level.RemovePlayerAction("VTHT");
   Level.RemoveTimer( 'HMTM' );
   Level.ManagerTriggerName = "";
 end

