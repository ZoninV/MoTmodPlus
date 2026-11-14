----------------------------------------------------------------------------
--
-- Description :  Show document trigger
--
-- Created by Sergey Gvozdev
--
----------------------------------------------------------------------------

 ShowDocumentTrigger =
 {
 };

 function ShowDocumentTrigger:OnInit()
 end

 function ShowDocumentTrigger:OnPlayerAction( id )
     if (id == 'SHEN') then
        local officer = AI.FindNPC('GO01');

        if (AI.IsDefault(officer)) then

           if (Level.AtCameraTrigger == false) then
              local properties = Level.CreateCustomParams();
              Level.SetValue(properties, "CustomString_1", 'AN16');
              AI.RunScriptTask(officer, "scripts:job\\AnchorJob.lua", AI.LOGIC_DEFAULT, properties);
              Level.InstallDpc("AI.HandleVoice( AI.FindNPC('GO01'), 'male_ger_script_script_18');", 7.5);
              Level.InstallDpc("Level.AddSmallMessage( MissionText.MM_StopMove_DocsClearYLLW, 5.0, 175, 175, 175 )", 7.5);
              Level.InstallDpc("Level.AddKey('PLYR', 'KEY1', MissionText.Message_Key)", 7.5);
              Level.InstallDpc("Level.AddSmallMessage( MissionText.Message_KeyReceived, 15.0, 255, 255, 255 )", 7.6);
           else
              local properties = Level.CreateCustomParams();
              Level.SetValue(properties, "CustomString_1", 'AN95');
              AI.RunScriptTask(officer, "scripts:job\\AnchorJob.lua", AI.LOGIC_DEFAULT, properties);
              Level.InstallDpc("AI.HandleVoice( AI.FindNPC('GO01'), 'male_ger_script_script_18');", 5.0);
              Level.InstallDpc("Level.AddSmallMessage( MissionText.MM_StopMove_DocsClearYLLW, 5.0, 175, 175, 175 )", 5.0);
              Level.InstallDpc("Level.AddKey('PLYR', 'KEY1', MissionText.Message_Key)", 5.0);
              Level.InstallDpc("Level.AddSmallMessage( MissionText.Message_KeyReceived, 15.0, 255, 255, 255 )", 5.1);
           end

           AI.EnableZone("CellBlockA_Near", false);
           AI.EnableZone("CellBlockA_NoPass", false);
           Level.StartPlayerCustomAnim("Custom_PassticketShow", 0, true, true);
           Actor.RemoveCustomEquipment( Level.GetPlayer(), 'ADOC' ); 
           Level.EnterDocumentShowed = true;                          
                               
           Level.RemovePlayerAction('SHEN');
           return;
        end
     elseif (id == 'SHEX') then
        local officer = AI.FindNPC('GO01');

        if (AI.IsDefault(officer) and
            AI.IsDefault(AI.FindNPC('GSPY')) and
             (AI.IsDefault(AI.FindNPC('GRD1')) or AI.IsUtilTask(AI.FindNPC('GRD1')) or AI.IsImportantTask(AI.FindNPC('GRD1'))) and
             (AI.IsDefault(AI.FindNPC('GRD2')) or AI.IsUtilTask(AI.FindNPC('GRD2')) or AI.IsImportantTask(AI.FindNPC('GRD2')))) then


           if (Level.AtCameraTrigger == false) then
              local properties = Level.CreateCustomParams();
              Level.SetValue(properties, "CustomString_1", 'AN16');
              Level.SetValue(properties, "CustomString_2", 'AN18');
              AI.RunScriptTask(officer, "scripts:job\\AnchorJob2.lua", AI.LOGIC_DEFAULT, properties);
              Level.InstallDpc("Level.CompleteTaskFind()", 7.5);
              Level.InstallDpc("Level.AddLargeMessage( MissionText.Message_MoveSpy, 15.0, 255, 255, 255 )", 7.6);
           else
              local properties = Level.CreateCustomParams();
              Level.SetValue(properties, "CustomString_1", 'AN93');
              Level.SetValue(properties, "CustomString_2", 'AN18');
              AI.RunScriptTask(officer, "scripts:job\\AnchorJob2.lua", AI.LOGIC_DEFAULT, properties);
              Level.InstallDpc("Level.CompleteTaskFind()", 5.0);
              Level.InstallDpc("Level.AddLargeMessage( MissionText.Message_MoveSpy, 15.0, 255, 255, 255 )", 5.1);
           end

           AI.EnableZone("CellBlockA_Near", false);
           Level.StartPlayerCustomAnim("Custom_PassticketShow", 0, true, true);
           Actor.RemoveCustomEquipment( Level.GetPlayer(), 'DDOC' ); 
           Level.ExtraditionDocumentShowed = true;
           Level.EnableLevelMark('DEST', true );

           Level.RemovePlayerAction('SHEX');
           Level.RemovePlayerAction('SHEN');
           return;
        end
     end
 end

 function ShowDocumentTrigger:OnEnterArea( sender )

     local player = Level.GetPlayer();
     if ( player == nil ) then
         return;
     end;
      
     if (AI.GetPlayerForm() != "YLLW") then
         return;
     end;

     --print("Enter");

     if ((Level.HasAccessDocs() == true) and 
         (Level.EnterDocumentShowed == false) and
         (Level.ExtraditionDocumentShowed == false)) then

         --print("CheckSHEN");

         if (AI.IsDefault(AI.FindNPC('GO01'))) then
            --print("AddSHEN");

            Level.AddPlayerAction('SHEN', MissionText.Message_ShowEnterDocument, self.ObjectName, false);
         end
     end

     if ((Level.HasInterrogationDocs() == true) and
         (Level.ExtraditionDocumentShowed == false)) then

         --print("CheckSHEX");

         if (AI.IsDefault(AI.FindNPC('GO01')) and
             AI.IsDefault(AI.FindNPC('GSPY')) and
             (AI.IsDefault(AI.FindNPC('GRD1')) or AI.IsUtilTask(AI.FindNPC('GRD1')) or AI.IsImportantTask(AI.FindNPC('GRD1'))) and
             (AI.IsDefault(AI.FindNPC('GRD2')) or AI.IsUtilTask(AI.FindNPC('GRD2')) or AI.IsImportantTask(AI.FindNPC('GRD2')))) then

            --print("AddSHEX");
            Level.AddPlayerAction('SHEX', MissionText.Message_ShowExtraditionDocument, self.ObjectName, false);
         end
     end
 end

 function ShowDocumentTrigger:OnLeaveArea( sender )
     Level.RemovePlayerAction('SHEX');
     Level.RemovePlayerAction('SHEN');
 end