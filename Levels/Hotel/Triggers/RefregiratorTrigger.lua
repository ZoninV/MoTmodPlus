----------------------------------------------------------------------------
--
-- Description :  Refr trigger
--
-- Created by Sergey Gvzodev
--
----------------------------------------------------------------------------

 RefregiratorTrigger =
 {
 };

 function RefregiratorTrigger:OnInit()
 end

 function RefregiratorTrigger:OnEnterArea( sender )
      Level.AddTimer( 'RFTG', "OnRefregTriggerTimer", 4, true );
      -- AHO, Kleiner Hilfstext beim Betreten des Kühlraums. AHO, 24.09.2008    
      Level.AddSmallMessage(MissionText.Tip_Refreg,10.0,255,255,255);
      --
 end

 function RefregiratorTrigger:OnLeaveArea( sender )
      Level.RemoveTimer( 'RFTG' );
 end