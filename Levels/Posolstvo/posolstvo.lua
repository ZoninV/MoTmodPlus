
  MissionText = 
  {
      --Mission text
      Task_1               = " Достать оружие";
      Task_2               = " Уничтожить Волкова";
      Task_3               = " Покинуть здание";
      Key_Name             = "Ключ от склада";
      Key3f_Name           = "Ключ от картотеки";
      Message_PassName     = "Удостоверение служащего";
      Message_PassNameL    = "УДОСТОВЕРЕНИЕ СЛУЖАЩЕГО";
      Message_HaveNoKey    = "Дверь заперта. Ключ находится у заведующего архивами.";
      Message_IsNotSilence = "В посольстве поднята тревога. Обнаружили тело или уровень настороженности охраны достаточно высок.";
      Message_SayCook      = "@ Рабочие в подвале проголодались. Они хотят, чтобы ты спустился туда как можно скорее.";
      Kill_Agents          = "Вы уничтожили слишком много агентов.";
      Kill_Civilians       = "Вы уничтожили слишком много работников посольства.";
      Kill_Diplomats       = "Вы уничтожили слишком много дипломатов.";
      Kill_Guards          = "Вы уничтожили слишком много охранников.";
      Fail_Alarm           = "ПОДНЯТА ТРЕВОГА";
      Message_Poison       = "ОТРАВИТЬ КОФЕ";
      Message_ShowDocs     = "ПОКАЗАТЬ УДОСТОВЕРЕНИЕ СЛУЖАЩЕГО";
      Kill_Msg_1           = "Осталось ";
      Kill_Msg_3           = "Остался ";
      Kill_Msg_2           = " до инициализации крупного дипломатического скандала.";
      Message_Help         = {
                               "Убийство большого количества человек может привести к дипломатическому скандалу.";
                               "Убийство дипломатов может привести к дипломатическому скандалу.";
                               "На третьем этаже расположена комната отдыха персонала.";
                               "Первый этаж открыт для посетителей посольства.";
                               "Волков охраняется специальными агентами посольства.";
                               "Комнаты с архивами расположены в подвале посольства.";
                               "Смерть в результате несчастного случая не является причиной тревоги.";
                               "Для входа в подвал и на верхние этажи гражданскому необходимо иметь при себе удостоверение служащего.";
                             };
      Message_CloseDoor    = "ПОВЕСИТЬ ТАБЛИЧКУ";
      Poison_Need          = "! Нужен яд, чтобы отравить.";

	  -- Wunder
      Intro                = "Британское посольство, Москва, 1945 г.";
      Action_StealKey      = "ВЫКРАСТЬ КЛЮЧ";
      Message_StealKey     = "Вы украли ключ.";

      -- Liz Shaw
      MM_StopMove_Pass          = "@ Стоять! Покажите свое удостоверение!";
      MM_StopMove_DocsClear     = "@ Все в порядке, проходите.";
      MM_StopMove_Search        = "@ Я должен обыскать вас, прежде чем вы сможете пройти!";
      MM_StopMove_SearchClear   = "@ Оружия не обнаружено. Заходите.";
      MM_StopMove_Tualet        = "@ Вам здесь не место!";
      MM_StopMove_TualetWomen   = "@ Немедленно покиньте женский туалет!";
      MM_StopMove_Kitchen       = "@ Что вы делаете на кухне?";
      MM_StopMove_OfficeNear    = "@ Я не могу вас впустить, сэр! У вас назначена встреча?";
      MM_StopMove_Office2Near   = "@ В данный момент офис закрыт, пожалуйста, зайдите позже.";
      MM_StopMove_Office3Near   = "@ Сейчас этот офис занят нашим гостем.";
      MM_StopMove_Office        = "@ Я здесь работаю! Что вам нужно?";
      MM_StopMove_ArchiveClean  = "@ Эта комната закрыта на уборку! Оставьте меня в покое!";
      MM_StopMove_LeaveRoom     = "@ Вы должны немедленно покинуть эту комнату!";
      MM_StopMove_ConfRoom      = "@ Сейчас мы готовим зал для совещаний.";
      MM_StopMove_StaffLounge   = "@ В комнату отдыха для персонала допускаются только работники посольства.";
      MM_StopMove_Volkov        = "@ Эта спальня занята нашим гостем.";
      MM_StopMove_NearVolkov    = "@ В эту комнату имеют доступ только специальные агенты посольства.";
      MM_StopMove_Diplomat      = "@ Что? Я же специально дал указание меня не беспокоить!";
      MM_StopMove_LeaveOffice   = "@ Покиньте офис прямо сейчас!";
  };

  function Level.OnCompleteMission()

      System:ConsoleCommand( 'l_loadlevel "rolik_final" 1' );

  end;

  function Level.OnSave()
      Stream.WriteInt   (Level.PlayerFormId );
      Stream.WriteString(Level.PoisonCup );
      Stream.WriteBool  (Level.CanPoison);
      Stream.WriteBool  (Level.VolkovPoissoned);
      Stream.WriteBool  (Level.PianoMusicPlaying);
      Level.WriteArray  (Level.Pass);
      Level.WriteArray  (Level.GetPass );

      for i = 1, 6 do
        Stream.WriteBool(Level.ClosedDoor[i]);
      end

      Level.WriteArray( Level.NumKilled ); -- Liz Shaw
      Stream.WriteString( Level.SearchZoneName ); -- Liz Shaw
      Stream.WriteBool  ( Level.SearchingStart ); -- Liz Shaw
      Stream.WriteBool  ( Level.SearchJustFinished ); -- Liz Shaw
      Stream.WriteBool(Level.HadForbidObjects); -- Liz Shaw
      Stream.WriteBool  ( Level.TopFloorsDisabled ); -- Liz Shaw

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
  end

  function Level.OnLoad()
      Level.PlayerFormId      = Stream.ReadInt();
      Level.PoisonCup         = Stream.ReadString();
      Level.CanPoison         = Stream.ReadBool();
      Level.VolkovPoissoned   = Stream.ReadBool();
      Level.PianoMusicPlaying = Stream.ReadBool();
      Level.Pass              = Level.ReadArray();
      Level.GetPass           = Level.ReadArray();

      Level.ClosedDoor = {};
      for i = 1, 6 do
        Level.ClosedDoor[i] = Stream.ReadBool();
      end

      Level.NumKilled             = Level.ReadArray(); -- Liz Shaw
      Level.SearchZoneName        = Stream.ReadString(); -- Liz Shaw
      Level.SearchingStart        = Stream.ReadBool(); -- Liz Shaw
      Level.SearchJustFinished    = Stream.ReadBool(); -- Liz Shaw
      Level.HadForbidObjects      = Stream.ReadBool(); -- Liz Shaw
      Level.TopFloorsDisabled     = Stream.ReadBool(); -- Liz Shaw

      Level.OnLoad_Common(); -- forlik
     Level.AutoSaveSlot = Stream.ReadInt();
     if (Level.AutoSaveSlot == nil or Level.AutoSaveSlot < 0 or Level.AutoSaveSlot > 2) then
        Level.AutoSaveSlot = 0;
     end;
      Level.OnFinishLoad();
  end

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
     System:SaveGame( "_posolstvo_" .. tostring(nextSlot) .. ".asv" , false );
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

     System:LoadGame( "_posolstvo_" .. tostring(slot) .. ".asv" , true );

     return true;

  end;

  function Level.OnFinishLoad()

      Level.AddLargeMessage(MissionText.Intro , 10.0, 180, 180, 180 ); -- Wunder

      -- forlik System:SetVar( "r_glow", true );
      -- forlik System:SetVar( "r_glow_r", 1.5 );
      Level.OnFinishLoad_Common(); -- forlik
      Level.SetDOFPostFilter( 1, 0.0, 1600.0, 3500.0 ); --forlik

      local doors = { 'DR06', 'DR07', };

      for i = 1, 2 do
         local door = Level.FindDoor( doors[i] ); 

         if ( door != nil ) then
             Level.SetDoorUnlockKey( door, 'SKKY' );
         end
      end;

      local doors = { 'CG01', 'CG02', };

      for i = 1, 2 do
         local door = Level.FindDoor( doors[i] ); 

         if ( door != nil ) then
             Level.SetDoorUnlockKey( door, 'AKKY' );
         end
      end;

      if (Level.PianoMusicPlaying != false) then
         Level.PlayPianoSound( true );
      end

      Level.AddMusic( Level.MUSIC_MOOD_ATTENTION   , "#0.50#sounds\\music\\danger.ogg");
      Level.AddMusic( Level.MUSIC_MOOD_ACTION, "#0.50#sounds\\music\\sustain.ogg" );
      Level.AddMusic( Level.MUSIC_MOOD_DEFAULT, "#0.50#sounds\\music\\b_dark6.ogg" );
      Level.SetDefaultMusicPause( 250.0, 360.0, 20.0, 120.0 );

      local tualetDoorUid = { 'TLD1', 'TLD2', 'TLD3', 'TLD4', 'TLD5', 'TLD6' };
      for i = 1, 6 do
          Level.InstallDoorScript( tualetDoorUid[i] );

          if (Level.ClosedDoor[i] != false) then
             local door = Level.FindDoor( tualetDoorUid[i] );
             if (door != nil) then
                AI.RegisterClosedDoor(door, true);
             else 
                print("Cant find door " .. tualetDoorUid[i] );
             end
          end
      end

      Level.DoorTrigger = nil;

      -- patch
      local backpack = Level.FindContainer();
      if (backpack != nil) then
          Level.EnableItemPickup(backpack, true);
      end

  end

  function Level.InstallDoorScript(doorUID)
     local door = Level.FindDoor( doorUID );

     if ( door != nil ) then
       Level.SetDoorNotifyScript( door, true );
     end;
  end

  function Level.OnLoaded()

      Level.OnLoaded_Common(); -- forlik
      Level.AddMissionTask( MissionText.Task_1, 'WEPN', "levels\\posolstvo\\weapon_task.txt" , 1 );
      Level.AddMissionTask( MissionText.Task_2, 'KILL', "levels\\posolstvo\\kill_task.txt"   , 3 );
                                                              
      Level.EnableLevelMark( 'LEAV', false );
      Level.AddActionHandler( Level.AH_ACTOR_KILLED , "VOLK" , "OnKilledVolkov");

      Level.AddActionHandler( Level.AH_ACTOR_KILLED , 'E213' , "OnKilledTualetBot");
      Level.AddActionHandler( Level.AH_ACTOR_HITTED , 'E213' , "OnKilledTualetBot");
      Level.AddActionHandler( Level.AH_ACTOR_KILLED , 'E202' , "OnKilledTualetBot");
      Level.AddActionHandler( Level.AH_ACTOR_HITTED , 'E202' , "OnKilledTualetBot");
      Level.AddActionHandler( Level.AH_ACTOR_KILLED , 'E210' , "OnKilledTualetBot");
      Level.AddActionHandler( Level.AH_ACTOR_HITTED , 'E210' , "OnKilledTualetBot");

      Level.AddActionHandler( Level.AH_ACTOR_KILLED , 'COOK' , "OnKilledCook");
      Level.AddActionHandler( Level.AH_ACTOR_HITTED , 'COOK' , "OnKilledCook");

      Actor.MarkAsTarget( Level.FindActor( 'KEYM' ) , true );
      Actor.MarkAsTarget( Level.FindActor( 'VOLK' ) , true );

      Level.AddActionHandler( Level.AH_FINISH_CHANGECLOTH , "COCL" , "OnCookClothChange" );
      Level.AddActionHandler( Level.AH_FINISH_CHANGECLOTH , "TCCL" , "OnTechiClothChange" );

      Level.AddActionHandler( Level.AH_PLAYER_INVENTORY );
      Level.AddActionHandler( Level.AH_ACTOR_ALL_KILLED );

      NPC.SetFlag( AI.FindNPC('M207'), NPC.F_CANT_OPEN_LOCK_DOOR, true );
      NPC.SetFlag( AI.FindNPC('M209'), NPC.F_CANT_OPEN_LOCK_DOOR, true );
      NPC.SetFlag( AI.FindNPC('M210'), NPC.F_CANT_OPEN_LOCK_DOOR, true );
      NPC.SetFlag( AI.FindNPC('E206'), NPC.F_CANT_OPEN_LOCK_DOOR, true );

      AI.EnableGrenades( false );

      Level.Pass = { 'PAS1' };
      Level.GetPass = { false };

      local player = Level.GetPlayer();

      Level.PianoMusicPlaying = false;

      if (player != nil) then
         Actor.SetActorTypeId(player, Actor.ACTOR_TYPE_CIVILIAN, Actor.ACTOR_NATION_BRITISH );

         Actor.ChangeActorSkin( player, "WhiteHands" );
         Actor.EnableMesh( player, "mesh_hat2" , false );

         Level.PlayerFormId = Actor.GetWearFormId( player );

         AI.RebuildPlayerForm();
         AI.AddFormChangedValue();
      end

       for i in Level.Pass do
          Level.SetEntityName(Level.Pass[i], MissionText.Message_PassNameL, MissionText.Message_PassName);
       end
       
       local passNpc = { 'M203', 'HG05', 'DP02', 'DP03',
                         'E202', 'E205', 'E206', 'M211', 'M212',
                         'E208',
                         'M214', 'E210', 'M125', 'HG11',
                         'E213', 'E214', 'E219',
                         'A216', 'M218', 'M216', 'M224'
                         
                       };
                       
                       
       for i in passNpc do
          local actor = Level.FindActor(passNpc[i]);
          local pass = Level.CreateItem( "Custom" , "Equipment" );
          
          if (actor == nil) then
             print("Warning! Can't find actor " .. passNpc[i]);
          end

          if (pass != nil and actor != nil) then

             Entity.SetUniqueID( pass, 'PASS' );
          
             Level.SetCustomItemName( pass, MissionText.Message_PassName );
             Level.SetCustomItemIcon( pass, "ammo_doc" );

             Actor.PutPouch( actor, Actor.GetEmptyPouch(actor), pass );
          end
       end

      AI.ChangeLogic( AI.FindNPC('HG21'), "LiteScriptSoldier" );
      AI.ChangeLogic( AI.FindNPC('HG12'), "LiteScriptSoldier" );
      AI.ChangeLogic( AI.FindNPC('HG13'), "LiteScriptSoldier" );

      AI.SetPlayerForm("Civilian");
      AI.SetPlayerDefaultForm("Civilian");

      local keyMaster = Level.FindActor( 'KEYM' );
      if (keyMaster != nil) then

         local key = Level.CreateItem( "Custom" , "Equipment" );
         if ( key != nil ) then

             Entity.SetUniqueID( key, 'SKKY' );

             Level.SetCustomItemName( key, MissionText.Key_Name );
             Level.SetCustomItemIcon( key, "ammo_key" );
     
             Actor.PutPouch( keyMaster, Actor.GetEmptyPouch(keyMaster), key );
          end;
      end

      local keyMaster = Level.FindActor( 'KEYM' );
      if (keyMaster != nil) then

         local key = Level.CreateItem( "Custom" , "Equipment" );
         if ( key != nil ) then

             Entity.SetUniqueID( key, 'AKKY' );

             Level.SetCustomItemName( key, MissionText.Key3f_Name );
             Level.SetCustomItemIcon( key, "ammo_key" );
     
             Actor.PutPouch( keyMaster, Actor.GetEmptyPouch(keyMaster), key );
          end;
      end

      AI.EnableFloorRiskTest( true );

      -- Install timers...
      Level.AddTimer( 'DRTR', "OnDinnerTimer", 400, true );
      Level.AddTimer( 'PTTR', "OnPianistTimer", 250, true );
      Level.AddTimer( 'CTTR', "OnCookTimer", 100, true );

      Level.PoisonCup = "";
      Level.CanPoison = true;
      Level.VolkovPoissoned = false;
      Level.ClosedDoor = { false, false, false, 
                           false, false, false };

      Level.NumKilled = {}; -- Liz Shaw
      Level.SearchZoneName        = ""; -- Liz Shaw
      Level.SearchingStart        = false; -- Liz Shaw
      Level.SearchJustFinished    = false; -- Liz Shaw
      Level.HadForbidObjects = false; -- Liz Shaw
      Level.TopFloorsDisabled = false; -- Liz Shaw

      AI.OnPlayerEnterZone("global", 'GLSC'); -- forlik

      AI.EnableZone("SearchAlertZone_1",  false);
      AI.EnableZone("SearchZone_1",       false);
      AI.EnableZone("SearchAlertZone_2",  false);
      AI.EnableZone("SearchZone_2",       false);
      Level.OnFinishLoad();
     Level.AutoSave();
  end;

  AI.DoFile( "scripts:Levels\\Common.lua", false ); -- forlik

  function Level.OnDinnerTimer()

     AI.Debug(nil, "Level::OnDinnerTimer", "");

     local actors  = { 'HG08', 'HG04', 'HG05', 'M125', 'MC03', 'HG11' };
     local anchors = { 'A104', 'A105', 'A106', 'A107', 'A108', 'A143' };

     local n = table.getn( anchors );

     for i = 1, n do
        local actor = AI.FindNPC( actors[i] );

        if (actor != nil) then
           if (AI.GetAttention(actor) == AI.ATTENTION_RELAX) then
              local properties = Level.CreateCustomParams();

              Level.SetValue(properties, "CustomString_1", anchors[i] );

              AI.RunScriptTask(actor, "scripts:job\\AnchorJob_safe.lua", AI.LOGIC_DEFAULT, properties);
           end
        end
     end
  end

  function Level.PlayPianoSound( bOnOff )

    local sound = Level.FindSound( 'piano01' );

    if ( sound != -1 ) then
   
      if (bOnOff != false) then

         Level.PianoMusicPlaying = true;

         Level.PlaySound( sound );

      else

         Level.PianoMusicPlaying = false;

         Level.StopSound( sound );

      end;

    end

  end 

  function Level.OnPianistTimer()

     AI.Debug(nil, "Level::OnPianistTimer", "");

     local pianist = AI.FindNPC( 'E222' );
     local madam = AI.FindNPC( 'M220' );

     if (AI.IsDefault(pianist) and
         AI.IsDefault(madam)) then

         AI.RunScriptTask( pianist, "game:Levels\\Posolstvo\\Jobs\\PianoJob.lua",  AI.LOGIC_DEFAULT, nil );

         local properties = Level.CreateCustomParams();

         Level.SetValue(properties, "CustomString_1", 'A112' );
                                                                                                 
         AI.RunScriptTask(madam, "game:Levels\\Posolstvo\\Jobs\\MadamJob.lua", AI.LOGIC_DEFAULT, properties);
     end

  end

  function Level.OnAlert( alertGroupId )

    AI.SetLocalAlert(1, true);
    AI.SetLocalAlert(2, true);
    AI.SetLocalAlert(3, true);
    AI.SetLocalAlert(4, true);

    Level.FailedMission( MissionText.Fail_Alarm );

  end

  function Level.OnKilledVolkov()

      Level.AddMissionTask( MissionText.Task_3, 'LEAV', "levels\\posolstvo\\leave_task.txt", 1 );

      if (Level.IsMissionTaskCompleted( 'WEPN' ) == false) then
         Level.RemoveMissionTask('WEPN');
      end

      Level.PlayMenuSound("task_finish"); -- Liz Shaw
      Level.CompleteMissionTask('KILL', 15.0 );

      Level.EnableLevelMark( 'COFF', false );
      Level.EnableLevelMark( 'VOLK', false );

      Level.EnableLevelMark( 'LEAV', true );
      Level.AutoSave();
  end

  function Level.OnEnterTriggerArea( sender, trgname, trgcmd )

    if ( Level.IsMissionFailed() != false ) then
      return;
    end;

    if     ( trgname == 'SkladTrigger_01' ) then

         Level.EnableLevelMark('SKD1', false );
         Level.UnregisterTrigger( Level.FindTrigger( trgname ) );

         if (Level.GetDifficulty() != 3) then
           Level.EnableLevelMark('CLTS', true);
         end;

    --elseif ( trgname == 'SkladTrigger_02' ) then

    --     Level.EnableLevelMark('SKD2', false );
    --     Level.UnregisterTrigger( Level.FindTrigger( trgname ) );

    elseif ( trgname == 'WeaponTrigger_01') then

         Level.PlayMenuSound("task_finish"); -- Liz Shaw
         Level.CompleteMissionTask('WEPN', 15.0 );
         Level.UnregisterTrigger( Level.FindTrigger( trgname ) );

         Level.EnableLevelMark('SKD1', false );
         Level.EnableLevelMark('SKD2', false );
         Level.EnableLevelMark('BOTP', false );

         if (Level.GetDifficulty() != 3) then
           Level.EnableLevelMark('CLTS', true);
         end;
         Level.AutoSave();

    elseif (trgname == 'PodvalTrigger_01') then

         Level.EnableLevelMark('BOTP', false );
         Level.UnregisterTrigger( Level.FindTrigger( trgname ) );

    elseif (trgname == 'LeaveTrigger_01') then

         if ( Level.IsMissionTaskCompleted('KILL')) then

              if (AI.IsSilence() != false) then

                Level.PlayMenuSound("task_finish"); -- Liz Shaw
                Level.CompleteMissionTask('LEAV', 15.0 );
                Level.UnregisterTrigger( Level.FindTrigger( trgname ) );

              else

                Level.AddSmallMessage( MissionText.Message_IsNotSilence, 15.0 , 255, 50, 0 );
                
              end

              return;
         end


    elseif ( trgname == 'DoorTrigger_01' or
             trgname == 'DoorTrigger_02') then

         if ( Actor.HasCustomEquipment( Level.GetPlayer(), 'SKKY' ) == false ) then
           Level.AddSmallMessage( MissionText.Message_HaveNoKey, 15.0 , 255, 255, 255 );
         end;

         Level.UnregisterTrigger( Level.FindTrigger( 'DoorTrigger_01' ) );
         Level.UnregisterTrigger( Level.FindTrigger( 'DoorTrigger_02' ) );

    elseif (trgname == 'RestoreZonesTrigger_01') then
       -- restore zones...

       Level.RestoreZones_01();

    elseif (trgname == 'RestoreZonesTrigger_02') then
       -- restore zones...

       Level.RestoreZones_02();

    end;

  end;

  function Level.OnLeaveTriggerArea( sender, trgname, trgcmd ) -- Liz Shaw

  end;

  function Level.PersonKillHandler( maxKill, killedAlready, killMessage )

      local left = maxKill - killedAlready;

      if ( left <= 0 ) then

          AI.CallAlert( 20 );
          return;

      end;

      local messageFirst;

      if ( left == 1 ) then
         messageFirst = MissionText.Kill_Msg_3;
      else
         messageFirst = MissionText.Kill_Msg_1;
      end;
    
      local message = killMessage .. messageFirst .. tostring( left ) .. MissionText.Kill_Msg_2;
      Level.SetLargeMessage( message, 15.0, 255, 255, 255 );

  end;


  function Level.OnActorKilled( actor )

    if ( (AI.IsLocalAlert(1) != false) or
         (AI.IsLocalAlert(2) != false) or
         (AI.IsLocalAlert(3) != false) or
         (AI.IsLocalAlert(4) != false) ) then 
        return;
    end;

    local npc = AI.FromActor ( actor );
    if (npc != nil) then
       local form = AI.GetForm( npc );
       if (Level.NumKilled[form] == nil) then
          Level.NumKilled[form] = 0;
       end;

     Level.NumKilled[form] = Level.NumKilled[form] + 1;

     local civilianKilled  = Level.GetNumKilled("Civilian") + Level.GetNumKilled("Cook") + Level.GetNumKilled("Plumber") + Level.GetNumKilled("ArchiveMan") + Level.GetNumKilled("Maid") + Level.GetNumKilled("Secretary") + Level.GetNumKilled("Madam") + Level.GetNumKilled("OfficeMan") + Level.GetNumKilled("ArchiveMan2");
     local soldiersKilled  = Level.GetNumKilled("Soldier") + Level.GetNumKilled("Guardian") + Level.GetNumKilled("Guardian2") + Level.GetNumKilled("Soldier2") + Level.GetNumKilled("SearchMan_1") + Level.GetNumKilled("SearchMan_2");
     local agentsKilled    = Level.GetNumKilled("Agent");
     local diplomatsKilled = Level.GetNumKilled("Diplomat");

     if (form == "Civilian" or form == "Cook" or form == "Plumber" or form == "ArchiveMan" or form == "Maid" or form == "Secretary" or form == "Madam" or form == "OfficeMan" or form == "ArchiveMan2") then
        if (civilianKilled > 3) then
           Level.PersonKillHandler( 5, civilianKilled, MissionText.Kill_Civilians );
        end;
     elseif (form == "Soldier" or form == "Guardian" or form == "Guardian2" or form == "Soldier2" or form == "SearchMan_1" or form == "SearchMan_2") then
        if (soldiersKilled > 1) then
           Level.PersonKillHandler( 3, soldiersKilled, MissionText.Kill_Guards );
        end;
     elseif (form == "Agent") then
        if (agentsKilled > 0) then
           Level.PersonKillHandler( 2, agentsKilled, MissionText.Kill_Agents );
        end;
     elseif (form == "Diplomat") then
        if (diplomatsKilled > 0) then
           Level.PersonKillHandler( 1, diplomatsKilled, MissionText.Kill_Diplomats );
        end;
     end;
    end;
  end;

  function Level.AddKey( actorId, keyId, name )
     local actor = Level.FindActor(actorId);

     if (actor != nil) then
        local key = Level.CreateItem( "Custom" , "Equipment" );
        if ( key != nil ) then
           Entity.SetUniqueID( key, keyId );

           Level.SetCustomItemName( key, name );
           Level.SetCustomItemIcon( key, "ammo_key" );
     
           Actor.PutPouch( actor, Actor.GetEmptyPouch(actor), key );
        else
           print("Warning. Can't create key " .. keyId);
        end;
     else 
        print("Warning. Can't find actor " .. actorId);
     end;
  end

  function Level.SetDoorKey(door, key)
     local d = Level.FindDoor(door);
     if (d != nil) then
        Level.SetDoorUnlockKey( d, key );
     end
  end

  function Level.GetTualetDoorIndex( tualetUID )
    if     (tualetUID == 'TLD1') then
       return 1;
    elseif (tualetUID == 'TLD2') then
       return 2;
    elseif (tualetUID == 'TLD3') then   
       return 3;
    elseif (tualetUID == 'TLD4') then
       return 4;
    elseif (tualetUID == 'TLD5') then
       return 5;
    elseif (tualetUID == 'TLD6') then
       return 6;
    end

    print('Cant find door ' .. tualetUID);
    return nil;
  end

  function Level.IsTualetDoorClosed( tualetUID )
    local index = Level.GetTualetDoorIndex(tualetUID);
    return Level.ClosedDoor[index];
  end

  function Level.CanCloseTualetDoor( tualetUID )
    local index = Level.GetTualetDoorIndex(tualetUID);
    if (Level.ClosedDoor[index] != false) then 
       return false;
    end

    if (Actor.HasEquipment( Level.GetPlayer(), 'TOOO' ) == false) then 
       return false;
    end  

    local npc = Level.GetTualetNPC(index);
    if (npc == nil) then
       return true;
    end

    local anchor = Level.GetTualetNPC_Anchor(index);
    if (anchor == nil) then
       return true;
    end

    if (AI.IsDefault(npc) == false) then
       return true;
    end
 
    if (AI.IsUsingAnchor(npc, anchor) != false or
        AI.IsNearAnchor(npc, anchor, 15.0)) then
       return false;
    end

    return true;
  end

  function Level.CloseTualetDoor( tualetUID )
    if (Level.CanCloseTualetDoor(tualetUID) == false) then
       return false;
    end

    local door = Level.FindDoor( tualetUID );

    if (Level.IsDoorOpened(door) != false) then
        Level.CloseDoor( door, true, Level.GetPlayer() );
    end

    local index = Level.GetTualetDoorIndex(tualetUID);
    Level.ClosedDoor[index] = true;

    Level.InstallTualetJob( tualetUID, true );

    Level.RemovePlayerAction("CLDR");
    AI.RegisterClosedDoor(door, true);

    -- Update ooo table
    if (Actor.HasEquipment( Level.GetPlayer(), 'TOOO' )) then
       Actor.RemoveEquipment(Level.GetPlayer(), 'TOOO');
    end

    local n = Actor.GetNode( Level.GetPlayer() );
    local pos = {};
    pos.x, pos.y, pos.z = node.GetPosition( n );
    local tab = Level.CreateWorldItem("Throw:OutofOrder", "Equipment",
                                      pos.x, pos.y + 2.0, pos.z,
                                      0.0, 0.0, 0.0, 
                                      'TOOO');

    if (tab != nil) then
       Level.AttachItemWorldObject( tab, tualetUID, 0.0, 5.0, 0.3, 180.0 );
    else
       print("Warning! Can't create [Equipment.Throw:OutofOrder]");
    end
  end

  function Level.GetTualetNPC( tualetIndex )
    local actors = { 'E213', 'E202', 'E210' };
    if (actors[tualetIndex] == nil) then
       return nil;
    end

    return AI.FindNPC(actors[tualetIndex]);
  end

  function Level.GetTualetNPC_Anchor( tualetIndex, bNotClosed )
    local anchors_opened = { 'AN08', 'AN32', 'AN51' };
    local anchors_closed = { 'A155', 'A156', 'A157' };

    if (anchors_opened[tualetIndex] == nil and
        anchors_closed[tualetIndex] == nil) then
        return nil;
    end

    if (bNotClosed != false) then
       return AI.FindAnchor(anchors_opened[tualetIndex]);
    else
       return AI.FindAnchor(anchors_closed[tualetIndex]);
    end

    return nil;
  end

  function Level.StartAnchor3_Idle( npc, anchor1, anchor2, anchor3 )
    local properties = Level.CreateCustomParams();
    Level.SetValue(properties, "Can use anchors", true);
    Level.SetValue(properties, "Use anchor interval", 0.0);
    Level.SetValue(properties, "Find anchor radius", 300.0);
    Level.SetValue(properties, "Don't repeat anchors", false);
    Level.SetValue(properties, "AnchorQueue0", anchor1);
    Level.SetValue(properties, "AnchorQueue1", anchor2);
    Level.SetValue(properties, "AnchorQueue2", anchor3);
    Level.SetValue(properties, "Can Patrol Point", false);
    Level.SetValue(properties, "Can Smoke", false);
    Level.SetValue(properties, "Can Speak", false);
    Level.SetValue(properties, "Return spawn place", false);
    Level.SetValue(properties, "Restore spawn direction", false);
    Level.SetValue(properties, "Can idle animation", false);

    AI.Idle( npc, properties );
  end

  function Level.StartAnchor2_Idle( npc, anchor1, anchor2 )
    local properties = Level.CreateCustomParams();
    Level.SetValue(properties, "Can use anchors", true);
    Level.SetValue(properties, "Use anchor interval", 0.0);
    Level.SetValue(properties, "Find anchor radius", 300.0);
    Level.SetValue(properties, "Don't repeat anchors", false);
    Level.SetValue(properties, "AnchorQueue0", anchor1);
    Level.SetValue(properties, "AnchorQueue1", anchor2);
    Level.SetValue(properties, "Can Patrol Point", false);
    Level.SetValue(properties, "Can Smoke", false);
    Level.SetValue(properties, "Can Speak", false);
    Level.SetValue(properties, "Return spawn place", false);
    Level.SetValue(properties, "Restore spawn direction", false);
    Level.SetValue(properties, "Can idle animation", false);

    AI.Idle( npc, properties );
  end

  function Level.StartIdleEx( npc, anchor )
    local properties = Level.CreateCustomParams();
    Level.SetValue(properties, "Can Patrol Point", false);
    Level.SetValue(properties, "Can Smoke", false);
    Level.SetValue(properties, "Can Speak", true);
    Level.SetValue(properties, "Return spawn place", true);
    Level.SetValue(properties, "Restore spawn direction", true);
    Level.SetValue(properties, "Return place noise", 0.0);
    Level.SetValue(properties, "Spawn place return limit", 0.0);
    Level.SetValue(properties, "Spawn place return limit", 0.0);
    Level.SetValue(properties, "Smoke Interval", 60.0);
    Level.SetValue(properties, "Idle animation interval", 10.0);
    Level.SetValue(properties, "Conference interval", 30.0);
    Level.SetValue(properties, "Default point as speak point", true);
    Level.SetValue(properties, "Can use anchors", true);
    Level.SetValue(properties, "Use anchor interval", 10.0);
    Level.SetValue(properties, "Find anchor radius", 300.0);
    Level.SetValue(properties, "Position", 198.0, 1.45, -11.95);
    Level.SetValue(properties, "Direction", -1.0, 0.0, 0.0);
    Level.SetValue(properties, "Can idle animation", true);
    Level.SetValue(properties, "Don't repeat anchors", false);
    Level.SetValue(properties, "Use dynamic speak point", false);
    Level.SetValue(properties, "Don't change speak direction", true);
    Level.SetValue(properties, "Don't rotate speak head", true);
    Level.SetValue(properties, "Return place waypoint", "");
    Level.SetValue(properties, "AnchorQueue0", anchor);

    AI.Idle( npc, properties );
  end

  function Level.InstallTualetJob( tualetUID, bOnOff )
    local index = Level.GetTualetDoorIndex(tualetUID);
    local npc = Level.GetTualetNPC(index);

    if (npc == nil) then
       return true;
    end

    if (tualetUID == 'TLD1') then
       if (bOnOff == false) then
          Level.StartAnchor3_Idle( npc, 'AN08', 'AN10', 'AN61' );
       else
          Level.StartAnchor3_Idle( npc, 'A155', 'AN10', 'AN61' );
       end
    elseif (tualetUID == 'TLD2') then
       if (bOnOff == false) then
          Level.StartAnchor2_Idle( npc, 'AN31', 'AN32' );
       else
          Level.StartAnchor2_Idle( npc, 'AN31', 'A156' );
       end
    elseif (tualetUID == 'TLD3') then
       if (bOnOff == false) then
          Level.StartIdleEx( npc, 'AN51' );
       else
          Level.StartIdleEx( npc, 'A157' );
       end
    end

    return true;
  end

  function Level.DecloseDoor( door )
    if (Level.IsTualetDoorClosed(door) != false) then
       Level.InstallTualetJob( door, false );

       local index = Level.GetTualetDoorIndex(door);
       Level.ClosedDoor[index] = false;
       AI.RegisterClosedDoor(Level.FindDoor(door), false);
    end
  end

  function Level.OnOpenDoor( door )
--    local b = false;
--    if (Level.IsTualetDoorClosed(door) != false) then
--       b = true; 
--    end

--    Level.DecloseDoor( door );

    if (Level.GetTualetDoorIndex(door) != nil) then
       if (Level.DoorTrigger != nil) then
          Level.DoorTrigger:OnEnterArea();
       end
    end

--    if (b != false) then
--       local t = Level.FindItem('TOOO');
--       if (t != nil) then
--          Level.UnattachItemWorldObject( t );
--          Level.DeleteItem( t );
--       else
--          print("Warning. Cant find equipment TOOO");
--       end
 
--       local tab = Level.CreateItem("Throw:OutofOrder", "Equipment");
--       Entity.SetUniqueID( tab, 'TOOO' );
--       Actor.PutPouch( Level.GetPlayer(), Actor.GetEmptyPouch( player ), tab );
--    end
  end

  function Level.OnCloseDoor( door )
    if (Level.GetTualetDoorIndex(door) != nil) then
       if (Level.DoorTrigger != nil) then  
          Level.DoorTrigger:OnEnterArea();
       end
    end
  end

  function Level.OnKilledTualetBot()
     if (Level.DoorTrigger != nil) then
        Level.DoorTrigger:OnEnterArea();
     end
  end

  function Level.OnInventoryChanged()
     local tualetUID = { 'TLD1', 'TLD2', 'TLD3', 'TLD4', 'TLD5', 'TLD6' };
     local update = false;
     if (Actor.HasEquipment( Level.GetPlayer(), 'TOOO' ) != false) then
        for i = 1, 6 do
           if (Level.ClosedDoor[i] != false) then
              Level.DecloseDoor(tualetUID[i]);
              update = true;
           end
        end

        if (AI.GetPlayerForm() != "Plumber") then
           AI.StartDecamouflage( 50.0, 100.0, 10.0 );
        end

        Level.EnableLevelMark( 'TOOO', false );
     end

       local player = Level.GetPlayer();
     
     for i in Level.Pass do 
        if (Level.GetPass[i] == false and 
            Actor.HasCustomEquipment(player, Level.Pass[i]) == true) then
           
           AI.StartDecamouflage( 50.0, 100.0, 3.0 );
           Level.GetPass[i] = true;
        end

        Level.EnableLevelMark( 'PAS1', false );
     end

     if (update != false) then
        if (Level.DoorTrigger != nil) then
           Level.DoorTrigger:OnEnterArea();
        end
     end
  end

--------------------------------------------------------
-- Name: Level.HasForbidObjects()
-- Desc:
--------------------------------------------------------
function Level.HasForbidObjects()

   local numKnifes = Actor.GetNumWeaponOfClass( Level.GetPlayer(), Level.WEAPON_CLASS_KNIFE, true );
   if (numKnifes >= 1) then
      return true;
   end
   
   local numPistols = Actor.GetNumWeaponOfClass( Level.GetPlayer(), Level.WEAPON_CLASS_PISTOL, true );
   if (numPistols >= 1) then
      return true;
   end
   
   local numRifles = Actor.GetNumWeaponOfClass( Level.GetPlayer(), Level.WEAPON_CLASS_RIFLE, true ) +
                     Actor.GetNumWeaponOfClass( Level.GetPlayer(), Level.WEAPON_CLASS_MACHINEGUN, true );
   if (numRifles >= 1) then
      return true;
   end

   return false;
end

--------------------------------------------------------
-- Name: Level.OnSearchFinished()
-- Desc:
--------------------------------------------------------
function Level.OnSearchFinished()

   if (Level.HasForbidObjects() == true) then
        
      AI.DecamouflagePlayer(Level.GetSearchMan());
        
   else
      Level.AddSmallMessage( MissionText.MM_StopMove_SearchClear, 5.0, 175, 175, 175 );

      AI.EnableZone("SearchAlertZone_1", false);
      AI.EnableZone("SearchZone_1", false);
   end

   Level.SearchJustFinished = true;
end

--------------------------------------------------------
-- Name: Level.OnSearch2Finished()
-- Desc:
--------------------------------------------------------
function Level.OnSearch2Finished()

   if (Level.HasForbidObjects() == true) then
        
      AI.DecamouflagePlayer(Level.GetSearchMan());
        
   else
      Level.AddSmallMessage( MissionText.MM_StopMove_SearchClear, 5.0, 175, 175, 175 );

      AI.EnableZone("SearchAlertZone_2", false);
      AI.EnableZone("SearchZone_2", false);
   end

   Level.SearchJustFinished = true;
end

--------------------------------------------------------
-- Name: Level.InitSearchScript()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.InitSearchScript(npc)
     local properties = Level.CreateCustomParams();     
        
     Level.SetValue(properties, "CustomString_1", "PlayerFront" );
     Level.SetValue(properties, "CustomString_2", "Level.OnSearchFinished()" );
     Level.SetValue(properties, "CustomString_3", 'SRSC' );
     Level.SetValue(properties, "CustomString_4", "Act_Cowboy_SearchMan" );
     Level.SetValue(properties, "CustomString_5", "" );
     Level.SetValue(properties, "CustomString_6", "7.0" );

     AI.RunScriptTask(npc, "scripts:job\\LookObjectTask.lua", AI.LOGIC_DEFAULT, properties);
     
     Level.SearchingStart = true;
     Level.InstallDpc('Level.SearchingStart = true', 0.5);
end

--------------------------------------------------------
-- Name: Level.InitSearch2Script()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.InitSearch2Script(npc)
     local properties = Level.CreateCustomParams();     
        
     Level.SetValue(properties, "CustomString_1", "PlayerFront" );
     Level.SetValue(properties, "CustomString_2", "Level.OnSearch2Finished()" );
     Level.SetValue(properties, "CustomString_3", 'SRSC' );
     Level.SetValue(properties, "CustomString_4", "Act_Cowboy_SearchMan" );
     Level.SetValue(properties, "CustomString_5", "" );
     Level.SetValue(properties, "CustomString_6", "7.0" );

     AI.RunScriptTask(npc, "scripts:job\\LookObjectTask.lua", AI.LOGIC_DEFAULT, properties);
     
     Level.SearchingStart = true;
     Level.InstallDpc('Level.SearchingStart = true', 0.5);
end

--------------------------------------------------------
-- Name: Level.CheckLookObjectTaskCondition()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.CheckLookObjectTaskCondition(npc, id) 
   if (id == 'SRSC') then
      local zone = AI.GetPrimaryPlayerZone( npc );
      return zone == Level.SearchZoneName;
   end
   
   return false;
end

--------------------------------------------------------
-- Name: Level.GetSearchMan()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.GetSearchMan()
     
   local job = AI.GetScriptJob("TASK_SCRIPT_LOOK_OBJECT");
   if (job != nil) then
     return Job.GetNPC( job );
   end
     
   return nil; 
end

--------------------------------------------------------
-- Name: Level.OnCheckShowPass()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.OnCheckShowPass()
   local npc = AI.FindNearestNpc(AI.TASK_SHOW_STOP_MOVE, "");

   if (npc == nil) then
      Level.SafeRemoveLevelPlayerAction('SHP1');
      Level.SafeRemoveLevelPlayerAction('SHP2');
   end
end

--------------------------------------------------------
-- Name: Level.RestoreBasementZone()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.RestoreBasementZone()
   AI.EnableZone("Basement_Pass",      true);
   AI.EnableZone("BasementEnter",      true);
end

--------------------------------------------------------
-- Name: Level.RestoreTopFloorsZone()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.RestoreTopFloorsZone()
   AI.EnableZone("TopFloors",      true);
   AI.EnableZone("TopFloorsEnter", true);
   Level.TopFloorsDisabled = false;
end

--------------------------------------------------------
-- Name: Level.PlayerHasPass()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.PlayerHasPass()
   local player = Level.GetPlayer();
   for i in Level.Pass do 
      if (Actor.HasCustomEquipment(player, Level.Pass[i]) == true) then
         return true;
      end
   end
     
   return (Actor.HasCustomEquipment(player, 'PASS') == true);
end

--------------------------------------------------------
-- Name: Level.GetNumKilled()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.GetNumKilled(form)
   if (Level.NumKilled[form] == nil) then
      return 0;
   end
   
   return Level.NumKilled[form];
end

--------------------------------------------------------
-- Name: Level.OnReadDocs()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.OnReadDocs()
   Level.AddSmallMessage( MissionText.MM_StopMove_DocsClear, 5.0, 175, 175, 175 );

   local job = AI.GetScriptJob("TASK_SCRIPT_READ_DOCS");
   if (job != nil) then
      local npc = Job.GetNPC( job );
      if (npc != nil) then
         AI.HandleVoice(npc, "male_eng_script_script_24");
      end
   end
end

--------------------------------------------------------
-- Name: Level:OnPlayerAction()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level:OnPlayerAction(id)

   if (id == 'SHP1' or id == 'SHP2') then

      -- get show stop move bot...
      local npc = AI.FindNearestNpc(AI.TASK_SHOW_STOP_MOVE, "");
      if (npc == nil) then
         Level.SafeRemoveLevelPlayerAction(id);
         Level.RemoveTimer('PSTM');
         return;
      end

      Level.SafeRemoveLevelPlayerAction(id);

      local properties = Level.CreateCustomParams();

      Level.SetValue(properties, "CustomString_1", "Level.OnReadDocs()" );

      AI.RunScriptTask(npc, "scripts:job\\ReadDocsTask.lua", AI.LOGIC_DEFAULT, properties);

      if (id == 'SHP1') then

         Level.DisableBasementZone();

      elseif (id == 'SHP2') then

         Level.DisableTopFloorsZone();

      end

      local player = Level.GetPlayer();

      if (Actor.GetPickupItem(player) == nil) then 
         Level.PlayerShowDocsAnim();
      else
         Actor.DropPickupItem(player, false);
         Level.InstallDpc("Level.PlayerShowDocsAnim()", 0.8);
      end

      Level.RemoveTimer('PSTM');
   end
end

--------------------------------------------------------
-- Name: Level.PlayerShowDocsAnim()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.PlayerShowDocsAnim()
   Level.StartPlayerCustomAnim("Custom_PassticketShow", 0, true, true);
end

--------------------------------------------------------
-- Name: Level.DisableBasementZone()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.DisableBasementZone()
   AI.EnableZone("Basement_Pass",      false);
   AI.EnableZone("BasementEnter",      false);

   if (Level.SearchJustFinished == false) then
      AI.EnableZone("SearchZone_1",       true);
   end

   Level.AddTimer( 'RBZN', "RestoreBasementZone", 5.0 * 60.0, false );
end

--------------------------------------------------------
-- Name: Level.DisableTopFloorsZone()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.DisableTopFloorsZone()
   AI.EnableZone("TopFloors",      false);
   AI.EnableZone("TopFloorsEnter", false);

   if (Level.SearchJustFinished == false) then
      AI.EnableZone("SearchAlertZone_2",  true);
      AI.EnableZone("SearchZone_2",       true);
   end

   Level.TopFloorsDisabled = true;

   Level.AddTimer( 'RTZN', "RestoreTopFloorsZone", 5.0 * 60.0, false );
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

--------------------------------------------------------
-- Name: Level.OnCookClothChange()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.OnCookClothChange()
  Level.EnableLevelMark('CLTS', false);
  Level.RemoveActionHandler(Level.AH_FINISH_CHANGECLOTH, 'COCL');
end

--------------------------------------------------------
-- Name: Level.OnTechiClothChange()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.OnTechiClothChange()
  local player = Level.GetPlayer();
  if (player != nil) then
    Actor.EnableMesh(player, "mesh_cap", false);
  end
  Level.EnableLevelMark('CLTS', false);
  Level.RemoveActionHandler(Level.AH_FINISH_CHANGECLOTH, 'TCCL');
end

--------------------------------------------------------
-- Name: Level.OnCookTimer()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.OnCookTimer()
    Level.RunAnchorJob( AI.FindNPC('E206'), 'AN42', true );
end

--------------------------------------------------------
-- Name: Level.OnAnchor_SummonCook()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.OnAnchor_SummonCook()
    Level.RunAnchorJob( AI.FindNPC('COOK'), 'MM03', true );
end

--------------------------------------------------------
-- Name: Level.OnAnchor_CookAddress()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.OnAnchor_CookAddress()
    Level.RemoveTimer('CTTR');
    Level.RunAnchorJob( AI.FindNPC('E206'), 'MM04', true );
    Level.VoiceMessage( AI.FindNPC('E206'), "", "Message_SayCook");
    Level.InstallDpc("Level.RunAnchorJob(AI.FindNPC('COOK'), 'MM05', false)", 4.0);
    Level.InstallDpc( "AI.SetJob( AI.FindNPC('COOK'), 'tualet')", 5.5 );
    Level.InstallDpc( "AI.SetJob( AI.FindNPC('E205'), 'dinner')", 6.0 );
end

--------------------------------------------------------
-- Name: Level.OnAnchor_RestartCookTimer()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.OnAnchor_RestartCookTimer()
   Level.AddTimer( 'CTTR', "OnCookTimer", 100, true );
   AI.SetJob(AI.FindNPC('COOK'), "default");
   AI.SetJob(AI.FindNPC('E205'), "default");
end

--------------------------------------------------------
-- Name: Level.RestoreZones_01()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.RestoreZones_01()
    if (AI.GetPlayerForm() == "Civilian") then
       AI.EnableZone("SearchAlertZone_1",  true);
       AI.EnableZone("SearchZone_1",       true);
       Level.SearchJustFinished = false;
    else
       AI.EnableZone("SearchAlertZone_1",  false);
       AI.EnableZone("SearchZone_1",       false);
    end
end

--------------------------------------------------------
-- Name: Level.RestoreZones_02()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.RestoreZones_02()
    if (AI.GetPlayerForm() == "Civilian" and
        Level.TopFloorsDisabled == true) then
       AI.EnableZone("SearchAlertZone_2",  true);
       AI.EnableZone("SearchZone_2",       true);
       Level.SearchJustFinished = false;
    else
       AI.EnableZone("SearchAlertZone_2",  false);
       AI.EnableZone("SearchZone_2",       false);
    end
end

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
  local class = AI.GetClass(npc);

  if (zone == nil) then 
    return;
  end

  if (zone == "Basement_Pass" or
      zone == "BasementEnter") then
    Level.AddSmallMessage(MissionText.MM_StopMove_Pass, 5.0, 175, 175, 175);
    AI.HandleVoice(npc, "male_eng_stopmove_stopmove_06");
    AI.EnableZone("SearchZone_1",       false);
    if (Level.PlayerHasPass() == true) then
      if (Level.HasPlayerAction('SHP1') == false) then
         --Level.AddPlayerAction('SHP1', MissionText.Message_ShowDocs, "Level", false );
         Level.SafeAddLevelPlayerAction('SHP1', MissionText.Message_ShowDocs);
         Level.AddTimer('PSTM', "OnCheckShowPass", 1.0, true );
      end
    end
  elseif (zone == "TopFloors" or
          zone == "TopFloorsEnter") then
    Level.AddSmallMessage(MissionText.MM_StopMove_Pass, 5.0, 175, 175, 175);
    AI.HandleVoice(npc, "male_eng_stopmove_stopmove_06");
    if (Level.PlayerHasPass() == true) then
      if (Level.HasPlayerAction('SHP2') == false) then
         --Level.AddPlayerAction('SHP2', MissionText.Message_ShowDocs, "Level", false );
         Level.SafeAddLevelPlayerAction('SHP2', MissionText.Message_ShowDocs);
         Level.AddTimer('PSTM', "OnCheckShowPass", 1.0, true );
      end
    end
  elseif (zone == "VolkovArea" or
          zone == "Archive03" or
          zone == "Archive04" or
          zone == "StaffLounge") then
    Level.AddSmallMessage(MissionText.MM_StopMove_LeaveRoom, 5.0, 175, 175, 175);
    AI.HandleVoice(npc, "male_eng_stopmove_stopmove_03");
  elseif (zone == "VolkovAreaEnter") then
    Level.AddSmallMessage(MissionText.MM_StopMove_NearVolkov, 5.0, 175, 175, 175);
    AI.HandleVoice(npc, "male_eng_ohers_stop");
  elseif (zone == "VolkovBedroomEnter") then
    Level.AddSmallMessage(MissionText.MM_StopMove_Volkov, 5.0, 175, 175, 175);
    AI.HandleVoice(npc, "male_eng_ohers_stop");
  elseif (zone == "Office" or
          zone == "Office2_1" or
          zone == "Archive01") then
    if (class == "civilian_woman" or
        class == "enemy_woman") then
      Level.AddSmallMessage(MissionText.MM_StopMove_LeaveOffice, 5.0, 175, 175, 175);
      AI.HandleVoice(npc, "female_eng_stopmove_stopmove");
    else
      Level.AddSmallMessage(MissionText.MM_StopMove_Office, 5.0, 175, 175, 175);
      AI.HandleVoice(npc, "male_eng_stopmove_stopmove");
    end
  elseif (zone == "Office2_2") then
    Level.AddSmallMessage(MissionText.MM_StopMove_LeaveOffice, 5.0, 175, 175, 175);
    if (class == "civilian_woman" or
        class == "enemy_woman") then
      AI.HandleVoice(npc, "female_eng_stopmove_stopmove");
    else
      AI.HandleVoice(npc, "male_eng_stopmove_stopmove_03");
    end
  elseif (zone == "Office3") then
    if (npcForm == "Diplomat") then
      Level.AddSmallMessage(MissionText.MM_StopMove_Diplomat, 5.0, 175, 175, 175);
      AI.HandleVoice(npc, "male_eng_stopmove_stopmove");
    elseif (npcForm == "Agent") then
      Level.AddSmallMessage(MissionText.MM_StopMove_LeaveOffice, 5.0, 175, 175, 175);
      AI.HandleVoice(npc, "male_eng_stopmove_stopmove_03");
    elseif (npcForm == "Secretary") then
      Level.AddSmallMessage(MissionText.MM_StopMove_LeaveOffice, 5.0, 175, 175, 175);
      AI.HandleVoice(npc, "female_eng_stopmove_stopmove");
    end
  elseif (zone == "OfficeNear") then
    if (playerForm == "Civilian") then
      Level.AddSmallMessage(MissionText.MM_StopMove_OfficeNear, 5.0, 175, 175, 175);
    else
      Level.AddSmallMessage(MissionText.MM_StopMove_Office, 5.0, 175, 175, 175);
    end
    AI.HandleVoice(npc, "female_eng_stopmove_stopmove");
  elseif (zone == "Office2_1Near" or
          zone == "Office2_2Near") then
    Level.AddSmallMessage(MissionText.MM_StopMove_Office2Near, 5.0, 175, 175, 175);
    AI.HandleVoice(npc, "female_eng_stopmove_stopmove");
  elseif (zone == "Office3Near") then
    Level.AddSmallMessage(MissionText.MM_StopMove_Office3Near, 5.0, 175, 175, 175);
    AI.HandleVoice(npc, "female_eng_stopmove_stopmove");
  elseif (zone == "Archive02") then
    if (npcForm == "Plumber") then
      Level.AddSmallMessage(MissionText.MM_StopMove_ArchiveClean, 5.0, 175, 175, 175);
      AI.HandleVoice(npc, "male_eng_stopmove_stopmove_09");
    elseif (npcForm == "Soldier") then
      Level.AddSmallMessage(MissionText.MM_StopMove_LeaveRoom, 5.0, 175, 175, 175);
      AI.HandleVoice(npc, "male_eng_stopmove_stopmove_03");
    end
  elseif (zone == "ConfRoom") then
    if (npcForm == "Agent") then
      Level.AddSmallMessage(MissionText.MM_StopMove_ConfRoom, 5.0, 175, 175, 175);
      AI.HandleVoice(npc, "male_eng_stopmove_stopmove_09");
    elseif (npcForm == "Soldier" or
            npcForm == "Guardian2") then
      Level.AddSmallMessage(MissionText.MM_StopMove_ConfRoom, 5.0, 175, 175, 175);
      AI.HandleVoice(npc, "male_eng_stopmove_stopmove_03");
    end
  elseif (zone == "ConfRoomEnter") then
    Level.AddSmallMessage(MissionText.MM_StopMove_ConfRoom, 5.0, 175, 175, 175);
    AI.HandleVoice(npc, "male_eng_ohers_stop");
  elseif (zone == "StaffLoungeEnter") then
    Level.AddSmallMessage(MissionText.MM_StopMove_StaffLounge, 5.0, 175, 175, 175);
    AI.HandleVoice(npc, "male_eng_ohers_stop");
  elseif (zone == "Kitchen") then
    Level.AddSmallMessage(MissionText.MM_StopMove_Kitchen, 5.0, 175, 175, 175);
    AI.HandleVoice(npc, "male_eng_stopmove_stopmove_09");
  elseif (zone == "TualetWomen") then
    if (class == "civilian_woman" or
        class == "enemy_woman") then
      Level.AddSmallMessage(MissionText.MM_StopMove_Tualet, 5.0, 175, 175, 175);
      AI.HandleVoice(npc, "female_eng_stopmove_stopmove_02");
    else
      Level.AddSmallMessage(MissionText.MM_StopMove_TualetWomen, 5.0, 175, 175, 175);
      AI.HandleVoice(npc, "male_eng_stopmove_stopmove_03");
    end
  elseif (zone == "SearchZone_1") then
    local playerPosition = Level.GetPlayerPosition();
    local npcPosition = Level.GetNpcPosition(npc);
    Level.SearchZoneName = zone;
    Level.AddSmallMessage( MissionText.MM_StopMove_Search, 5.0, 175, 175, 175 );
    Level.InitSearchScript(npc);
    Level.HadForbidObjects = Level.HasForbidObjects();
  elseif (zone == "SearchZone_2") then
    local playerPosition = Level.GetPlayerPosition();
    local npcPosition = Level.GetNpcPosition(npc);
    Level.SearchZoneName = zone;
    Level.AddSmallMessage( MissionText.MM_StopMove_Search, 5.0, 175, 175, 175 );
    Level.InitSearch2Script(npc);
    Level.HadForbidObjects = Level.HasForbidObjects();
  end
end

--------------------------------------------------------
-- Name: Level.OnChangeMadamJobTrigger()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.OnTrigger_ChangeMadamJob()
   Level.InstallDpc("Level.ChangeMadamJob()", 10.0);
end

--------------------------------------------------------
-- Name: Level.ChangeMadamJob()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.ChangeMadamJob()
   AI.SetJob(AI.FindNPC('M205'), "job_new");
end

--------------------------------------------------------
-- Name: Level.OnKilledCook()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.OnKilledCook()
   Level.RemoveTimer('CTTR');
   AI.SetJob(AI.FindNPC('E205'), "default2");
end

--------------------------------------------------------
-- Name: Level.OnChangePashJobsTrigger()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.OnTrigger_ChangePashJobs()
   Level.EnableLevelMark('PASH', false);
   Level.InstallDpc("Level.ChangePashJobs()", 5.0);
end

--------------------------------------------------------
-- Name: Level.ChangePashJobs()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.ChangePashJobs()
   AI.SetJob(AI.FindNPC('E235'), "post_pash");
   AI.SetJob(AI.FindNPC('M227'), "post_pash");
end
