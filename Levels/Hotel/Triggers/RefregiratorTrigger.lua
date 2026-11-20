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
      -- Short help text when entering the cold room. AHO, 24.09.2008    
      if (Level.RefregTipShown != true) then
         Level.RefregTipShown = true;
         Level.AddSmallMessage( "!&" .. MissionText.Tip_Refreg, 10.0, 255, 255, 255 );
      end;
      --
 end

 function RefregiratorTrigger:OnLeaveArea( sender )
      Level.RemoveTimer( 'RFTG' );
 end