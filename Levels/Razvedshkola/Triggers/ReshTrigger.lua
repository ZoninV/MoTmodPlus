----------------------------------------------------------------------------
--
-- Description :  Fire alert trigger
--
-- Created by Sergey Gvozdev
--
----------------------------------------------------------------------------


 ReshTrigger =
 {
 };

 function ReshTrigger:OnInit()
 end

 function ReshTrigger:OnPlayerAction( id )
    if ( Level.IsMissionFailed() != false ) then
       return;
    end;

    if (id == 'RESH') then
       local npc = AI.FindNPC('GS99');
       if ( Level.TestReshTask() and 
            AI.IsDefault(npc) ) then

          Level.StartPlayerCustomAnim("Custom_PassticketShow", 0, true, true);
          Level.EnableLevelMark('RSH1', false);
          Level.EnableLevelMark('RSH2', false);
          Level.PlayMenuSound("task_finish"); -- Liz Shaw
          Level.CompleteMissionTask('RESH');

          local anchor = AI.FindAnchor( 'A156' );
          if (AI.IsUsingAnchor(npc, anchor) != false) then
             Level.DoAnchor2('GS99', 'A177', 'A179');
          else
             Level.DoAnchor('GS99', 'A179');
          end

          Level.RemovePlayerAction('RESH');
       end
    end
 end

 function ReshTrigger:OnEnterArea( sender )
     if ( Level.IsMissionFailed() != false ) then
        return;
     end;

     Level.ReshTriggerName = self.ObjectName;

     if ( Level.TestReshTask() and 
          AI.IsDefault(AI.FindNPC('GS99')) ) then
            
       Level.AddPlayerAction('RESH', MissionText.Message_ReportVisit, self.ObjectName, false);
     end
 end

 function ReshTrigger:OnLeaveArea( sender )
     Level.ReshTriggerName = "";
     Level.RemovePlayerAction('RESH');
 end
