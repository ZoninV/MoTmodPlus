----------------------------------------------------------------------------
-- Order Worker Trigger
-- MoTmod Addon
-- Liz Shaw
----------------------------------------------------------------------------


 OrderWorkerTrigger =
 {
 };

 function OrderWorkerTrigger:OnInit()
 end

 function OrderWorkerTrigger:OnPlayerAction( id )
    if ( Level.IsMissionFailed() != false ) then
       return;
    end;

    if (AI.GetPlayerForm() == "HMO1") and (Level.GetDifficulty() != 0) then
       local npc = AI.FindNPC('GS80');
       if ( AI.IsDefault(npc) ) then

          AI.HandleVoice(npc, "@v_military_yes");
          AI.SetJob(npc, "newjob");

          Level.UninstallOrderWorkerTask();
          Level.UnregisterTrigger( self.Object );

       end
    end
 end

 function OrderWorkerTrigger:OnEnterArea( sender )
     if ( Level.IsMissionFailed() != false ) then
        return;
     end;

     Level.OrderWorkerTriggerName = self.ObjectName;

     if ( (AI.GetPlayerForm() == "HMO1") and
          (Level.GetDifficulty() != 0) and
          AI.IsDefault(AI.FindNPC('GS80')) ) then
            
       Level.AddPlayerAction('ORDR', MissionText.Message_OrderWorker, self.ObjectName, false);
     end
 end

 function OrderWorkerTrigger:OnLeaveArea( sender )
     Level.OrderWorkerTriggerName = "";
     Level.RemovePlayerAction('ORDR');
 end
