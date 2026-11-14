----------------------------------------------------------------------------
--
-- Description :  Message library trigger
--
-- Created by Sergey Gvzodev
--
----------------------------------------------------------------------------

 MessageLibrTrigger =
 {
 };

 function MessageLibrTrigger:OnInit()
 end

 function MessageLibrTrigger:OnEnterArea( sender )

      if (Level.BlockLbrMessage != false) then
         return;
      end

      if (Level.IsPlayerAtLibrary() == false) then
         return;
      end

      if (Level.IsMissionTaskCompleted( 'FNDS' ) != false) then
         return;
      end

      if (Level.DocsDiplomat == false and
          Level.DocsInSeif == false) then

        local gad = AI.FindNPC('GAD1');

        if (gad == nil) then
            return;
        end


        if (AI.IsDefault(gad) == false and
            AI.IsScriptTask(gad) == false) then
           return ;
        end

        local diplomat = AI.FindNPC( 'DPM1' );
        if (diplomat != nil) then
           if (AI.GetRoom(diplomat) == Level.GetRoom('LIBR')) then

              Level.BlockLbrMessage = true;
              Level.AddTimer( 'LBSM', "OnLibrarySmallMessage", 15, false );

              Level.AddSmallMessage( MissionText.Message_CheckDiplomatDocs, 15.0, 255, 255, 255 ); -- AHO, 16.09.2008  
              return;

           end
        end

      end

 end

 function MessageLibrTrigger:OnLeaveArea( sender )

 end
