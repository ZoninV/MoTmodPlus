
  MissionText = 
  {
      --Mission text
      Task_1             = " Уничтожить А. Мадера";
      Task_2             = " Уничтожить В. Бартелса";
      Task_3             = " Уничтожить Г. Кнута";
      Task_4             = " Покинуть деревню";

      KeySklad_Name      = "Ключ от комнат на первом этаже";

      Message_1          = "Цели изменились";
      Message_2          = "Поднята тревога. Число патрулей увеличено.";
      Message_3          = "Поднята тревога. Охрана стала внимательней.";
      Message_4          = "Охрана успокоилась.";

      Message_Station    = "ЗАМКНУТЬ РАЦИЮ";
      Message_Poison     = "ОТРАВИТЬ";

      Fail_Alarm         = "Поднята тревога";

      Poison_Need        = "! Нужен яд, чтобы отравить.";

	  -- Wunder
      Intro              = "Деревня Юратишки, Белоруссия, 1944 г.";
      Tipp_Poison        = "Бартелс любит выпить. Воспользуйтесь этим!";
      poison             = "Яд";

      -- Liz Shaw
      MM_StopMove_CIV       = "@ Гражданским лицам вход в здание воспрещен.";
      MM_StopMove_Bartels   = "@ Вам не разрешено входить в эту комнату.";
      MM_StopMove_Knut      = "@ Мне приказано пропускать внутрь только офицеров.";
      MM_StopMove_NoEntry   = "@ Мне приказано никого не пускать внутрь.";
      MM_StopMove_GetOut    = "@ Убирайтесь отсюда!";
      MM_StopMove_OFF       = "@ Что вы здесь делаете? Это моя комната!";
      MM_StopMove_LeaveRoom = "@ Немедленно покиньте эту комнату!";
      MM_StopMove_Vodila    = "@ В эту комнату могут входить только водители.";
      MM_StopMove_Radist    = "@ В эту комнату разрешен вход только радистам.";
  };

  function Level.OnCompleteMission()

      System:ConsoleCommand( 'l_loadlevel "rolik_lubyanka" 9' );

  end;

  function Level.OnFinishLoad()

     Level.AddLargeMessage(MissionText.Intro , 10.0, 180, 180, 180 ); -- Wunder

     -- forlik System:SetVar( "r_glow", true );
     -- forlik System:SetVar( "r_glow_r", 2.0 );
     System:SetVar("r_farclip" , 8192 ); -- Wunder
     Level.OnFinishLoad_Common(); -- forlik
     Level.SetDOFPostFilter( 1, 0.0, 1600.0, 3500.0 ); --forlik
     System:SetVar( "r_dofsky", 128 ); --forlik

     Level.AddMusic( Level.MUSIC_MOOD_DEFAULT  , "#0.50#sounds\\music\\ambiento.ogg" );
     Level.AddMusic( Level.MUSIC_MOOD_ATTENTION   , "#0.50#sounds\\music\\action_2.ogg");
     Level.AddMusic( Level.MUSIC_MOOD_ACTION, "#0.50#sounds\\music\\b_action2.ogg" );

     -- patch
     local backpack = Level.FindContainer();
     if (backpack != nil) then
         Level.EnableItemPickup(backpack, true);
     end

      -- Liz Shaw

      Level.SetDoorKey('SKDR', 'SKKY');
      Level.SetDoorKey('SKD2', 'SKKY');

      Entity.SetSkin(Level.FindVehicle('BMW1'), 5);
      Entity.SetSkin(Level.FindVehicle('BL01'), 8);
      Entity.SetSkin(Level.FindVehicle('BL02'), 9);
      Entity.SetSkin(Level.FindVehicle('BL03'), 10);
      Entity.SetSkin(Level.FindVehicle('MER1'), 2);
      Entity.SetSkin(Level.FindVehicle('MER2'), 2);
  end;

  function Level.OnLoad()

     Level.GuardDoorOpened      = false;

     Level.NumKilled            = Stream.ReadInt();
     Level.RadioBroken          = Stream.ReadBool();
     Level.ShnapsPoisoned       = Stream.ReadBool();
     Level.ShnapsPoisonedGet    = Stream.ReadBool();
     Level.ShnapsPoisonedActive = Stream.ReadBool();
     Level.GuardDoorOpened      = Stream.ReadBool();

     Level.AlertBlock = {};

     Level.AlertBlock[1]        = Stream.ReadBool();
     Level.AlertBlock[3]        = Stream.ReadBool();

     Level.OnLoad_Common(); -- forlik
     Level.AutoSaveSlot = Stream.ReadInt();
     if (Level.AutoSaveSlot == nil or Level.AutoSaveSlot < 0 or Level.AutoSaveSlot > 2) then
        Level.AutoSaveSlot = 0;
     end;
     Level.OnFinishLoad();

  end;

  function Level.AutoSave()

     if (Level.IsMissionFailed() != false) then
        return;
     end;

     local nextSlot = 0;
     if (Level.AutoSaveSlot != nil) then
        nextSlot = Level.AutoSaveSlot + 1;
        if (nextSlot > 2) then
           nextSlot = 0;
        end;
     end;

     Level.PendingAutoSaveSlot = nextSlot;
     System:SaveGame( "_rasplata_" .. tostring(nextSlot) .. ".asv" , false );
     if (Level.PendingAutoSaveSlot != nil) then
        Level.PendingAutoSaveSlot = nil;
        Level.InstallSingleDpc("Level.AutoSave()", 1.0);
     end;

  end;

  function Level.OnFailedMissionHandle()

     local slot = Level.AutoSaveSlot;
     if (slot == nil or slot < 0 or slot > 2) then
        slot = 0;
     end;

     System:LoadGame( "_rasplata_" .. tostring(slot) .. ".asv" , true );

     return true;

  end;

  function Level.OnSave()

     Stream.WriteInt( Level.NumKilled );
     Stream.WriteBool( Level.RadioBroken );
     Stream.WriteBool( Level.ShnapsPoisoned );
     Stream.WriteBool( Level.ShnapsPoisonedGet );
     Stream.WriteBool( Level.ShnapsPoisonedActive );
     Stream.WriteBool( Level.GuardDoorOpened );

     Stream.WriteBool( Level.AlertBlock[1] );
     Stream.WriteBool( Level.AlertBlock[3] );
     Level.OnSave_Common(); -- forlik
     if (Level.PendingAutoSaveSlot != nil) then
        Level.AutoSaveSlot = Level.PendingAutoSaveSlot;
        Level.PendingAutoSaveSlot = nil;
     end;
     if (Level.AutoSaveSlot == nil) then
        Stream.WriteInt( 0 );
     else
        Stream.WriteInt( Level.AutoSaveSlot );
     end;

  end;

  function Level.OnLoaded()

      Level.OnLoaded_Common(); -- forlik
      -- init tasks

      Level.AddMissionTask( MissionText.Task_1, 'LIQ1', "levels\\rasplata\\liq1_task.txt" );
      Level.AddMissionTask( MissionText.Task_2, 'LIQ2', "levels\\rasplata\\liq2_task.txt" );
      Level.AddMissionTask( MissionText.Task_3, 'LIQ3', "levels\\rasplata\\liq3_task.txt" );

      Level.EnableLevelMark( 'LEAV', false );

      Level.AddActionHandler( Level.AH_ACTOR_KILLED , "LIQ1" , "OnKilledLIQ1");
      Level.AddActionHandler( Level.AH_ACTOR_KILLED , "LIQ2" , "OnKilledLIQ2");
      Level.AddActionHandler( Level.AH_ACTOR_KILLED , "LIQ3" , "OnKilledLIQ3");

      Level.AddActionHandler( Level.AH_ENTER_VEHICLE , "BMW1" , "OnBikeEnter");

      Level.AddActionHandler( Level.AH_LEAVE_VEHICLE, 'MER2', "OnLeaveMercedes" );
      Level.AddActionHandler( Level.AH_ENTER_VEHICLE, 'MER2', "OnEnterMercedes" );

      Level.AddActionHandler( Level.AH_FINISH_CHANGECLOTH , "SOL1" , "OnCamoSoldierClothChange");
      Level.AddActionHandler( Level.AH_FINISH_CHANGECLOTH , "SOL2" , "OnCamoSoldierClothChange");
      Level.AddActionHandler( Level.AH_FINISH_CHANGECLOTH , "SOL3" , "OnSoldierClothChange");
      Level.AddActionHandler( Level.AH_FINISH_CHANGECLOTH , "SOL4" , "OnSoldierClothChange");
      Level.AddActionHandler( Level.AH_FINISH_CHANGECLOTH , "UNT1" , "OnUnteroffizierClothChange");
      Level.AddActionHandler( Level.AH_FINISH_CHANGECLOTH , "RAD1" , "OnRadistClothChange");

      Level.AddActionHandler( Level.AH_ACTOR_KILLED , "GS71" , "OnKilledVodila");
      Level.AddActionHandler( Level.AH_ACTOR_HITTED , "GS71" , "OnKilledVodila");
      Level.AddActionHandler( Level.AH_ACTOR_KILLED , "G118" , "OnKilledVodila");
      Level.AddActionHandler( Level.AH_ACTOR_HITTED , "G118" , "OnKilledVodila");
      Level.AddActionHandler( Level.AH_ACTOR_KILLED , "GS58" , "OnKilledVodila");
      Level.AddActionHandler( Level.AH_ACTOR_HITTED , "GS58" , "OnKilledVodila");
      Level.AddActionHandler( Level.AH_ACTOR_KILLED , "GS86" , "OnKilledVodila");
      Level.AddActionHandler( Level.AH_ACTOR_HITTED , "GS86" , "OnKilledVodila");
      Level.AddActionHandler( Level.AH_ACTOR_KILLED , "GS97" , "OnKilledVodila");
      Level.AddActionHandler( Level.AH_ACTOR_HITTED , "GS97" , "OnKilledVodila");

      -- patch
      Level.AddActionHandler( Level.AH_ACTOR_KILLED , "GO08" , "OnKilledMarkedOfficer");
      Level.AddActionHandler( Level.AH_ACTOR_HITTED , "GO08" , "OnKilledMarkedOfficer");

      Actor.MarkAsTarget( Level.FindActor( 'LIQ1' ) , true );
      Actor.MarkAsTarget( Level.FindActor( 'LIQ2' ) , true );
      Actor.MarkAsTarget( Level.FindActor( 'LIQ3' ) , true );

      NPC.SetFlag( AI.FindNPC('RB31'), NPC.F_CANT_OPEN_LOCK_DOOR, true );
      -- init params
      
      Level.NumKilled            = 0;
      Level.RadioBroken          = false;
      Level.ShnapsPoisoned       = false;
      Level.ShnapsPoisonedGet    = false;
      Level.ShnapsPoisonedActive = false;
      Level.GuardDoorOpened      = false;

      Level.AlertBlock = {};

      Level.AlertBlock[1] = false;
      Level.AlertBlock[3] = false;

      Level.EnableLevelMark('POIS', true);

      if (Level.GetDifficulty() != 3) then
        Level.EnableLevelMark('RAD1', true);
      end;

      local diff = Level.GetDifficulty();
      if (diff == 3) then

          Level.InstallDpc( "AI.SetJob( AI.FindNPC('G131'), 'job_new')", 5.5 );
          Level.InstallDpc( "Level.RunAnchorJob( AI.FindNPC('G131'), 'MM03', true )", 6.0 );
      end;

      -- init player

      local player     = Level.FindActor('PLYR');
      if ( player != nil ) then

       Actor.ChangeActorSkin( player, "Summer" ); -- forlik

       if ( Level.HasPlayerEquipPack() == false ) then
 
         local machineGun = Level.CreateItem("ppsh","Weapon");
         local pistol     = Level.CreateItem("nagansilencer","Weapon");
         local knife      = Level.CreateItem("knife","Weapon");

         Actor.PutWeapon( player, Actor.WEAPON_SLOT_MACHINEGUN, machineGun );
         Actor.PutWeapon( player, Actor.WEAPON_SLOT_PISTOL    , pistol );
         Actor.PutWeapon( player, Actor.WEAPON_SLOT_KNIFE     , knife );

         Actor.PutEmptyPouch( player, "binocular", "Equipment" );

         local pack = Level.CreateItem( "playersack", "container" );
         if ( pack == nil ) 
           then
             error('Failed create player pack');
         end;

         Actor.PutBackPack( player, pack );

         ItemPack.AddItem( pack, Level.CreateItem( "pmd6", "Weapon" ) );
         ItemPack.AddItem( pack, Level.CreateItem( "pmd6", "Weapon" ) );
         ItemPack.AddItem( pack, Level.CreateItem( "knife", "Weapon" ) );

         Actor.PutEmptyPouch( player, "f1", "Weapon" );
         Actor.PutEmptyPouch( player, "f1", "Weapon" );
         Actor.PutEmptyPouch( player, "f1", "Weapon" );

         Actor.PutEmptyPouch( player, "smoke", "Weapon" );
         Actor.PutEmptyPouch( player, "smoke", "Weapon" );
         Actor.PutEmptyPouch( player, "smoke", "Weapon" );

         Actor.PutEmptyPouch( player, "fiberwire", "Weapon" );

         Actor.PutWeaponAmmo( player, "ppsh");
         Actor.PutWeaponAmmo( player, "nagan");

         Actor.PutEmptyPouch( player, "lockpick", "Equipment" );
         Actor.PutEmptyPouch( player, "medikit", "Equipment" );
       end;

      Level.ChangePlayerStand( 2 );

      end;

      Level.EnableNotifyPickup( Level.FindItem('POIS'), true );

       -- Keys
       
       Level.AddKey('MMDF', 'SKKY', MissionText.KeySklad_Name, nil, true );
       Level.AddKey('GS49', 'SKKY', MissionText.KeySklad_Name, nil, true );
       Level.AddKey('GS50', 'SKKY', MissionText.KeySklad_Name, nil, true );
       Level.AddKey('GS56', 'SKKY', MissionText.KeySklad_Name, nil, true );
       Level.AddKey('GS55', 'SKKY', MissionText.KeySklad_Name, nil, true );

     AI.OnPlayerEnterZone("global", 'GLSC'); -- forlik

     AI.EnableZone("mmZoneM1", false); -- Liz Shaw
     Level.OnFinishLoad();
     Level.AutoSave();

      -- demo stuff..

      --Level.AddLargeMessage( MissionText.Message_Demo_1, 20.0 , 255, 255, 255 );
      --Level.AddLargeMessage( MissionText.Message_Demo_2, 20.0 , 255, 255, 255 );

  end;

  AI.DoFile( "scripts:Levels\\Common.lua", false ); -- forlik

  -- patch
  function Level.OnKilledMarkedOfficer()
      if (AI.FindNPC('GO08') == nil) then 
         Level.EnableLevelMark( 'MAK4' , false );
      end
  end 

  function Level.OnKilledActor( actorId, markId )

     if ( Level.IsMissionFailed() != false ) then
       return;
     end;

     if ( Level.IsMissionTaskCompleted( actorId ) == false ) then

        Level.NumKilled = Level.NumKilled + 1;

        if ( Level.NumKilled == 3 ) then

         Level.EnableLevelMark( 'MAK4', false );
         Level.EnableLevelMark( 'LEAV', true );

         Level.AddMissionTask( MissionText.Task_4, 'LEAV', "levels\\rasplata\\leave_task.txt" );

        end;

        if ( markId != nil ) then
           Level.EnableLevelMark( markId, false );
        end

        Level.PlayMenuSound("task_finish"); -- Liz Shaw
        Level.CompleteMissionTask( actorId , 15.0 ); 

        if ( Level.NumKilled == 3 ) then

         Level.AddLargeMessage( MissionText.Message_1 , 15.0 , 255, 255, 255 );

        end;

        Level.AutoSave();

     end

  end;

  function Level.OnKilledLIQ1()

     Actor.MarkAsTarget( Level.FindActor( 'G112' ) , false );
     Actor.MarkAsTarget( Level.FindActor( 'GS55' ) , false );
     Actor.MarkAsTarget( Level.FindActor( 'GS66' ) , false );
     Actor.MarkAsTarget( Level.FindActor( 'GS80' ) , false );
     Level.EnableLevelMark( 'MAK6', false );
     Level.OnKilledActor( 'LIQ1', 'MAK3' );

  end;

  function Level.OnKilledLIQ2()

     Level.EnableLevelMark( 'MAK7', false );
     Level.OnKilledActor( 'LIQ2', 'MAK2' );

  end;

  function Level.OnKilledLIQ3()

     Level.OnKilledActor( 'LIQ3', 'MAK1' );

  end;
 
  function Level.OnEnterTriggerArea( sender, trgname, trgcmd )

    if ( Level.IsMissionFailed() != false ) then
       return;
     end;

    if ( trgname == 'MarkTrigger' ) then

      Level.EnableLevelMark( 'MAK4', false );
     
    elseif ( trgname == 'LeaveTrigger' ) then

      if ( Level.NumKilled == 3 ) then

        Level.PlayMenuSound("task_finish"); -- Liz Shaw
        Level.CompleteMissionTask( 'LEAV' , 15.0 );          

      end;

    elseif ( trgname == 'CheckVodilaTrigger' ) then
        
      Level.InstallSingleSmartDpc( "Level.OnGuardOpenDoor()", 1.0, "Level.CanGuardOpenDoor()");

    end;

  end;

  function Level.OnLeaveTriggerArea( sender, trgname, trgcmd )

  end;



  function Level.OnFinishAlert( alertGroupId )

     AI.Debug(nil, "Level::OnFinishAlert", "group", alertGroupId);
     AI.SetLocalAlert( alertGroupId, false );

     if (AI.IsLocalAlert(1) == false and
         AI.IsLocalAlert(2) == false and
         AI.IsLocalAlert(3) == false and
         AI.IsLocalAlert(4) == false and
         AI.IsLocalAlert(5) == false and
         AI.IsLocalAlert(6) == false and
         AI.IsLocalAlert(8) == false) then

            Level.AddSmallMessage( MissionText.Message_4, 10.0, 255, 255, 0);
     end

  end


  function Level.OnAlert( alertGroupId )

     if (alertGroupId == 1) then
       AI.Debug(nil, "Level.OnAlert", "group", alertGroupId);

       AI.SetLocalAlert(1, true, AI.TransformAlertTime(300.0));
       AI.SetLocalAlert(2, true, AI.TransformAlertTime(400.0));
                     
       AI.SetAttention(AI.AI_TARGET_ALERT_GROUP, "2", AI.ATTENTION_ALARM, true);

       if (Level.AlertBlock[1] == false) then

         AI.Patrol(AI.FindNPC('A1P1'), 'Path_A1_01', nil);
         AI.Patrol(AI.FindNPC('A1P2'), 'Path_A1_02', nil);
         AI.Patrol(AI.FindNPC('A1P3'), 'Path_A1_03', nil);
         AI.Patrol(AI.FindNPC('A1P4'), 'Path_A1_04', nil);

         Level.AlertBlock[1] = true;
       end

       if (Level.AlertBlock[1] == true) then
         AI.SetForm(AI.FindNPC('A1P1'), "SOL1");
         AI.SetForm(AI.FindNPC('A1P2'), "SOL1");
         AI.SetForm(AI.FindNPC('A1P3'), "SOL1");
         AI.SetForm(AI.FindNPC('A1P4'), "SOL1");
         AI.SetForm(AI.FindNPC('A1P5'), "SOL1");
         AI.SetForm(AI.FindNPC('GS38'), "SOL1");
       end

       Level.AddSmallMessage( MissionText.Message_2, 10.0, 255, 0, 0);
       AI.AddAlertValue(1);

     elseif ( (alertGroupId == 3) or 
              (alertGroupId == 4) or 
              (alertGroupId == 5) )  then
       AI.Debug(nil, "Level.OnAlert", "group", alertGroupId);

       AI.SetLocalAlert(3, true, AI.TransformAlertTime(300.0));
       AI.SetLocalAlert(4, true, AI.TransformAlertTime(300.0));
       AI.SetLocalAlert(5, true, AI.TransformAlertTime(300.0));

       AI.SetAttention(AI.AI_TARGET_ALERT_GROUP, "5", AI.ATTENTION_ALARM, true);

       if (Level.AlertBlock[3] == false) then
         AI.Patrol(AI.FindNPC('A5P1'), 'Path_A5_01', nil);
         AI.PatrolFollow(AI.FindNPC('A5P2'), 'Path_A5_01', AI.FindNPC('A5P1'), -5.0, -10.0, nil);

         Level.AlertBlock[3] = true;
       end

       Level.AddSmallMessage( MissionText.Message_3, 10.0, 255, 0, 0);
       AI.AddAlertValue(1);

     elseif (alertGroupId == 6) then
       AI.Debug(nil, "Level.OnAlert", "group", alertGroupId);

       AI.SetLocalAlert(6, true, AI.TransformAlertTime(250.0));
       AI.SetAttention(AI.AI_TARGET_ALERT_GROUP, "6", AI.ATTENTION_ALARM, true);

       AI.SetJob(AI.FindNPC('G102'), "alert");
       AI.SetJob(AI.FindNPC('G103'), "alert");

       Level.AddSmallMessage( MissionText.Message_3, 10.0, 255, 0, 0);
       AI.AddAlertValue(1);

     elseif (alertGroupId == 8) then
       AI.Debug(nil, "Level.OnAlert", "group", alertGroupId);

       AI.SetLocalAlert(8, true, AI.TransformAlertTime(250.0));
       AI.SetAttention(AI.AI_TARGET_ALERT_GROUP, "8", AI.ATTENTION_ALARM, true);

       Level.AddSmallMessage( MissionText.Message_3, 10.0, 255, 0, 0);
       AI.AddAlertValue(1);
     end;

  end;

--------------------------------------------------------
-- Level.OnStopMove()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.OnStopMove(actorId, npc)
  if (npc == nil) then
    print("MoTmod.ERROR: Jagdpanther.OnStopMove() npc is null " .. tostring(actorId));
    return;
  end

  local npcForm = AI.GetForm(npc);
  local zone = AI.GetPrimaryPlayerZone(npc);
  local playerForm = AI.GetPlayerForm();

  if (zone == nil) then 
    return;
  end

  if (zone == "mmZoneB1" or
      zone == "mmZoneC1") then
    if (playerForm == "CIV1") then
      Level.AddSmallMessage(MissionText.MM_StopMove_CIV, 5.0, 175, 175, 175);
      AI.HandleVoice(npc, "male_ger_stopmove_stopmove_06");
    else
      Level.AddSmallMessage(MissionText.MM_StopMove_Knut, 5.0, 175, 175, 175);
      AI.HandleVoice(npc, "male_ger_stopmove_stopmove_20");
    end
  elseif (zone == "mmZoneA1" or
          zone == "mmZoneD3") then
    Level.AddSmallMessage(MissionText.MM_StopMove_Bartels, 5.0, 175, 175, 175);
    AI.HandleVoice(npc, "male_ger_stopmove_stopmove_17");
  elseif (zone == "mmZoneD4") then
    if (npcForm == "UNT2" or
        npcForm == "RAD2") then
      Level.AddSmallMessage(MissionText.MM_StopMove_LeaveRoom, 5.0, 175, 175, 175);
      AI.HandleVoice(npc, "male_ger_stopmove_stopmove_05");
    elseif (npcForm == "OFF1" or
            npcForm == "STAN") then
      Level.AddSmallMessage(MissionText.MM_StopMove_OFF, 5.0, 175, 175, 175);
      AI.HandleVoice(npc, "male_ger_stopmove_stopmove_14");
    end
  elseif (zone == "mmZoneD1" or
          zone == "mmZoneD2") then
    Level.AddSmallMessage(MissionText.MM_StopMove_Vodila, 5.0, 175, 175, 175);
    AI.HandleVoice(npc, "male_ger_stopmove_stopmove_11");
    if (Level.GuardDoorOpened == false) then
      Actor.MarkAsTarget( Level.FindActor( 'G131' ) , true );
      Actor.MarkAsTarget( Level.FindActor( 'G132' ) , true );
      Actor.MarkAsTarget( Level.FindActor( 'GS71' ) , true );
      Actor.MarkAsTarget( Level.FindActor( 'G118' ) , true );
      Actor.MarkAsTarget( Level.FindActor( 'GS58' ) , true );
      Actor.MarkAsTarget( Level.FindActor( 'GS86' ) , true );
      Actor.MarkAsTarget( Level.FindActor( 'GS97' ) , true );
      Level.InstallDpc( "AI.SetJob( AI.FindNPC('G131'), 'job_new')", 5.5 );
      Level.InstallDpc( "AI.SetJob( AI.FindNPC('G132'), 'job_new')", 5.5 );
      Level.InstallDpc( "Level.RunAnchorJob( AI.FindNPC('G131'), 'MM03', true )", 6.0 );
    end
  elseif (zone == "mmZoneE1" or
          zone == "mmzoneE2") then
    Level.AddSmallMessage(MissionText.MM_StopMove_Radist, 5.0, 175, 175, 175);
    AI.HandleVoice(npc, "male_ger_stopmove_stopmove_12");
    if (AI.FindNPC('LIQ1') != nil) then
      Actor.MarkAsTarget( Level.FindActor( 'G112' ) , true );
      Actor.MarkAsTarget( Level.FindActor( 'GS55' ) , true );
      Actor.MarkAsTarget( Level.FindActor( 'GS66' ) , true );
      Actor.MarkAsTarget( Level.FindActor( 'GS80' ) , true );
    end
  elseif (zone == "mmZoneF1") then
    if (playerForm == "CIV1") then
      Level.AddSmallMessage(MissionText.MM_StopMove_CIV, 5.0, 175, 175, 175);
      AI.HandleVoice(npc, "male_ger_stopmove_stopmove_06");
    else
      Level.AddSmallMessage(MissionText.MM_StopMove_NoEntry, 5.0, 175, 175, 175);
      AI.HandleVoice(npc, "male_ger_stopmove_stopmove_17");
    end
  elseif (zone == "mmZoneG1") then
    Level.AddSmallMessage(MissionText.MM_StopMove_GetOut, 5.0, 175, 175, 175);
    AI.HandleVoice(npc, "male_ger_stopmove_stopmove_08");
  end
end

--------------------------------------------------------
-- Name: Level.ChangeRadistJob()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.ChangeRadistJob()
   AI.Debug(npc, "Script", "Level.ChangeRadistJob()");

   if (AI.IsDefault(AI.FindNPC('G112')) != false) then
      AI.SetJob(AI.FindNPC('G112'), "enter_house");
   end
   if (AI.IsDefault(AI.FindNPC('G123')) != false) then
      AI.SetJob(AI.FindNPC('G123'), "job_new");
   end
end

--------------------------------------------------------
-- Name: Level.ChangeUnteroffizierJob()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.ChangeUnteroffizierJob()
   AI.Debug(npc, "Script", "Level.ChangeUnteroffizierJob()");

   if (AI.IsDefault(AI.FindNPC('GS49')) != false) then
      AI.SetJob(AI.FindNPC('GS49'), "job_new");
   end
end

--------------------------------------------------------
-- Name: Level.ChangeRadist2Job()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.ChangeRadist2Job()
   AI.Debug(npc, "Script", "Level.ChangeRadist2Job()");

   if (AI.IsDefault(AI.FindNPC('GS79')) != false) then
      AI.SetJob(AI.FindNPC('GS79'), "job_new");
   end
   if (AI.IsDefault(AI.FindNPC('GS80')) != false) then
      AI.SetJob(AI.FindNPC('GS80'), "job_new");
   end
end

--------------------------------------------------------
-- Name: Level.OnKnutChangeJobTrigger()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.OnTrigger_KnutChangeJob()
   Level.InstallDpc("Level.DoKnutChangeJob()", 10.0);
end

--------------------------------------------------------
-- Name: Level.DoKnutChangeJob()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.DoKnutChangeJob()
   AI.SetJob(AI.FindNPC('GF01'), "wait_knut");
   AI.SetJob(AI.FindNPC('LIQ3'), "post_pash");
end

----------------------------------------------------------
-- Name: Level.OnBikeEnter()
-- MoTmod Addon
-- Liz Shaw
----------------------------------------------------------
function Level.OnBikeEnter()
  local g124 = AI.FindNPC('G124');
  local g125 = AI.FindNPC('G125');
  local g126 = AI.FindNPC('G126');
  if (g124 != nil) then
    AI.SetDecamouflageLevel(AI.AI_TARGET_UID, "G124", Actor.ACTOR_TYPE_OFFICER);
    AI.HandleVoice(g124, "male_ger_ohers_postoroniy");
  end
  if (g125 != nil) then
    AI.SetDecamouflageLevel(AI.AI_TARGET_UID, "G125", Actor.ACTOR_TYPE_OFFICER);
  end
  if (g126 != nil) then
    AI.SetDecamouflageLevel(AI.AI_TARGET_UID, "G126", Actor.ACTOR_TYPE_OFFICER);
  end
end

-----------------------------------------------------------
-- Name: Level.OnLeaveMercedes()
-- MoTmod Addon
-- Liz Shaw
-----------------------------------------------------------
function Level.OnLeaveMercedes()

   AI.EnableZone("mmZoneM1", false);

end

-----------------------------------------------------------
-- Name: Level.OnEnterMercedes()
-- MoTmod Addon
-- Liz Shaw
-----------------------------------------------------------
function Level.OnEnterMercedes()

   AI.EnableZone("mmZoneM1", true);
 
end

-----------------------------------------------------------
-- Name: Level.OnKilledVodila()
-- MoTmod Addon
-- Liz Shaw
-----------------------------------------------------------
function Level.OnKilledVodila()
   if (Level.GetDifficulty() != 3) and (Actor.HasCustomEquipment( Level.GetPlayer(), 'POIS') == false) then
      if (AI.FindNPC('GS71') == nil) then
         Level.InstallDpc( "AI.SetJob( AI.FindNPC('G131'), 'job_new')", 5.5 );
         Level.InstallDpc( "AI.SetJob( AI.FindNPC('G132'), 'job_new')", 5.5 );
         Level.InstallDpc( "Level.RunAnchorJob( AI.FindNPC('G131'), 'MM03', true )", 6.0 );
      elseif (AI.FindNPC('G118') == nil) then
         Level.InstallDpc( "AI.SetJob( AI.FindNPC('G131'), 'job_new')", 5.5 );
         Level.InstallDpc( "AI.SetJob( AI.FindNPC('G132'), 'job_new')", 5.5 );
         Level.InstallDpc( "Level.RunAnchorJob( AI.FindNPC('G131'), 'MM03', true )", 6.0 );
      elseif (AI.FindNPC('GS58') == nil) then
         Level.InstallDpc( "AI.SetJob( AI.FindNPC('G131'), 'job_new')", 5.5 );
         Level.InstallDpc( "AI.SetJob( AI.FindNPC('G132'), 'job_new')", 5.5 );
         Level.InstallDpc( "Level.RunAnchorJob( AI.FindNPC('G131'), 'MM03', true )", 6.0 );
      elseif (AI.FindNPC('GS86') == nil) then
         Level.InstallDpc( "AI.SetJob( AI.FindNPC('G131'), 'job_new')", 5.5 );
         Level.InstallDpc( "AI.SetJob( AI.FindNPC('G132'), 'job_new')", 5.5 );
         Level.InstallDpc( "Level.RunAnchorJob( AI.FindNPC('G131'), 'MM03', true )", 6.0 );
      elseif (AI.FindNPC('GS97') == nil) then
         Level.InstallDpc( "AI.SetJob( AI.FindNPC('G131'), 'job_new')", 5.5 );
         Level.InstallDpc( "AI.SetJob( AI.FindNPC('G132'), 'job_new')", 5.5 );
         Level.InstallDpc( "Level.RunAnchorJob( AI.FindNPC('G131'), 'MM03', true )", 6.0 );
      end
   end
end

--------------------------------------------------------
-- Name: Level.OnNotifyPickupItem()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.OnNotifyPickupItem( itemId, item )
   if ( itemId == 'POIS' ) then
   
      AI.StartDecamouflage( 40.0, 70.0, 3.0 );            
      Level.EnableNotifyPickup( item, false );
      Level.EnableLevelMark('POIS', false);
   end
end

-----------------------------------------------------------
-- Name: Level.OnCamoSoldierClothChange()
-- MoTmod Addon
-- Liz Shaw
-----------------------------------------------------------
function Level.OnCamoSoldierClothChange()
  local player = Level.GetPlayer();
  if (player != nil) then
    Actor.EnableMesh(player, "mesh_water_bottle", false);
    Actor.EnableMesh(player, "grm_cap", false);
  end
end

-----------------------------------------------------------
-- Name: Level.OnSoldierClothChange()
-- MoTmod Addon
-- Liz Shaw
-----------------------------------------------------------
function Level.OnSoldierClothChange()
  local player = Level.GetPlayer();
  if (player != nil) then
    Actor.EnableMesh(player, "sabg_equipment_up", false);
    Actor.EnableMesh(player, "sabg_equipment_down", false);
    Actor.EnableMesh(player, "mesh_helmet", false);
    Actor.EnableMesh(player, "mesh_cap", false);
  end
end

-----------------------------------------------------------
-- Name: Level.OnUnteroffizierClothChange()
-- MoTmod Addon
-- Liz Shaw
-----------------------------------------------------------
function Level.OnUnteroffizierClothChange()
  local player = Level.GetPlayer();
  if (player != nil) then
    Actor.EnableMesh(player, "sabg_equipment_up", false);
    Actor.EnableMesh(player, "sabg_equipment_down", false);
    Actor.EnableMesh(player, "mesh_helmet", false);
  end
end

-----------------------------------------------------------
-- Name: Level.OnRadistClothChange()
-- MoTmod Addon
-- Liz Shaw
-----------------------------------------------------------
function Level.OnRadistClothChange()
  local player = Level.GetPlayer();
  if (player != nil) then
    Actor.EnableMesh(player, "sabg_equipment_up", false);
    Actor.EnableMesh(player, "sabg_equipment_down", false);
    Actor.EnableMesh(player, "mesh_helmet", false);
    Actor.EnableMesh(player, "mesh_cap", false);
  end
  Level.EnableLevelMark('RAD1', false);
  Level.RemoveActionHandler(Level.AH_FINISH_CHANGECLOTH, 'RAD1');
end

--------------------------------------------------------
-- Name: Level.OnGuardOpenDoor()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.OnGuardOpenDoor()
   Level.RunAnchorJob2(AI.FindNPC('MMDF'), 'MM01', 'MM02', true);
end

--------------------------------------------------------
-- Name: Level.CanGuardOpenDoor()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.CanGuardOpenDoor()
   if (Level.GuardDoorOpened != false) then
      return false;
   end
   
   local npc = AI.FindNPC('MMDF');
   if (AI.IsDefault(npc) == false) then
      return false;
   end
   
   if (AI.HasPlayerInfo(npc, "see") == false) then
      return false;
   end
   
   if (AI.GetPlayerForm() != "VOD1") then
      return false;
   end
   
   return true;
end

--------------------------------------------------------
-- Name: Level.CanGuardOpenDoor()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.OnAnchor_MMAnchor02()
    Actor.MarkAsTarget( Level.FindActor( 'G131' ) , false );
    Actor.MarkAsTarget( Level.FindActor( 'G132' ) , false );
    Actor.MarkAsTarget( Level.FindActor( 'GS71' ) , false );
    Actor.MarkAsTarget( Level.FindActor( 'G118' ) , false );
    Actor.MarkAsTarget( Level.FindActor( 'GS58' ) , false );
    Actor.MarkAsTarget( Level.FindActor( 'GS86' ) , false );
    Actor.MarkAsTarget( Level.FindActor( 'GS97' ) , false );
    Level.GuardDoorOpened = true;
end

--------------------------------------------------------
-- Name: Level.OnTransformStats()
-- Desc:
--------------------------------------------------------
function Level.OnTransformStats(levelStats, aiStats)
end

--------------------------------------------------------
-- Name: Level.OnTransformStats()
-- Desc:
--------------------------------------------------------
function Level.OnTransformInputs(levelStats, aiStats, a, c, p, n, acc)
   p = Level.DefaultCalcProf(c, n, acc);
   return a, c, p, n;
end

--------------------------------------------------------
-- Name: Level.OnCalcScore()
-- Desc:
--------------------------------------------------------
function Level.OnCalcRateScore(rank, score, levelStats, aiStats, a, c, p, n, acc)
   return rank, score;
end

--  function Level.Test()
--
--     local n = Entity.GetNode( Level.FindActor('LIQ1') );
--     local pos = {};
--     pos.x, pos.y, pos.z = node.GetPosition( n );
--     
--     node.SetPosition(n, pos.x, -50000.0, pos.y);
--     node.InvalidateTransforms( n );
--
--  end