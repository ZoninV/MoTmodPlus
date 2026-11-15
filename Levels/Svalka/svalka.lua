
  MissionText = 
  {
      --Mission text
      Task_1                = " Установить динамит";
      Task_2                = " Установить динамит";
      Task_3                = " Нейтрализовать снайперов";
      Task_4                = " Покинуть местность";

      Message_DynSetuped    = "Динамит установлен";
      Message_TaskChanged   = "Задания обновлены";
      Message_Sniper        = "Вас обнаружил вражеский снайпер.";
      Message_SniperLost    = "Снайпер потерял вас из виду.";
      Message_KillSniper    = "Снайпер нейтрализован";
      Message_OrderWorker   = "ОТДАТЬ НОВЫЙ ПРИКАЗ";
      Message_SetupDynamite = "УСТ. ДИНАМИТ";
      Message_NoDynamite    = "У вас нету динамита.";

      Message_MechanicHint  = "Старший механик может отдавать приказы рабочим.";

      Message_Alarm         = "Поднята тревога. Охрана стала более внимательна.";
      Message_AlarmFinished = "Охрана успокоилась.";
      Message_Escape        = "У вас осталось %02d:%02d времени, чтобы покинуть местность";

      -- Liz Shaw
      MM_StopMove_FGS = "@ Полевой жандармерии здесь не место!";
      MM_StopMove_Tower = "@ Вам здесь нечего делать!";
      MM_StopMove_Building = "@ Сюда допускаются только связисты!";
      MM_StopMove_Ladder = "@ Пользоваться лестницами могут только механики!";
  };
     
  function Level.OnCompleteMission()

      System:ConsoleCommand( 'l_loadlevel "rolik_bridge" 1' );

  end;

  function Level.OnSave()

      Stream.WriteBool( Level.DynamiteFused[1] );
      Stream.WriteBool( Level.DynamiteFused[2] );
      Stream.WriteBool( Level.DynamiteFused[3] );
      Stream.WriteBool( Level.DynamiteFused[4] );
      Stream.WriteBool( Level.DynamiteFused[5] );
      Stream.WriteBool( Level.DynamiteFused[6] );

      Stream.WriteInt( Level.SniperTimer );
      Stream.WriteBool( Level.SniperNotice );

      Stream.WriteBool( Level.SniperComplete );
      Stream.WriteInt( Level.SniperKilled );

      Stream.WriteString( Level.OrderWorkerTriggerName ); -- Liz Shaw
      Stream.WriteBool  ( Level.KilledWorker ); -- Liz Shaw

      for i = 1, 8 do
          Stream.WriteBool( Level.SniperKilledList[i] );
      end
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

  function Level.OnLoad()

      Level.DynamiteFused={};

      Level.DynamiteFused[1] = Stream.ReadBool();
      Level.DynamiteFused[2] = Stream.ReadBool();
      Level.DynamiteFused[3] = Stream.ReadBool();
      Level.DynamiteFused[4] = Stream.ReadBool();
      Level.DynamiteFused[5] = Stream.ReadBool();
      Level.DynamiteFused[6] = Stream.ReadBool();

      Level.SniperTimer      = Stream.ReadInt();
      Level.SniperNotice     = Stream.ReadBool();

      Level.SniperComplete   = Stream.ReadBool();
      Level.SniperKilled     = Stream.ReadInt();

      Level.OrderWorkerTriggerName = Stream.ReadString(); -- Liz Shaw
      Level.KilledWorker     = Stream.ReadBool(); -- Liz Shaw

      Level.SniperKilledList = {};
      for i = 1, 8 do
          Level.SniperKilledList[i] = Stream.ReadBool( );
      end

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
     System:SaveGame( "_svalka_" .. tostring(nextSlot) .. ".asv" , false );
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

     System:LoadGame( "_svalka_" .. tostring(slot) .. ".asv" , true );

     return true;

  end;

  function Level.OnFinishLoad()

      -- forlik System:SetVar( "r_glow", true );
      -- forlik System:SetVar( "r_glow_r", 2.0 );
      -- forlik System:SetVar( "r_glow_b", 230 );
      System:SetVar( "r_farclip" , 8192 ); -- Wunder
      Level.OnFinishLoad_Common(); -- forlik
      Level.SetDOFPostFilter( 1, 0.0, 1600.0, 3500.0 ); --forlik
      System:SetVar( "r_dofsky", 128 ); --forlik
      System:SetVar( "r_shadowmapboxf" , 2.0 );
      System:SetVar( "ph_water_density", 0.08);
      System:SetVar( "ph_water_wet_time", 17.0);

      Level.DynamiteTrigger = nil;

      Level.AddWaterZone( -467.1, -109.5, -522.1, 494.1, -29.5, 477.9 );

      --- init music

--      Level.AddMusic( Level.MUSIC_MOOD_ATTENTION  , "sounds\\music\\danger.ogg" );
--      Level.AddMusic( Level.MUSIC_MOOD_ACTION, "sounds\\music\\action_3.ogg"  );

      Level.AddMusic( Level.MUSIC_MOOD_DEFAULT, "#0.50#sounds\\music\\b_dark3.ogg");
      Level.AddMusic( Level.MUSIC_MOOD_ATTENTION   , "#0.50#sounds\\music\\action_2.ogg");
      Level.AddMusic( Level.MUSIC_MOOD_ACTION, "#0.50#sounds\\music\\b_action2.ogg" );

      -- patch
      local backpack = Level.FindContainer();
      if (backpack != nil) then
          Level.EnableItemPickup(backpack, true);
      end

     --Liz Shaw
     Entity.SetSkin(Level.FindVehicle('BMW1'), 1);
     Entity.SetSkin(Level.FindVehicle('BMW2'), 6);
     Entity.SetSkin(Level.FindVehicle('BMW3'), 1);
     Entity.SetSkin(Level.FindVehicle('BMW4'), 7);
     Entity.SetSkin(Level.FindVehicle('KB01'), 3);
  end;

  function Level.OnLoaded()

      Level.OnLoaded_Common(); -- forlik
      Level.AddMissionTask( MissionText.Task_3, 'SNPR', "levels\\svalka\\sniper_task.txt" );
      Level.AddMissionTask( MissionText.Task_1, 'DYN1', "levels\\svalka\\dyn_1_task.txt" );

      Level.AddActionHandler( Level.AH_DYNAMITE_FUSE );

      Level.AddActionHandler( Level.AH_ACTOR_KILLED , "SNP1" , "OnKillSniper_1");
      Level.AddActionHandler( Level.AH_ACTOR_KILLED , "SNP2" , "OnKillSniper_2");
      Level.AddActionHandler( Level.AH_ACTOR_KILLED , "SNP3" , "OnKillSniper_3");
      Level.AddActionHandler( Level.AH_ACTOR_KILLED , "SNP4" , "OnKillSniper_4");
      Level.AddActionHandler( Level.AH_ACTOR_KILLED , "SNP5" , "OnKillSniper_5");
      Level.AddActionHandler( Level.AH_ACTOR_KILLED , "SNP6" , "OnKillSniper_6");
      Level.AddActionHandler( Level.AH_ACTOR_KILLED , "SNP7" , "OnKillSniper_7");
      Level.AddActionHandler( Level.AH_ACTOR_KILLED , "SNP8" , "OnKillSniper_8");

      Level.AddActionHandler( Level.AH_ACTOR_HITTED , "SNP1" , "OnKillSniper_1");
      Level.AddActionHandler( Level.AH_ACTOR_HITTED , "SNP2" , "OnKillSniper_2");
      Level.AddActionHandler( Level.AH_ACTOR_HITTED , "SNP3" , "OnKillSniper_3");
      Level.AddActionHandler( Level.AH_ACTOR_HITTED , "SNP4" , "OnKillSniper_4");
      Level.AddActionHandler( Level.AH_ACTOR_HITTED , "SNP5" , "OnKillSniper_5");
      Level.AddActionHandler( Level.AH_ACTOR_HITTED , "SNP6" , "OnKillSniper_6");
      Level.AddActionHandler( Level.AH_ACTOR_HITTED , "SNP7" , "OnKillSniper_7");
      Level.AddActionHandler( Level.AH_ACTOR_HITTED , "SNP8" , "OnKillSniper_8");

      Level.AddActionHandler( Level.AH_ENTER_VEHICLE , "BMW3" , "OnBike1Enter");
      Level.AddActionHandler( Level.AH_ENTER_VEHICLE , "BMW4" , "OnBike2Enter");

      Level.AddActionHandler( Level.AH_ACTOR_KILLED , "GS80" , "OnKilledWorker" );
      Level.AddActionHandler( Level.AH_ACTOR_HITTED , "GS80" , "OnKilledWorker" );
      Level.AddActionHandler( Level.AH_FINISH_CHANGECLOTH , "HNCL" , "OnRadistClothChange");

      Actor.MarkAsTarget( Level.FindActor( 'SNP1' ) , true );
      Actor.MarkAsTarget( Level.FindActor( 'SNP2' ) , true );
      Actor.MarkAsTarget( Level.FindActor( 'SNP3' ) , true );
      Actor.MarkAsTarget( Level.FindActor( 'SNP4' ) , true );
      Actor.MarkAsTarget( Level.FindActor( 'SNP5' ) , true );
      Actor.MarkAsTarget( Level.FindActor( 'SNP6' ) , true );
      Actor.MarkAsTarget( Level.FindActor( 'SNP7' ) , true );
      Actor.MarkAsTarget( Level.FindActor( 'SNP8' ) , true );

      Level.EnableLevelMark( 'DYN1', true );
      Level.EnableLevelMark( 'DYN2', true );
      Level.EnableLevelMark( 'DYN3', true );
      Level.EnableLevelMark( 'DYN4', true );
      Level.EnableLevelMark( 'DYN5', true );

      local dynMarks = { 'DYN1' , 'DYN2', 'DYN3' , 'DYN4' , 'DYN5', 'PYN4', 'PYN1', 'PYN5' };

      for i = 1, 8, 1 do
         local dynamite = Level.FindWeaponItem( dynMarks[i] );
         if ( dynamite != nil ) then
              Level.EnableItemPickup( dynamite, false );
         end;
      end;

      Level.DynamiteFused={};

      Level.DynamiteFused[1] = false;
      Level.DynamiteFused[2] = false;
      Level.DynamiteFused[3] = false;
      Level.DynamiteFused[4] = false;
      Level.DynamiteFused[5] = false;
      Level.DynamiteFused[6] = false;

      Level.OrderWorkerTriggerName = ""; -- Liz Shaw
      Level.KilledWorker = false; -- Liz Shaw

      Level.SniperTimer      = 0;
      Level.SniperNotice     = false;
      Level.SniperComplete   = false;
      Level.SniperKilled     = 0;
      Level.SniperKilledList = {};
      for i = 1, 8 do
         Level.SniperKilledList[i] = false;
      end

      if (Level.GetDifficulty() != 3) then
        AI.SetJob(AI.FindNPC('G124'), "clean");
      end;

      local diff = Level.GetDifficulty();
      if (diff == 1 or
          diff == 2) then

          Level.EnableLevelMark('ORDR', true);
      end;

      local diff = Level.GetDifficulty();
      if (diff == 2) then

          AI.SetForm(AI.FindNPC('MM90'), "HPSB");
      end;

      local player     = Level.FindActor('PLYR');
      if ( player != nil ) then

       Actor.ChangeActorSkin( player, "Summer" ); -- forlik
       if ( Level.HasPlayerEquipPack() == false ) then

         local machineGun = Level.CreateItem("mosincamo","Weapon");
         local pistol     = Level.CreateItem("NaganSilencer","Weapon");
         local knife      = Level.CreateItem("knife","Weapon");

         Actor.PutWeapon( player, Actor.WEAPON_SLOT_PISTOL , pistol );
         Actor.PutWeapon( player, Actor.WEAPON_SLOT_MACHINEGUN, machineGun );
         Actor.PutWeapon( player, Actor.WEAPON_SLOT_KNIFE, knife );

         Actor.PutWeaponAmmo( player, "mosin");
         Actor.PutWeaponAmmo( player, "nagan");
         Actor.PutWeaponAmmo( player, "nagan");
         Actor.PutWeaponAmmo( player, "nagan");

         Actor.PutEmptyPouch( player, "fiberwire", "Weapon" );
         Actor.PutEmptyPouch( player, "medikit", "Equipment" );

         Actor.PutEmptyPouch( player, "f1", "Weapon" );
         Actor.PutEmptyPouch( player, "f1", "Weapon" );
         Actor.PutEmptyPouch( player, "f1", "Weapon" );

         Actor.PutEmptyPouch( player, "Smoke", "Weapon" );

         Actor.PutEmptyPouch( player, "binocular", "Equipment" );
         Actor.PutEmptyPouch( player, "lockpick", "Equipment" );

         local pack = Level.CreateItem( "playersack", "container" );
         if ( pack == nil ) 
           then
            error('Failed create player pack');
           end;

         Actor.PutBackPack( player, pack );

         ItemPack.AddItem( pack, Level.CreateItem( "pmd6", "Weapon" ) );
         ItemPack.AddItem( pack, Level.CreateItem( "pmk40", "Weapon" ) );

         ItemPack.AddItem( pack, Level.CreateItem( "dynamite", "Weapon" ) );
       end;

      end;

      Level.ChangePlayerStand( 2 );

      -- Liz Shaw
      Level.EnableVehicleUse( 'BMW1', false );
      Level.EnableVehicleUse( 'KB01', false );

--[950.151917 84.409241 100.326996] -> [994.869385 197.546158 117.195946]
      AI.AddHideBodyBox(-1005.0, 176.0,  102.0, -798.0, 224.0,  219.0);
      AI.AddHideBodyBox(-1005.0, 176.0, -217.0, -798.0, 224.0, -101.0);

      AI.AddHideBodyBox(  816.0, 176.0, -217.0, 1022.0, 224.0, -101.0);
      AI.AddHideBodyBox(  816.0, 176.0,  102.0, 1022.0, 224.0,  219.0);

      AI.AddHideBodyBox( -543.0, 221.0, -202.0, -462.0, 245.0, -97.0);
      AI.AddHideBodyBox( -543.0, 221.0,   96.0, -462.0, 245.0, 201.0);
      AI.AddHideBodyBox(  472.0, 221.0, -202.0,  554.0, 245.0, -97.0);
      AI.AddHideBodyBox(  472.0, 221.0,   96.0,  554.0, 245.0, 201.0);

      if (Level.GetDifficulty() == 0) then
         Level.SetupEasy();
      end

      AI.OnPlayerEnterZone("global", 'GLSC'); -- forlik
      Level.OnFinishLoad();
     Level.AutoSave();

  end;

  AI.DoFile( "scripts:Levels\\Common.lua", false ); -- forlik

  function Level.CompleteSniperTask()

     if ( Level.SniperComplete == true ) then
        return; 
     end;

     if ( Level.IsMissionFailed() != false ) then
       return;
     end;

     Level.AddMissionTask( MissionText.Task_2, 'DYN2', "levels\\svalka\\dyn_2_task.txt" );
     Level.AddMissionTask( MissionText.Task_4, 'LEAV', "levels\\svalka\\leave_task.txt" );

     Level.PlayMenuSound("task_finish"); -- Liz Shaw
     Level.CompleteMissionTask( 'SNPR', 15.0 );
     Level.AddLargeMessage( MissionText.Message_TaskChanged, 15.0, 255, 255, 255 );
 
     Level.SniperComplete = true;

     Level.EnableLevelMark( 'DYN6', true );

     Level.EnableLevelMark( 'LEAV', true );
     Level.EnableLevelMark( 'LEA2', true );
     Level.EnableLevelMark( 'LEA3', true );
     Level.EnableLevelMark( 'LEA4', true );
     Level.EnableLevelMark( 'LEA5', true );
     Level.EnableLevelMark( 'LEA6', true );
     Level.EnableLevelMark( 'LEA7', true );

     local dyn6 = Level.CreateWorldItem( "DynamiteFake", "Weapon" , 19.76663, 259.81348, -12.18138, 0.0, 90.0, 0.0, 'DYN6' );

     if ( dyn6 != nil ) then
         Level.EnableItemPickup( dyn6, false );
     end;

     local pyn6 = Level.CreateWorldItem( "DynamiteFake", "Weapon" , 19.76663, 259.81348, 12.59297, 0.0, 90.0, 0.0, 'PYN6' );

     if ( pyn6 != nil ) then
         Level.EnableItemPickup( pyn6, false );
     end;

     Level.AutoSave();

  end;

  function Level.OnSniperCheck()

      if ( Level.IsPlayerOutdoor() == false or Level.SniperComplete == true ) then
         Level.SniperTimer = Level.SniperTimer + 1;

         if ( Level.SniperTimer >= 4 or Level.SniperComplete == true ) then

              Level.SniperNotice = false;
              Level.AddSmallMessage( MissionText.Message_SniperLost, 10.0, 255, 255, 0 );
              Level.RemoveTimer( 'SNPR' );

         end;

         return;

      end;
      
      Level.RemoveTimer( 'SNPR' );
      Level.KillPlayer();

  end;

  function Level.OnSniperNotice()

      if ( Level.SniperNotice == true ) then
           return;
      end;

      Level.AddSmallMessage( MissionText.Message_Sniper, 10.0, 255, 0, 0 );
      Level.AddTimer( 'SNPR', "OnSniperCheck", 5.0, true );

      Level.SniperTimer  = 0;
      Level.SniperNotice = true;
  end;

  function Level.OnFinishMessageTimer()

    Level.KillPlayer();

  end;

  function Level.OnSetupDynamite()

     if ( Level.DynamiteTrigger != nil ) then

        local dynNumber = Trigger.GetUniqueIdAsNumber( Level.DynamiteTrigger );

        if ( dynNumber == nil or Level.DynamiteFused[dynNumber] != false ) then
           Level.UnregisterTrigger( Level.DynamiteTrigger );

           Level.DynamiteTrigger = nil;
           Level.RemovePlayerAction("SDYN");

           return false,false;
        end;

        return true,false;

     else

        return true,true;

     end;

  end;

  function Level.OnDynamiteFused( dynamite )

     if ( Level.SniperComplete != true and 
          dynamite == 6 ) then
         return;
     end;

     if ( Level.IsMissionFailed() != false ) then
       return;
     end;

     if ( Level.DynamiteTrigger != nil ) then

        Level.EnableItemPickup( dynamite, false );

        local dynNumber = Trigger.GetUniqueIdAsNumber( Level.DynamiteTrigger );

        Level.DynamiteFused[dynNumber] = true;

        local saveCheckpoint = false;
        if ( dynNumber == 6 ) then
          Level.PlayMenuSound("task_finish"); -- Liz Shaw
          Level.CompleteMissionTask( 'DYN2', 15.0 );
          saveCheckpoint = true;
        else

          local completed = true;

          for i = 1, 5, 1 do
           if ( Level.DynamiteFused[i] == false ) then
              completed = false;
              break;
           end;
          end

          if ( completed == true ) then
             --Level.AddMissionTask( MissionText.Task_2, 'DYN2', "levels\\svalka\\dyn_2_task.txt" );
             Level.PlayMenuSound("task_finish"); -- Liz Shaw
             Level.CompleteMissionTask('DYN1', 15.0 );
             --Level.AddLargeMessage( MissionText.TaskChanged, 15.0, 255, 255, 255 );
             saveCheckpoint = true;
          end;
  
        end;

        if ( Level.IsMissionTaskCompleted('DYN1') and Level.IsMissionTaskCompleted('DYN2') ) then
            Level.EnableLevelMark( 'LEVV', true );
            Level.EnableLevelMark( 'LEV2', true );
            Level.EnableLevelMark( 'LEV3', true );
            Level.EnableLevelMark( 'LEV4', true );
            Level.EnableLevelMark( 'LEV5', true );
            Level.EnableLevelMark( 'LEV6', true );
            Level.EnableLevelMark( 'LEV7', true );

            if ( dynNumber == 6 ) then
               Level.StartMessageTimer( MissionText.Message_Escape, 150.0, 255, 255, 255 );
            else
               Level.StartMessageTimer( MissionText.Message_Escape, 120.0, 255, 255, 255 );
            end;
        end;

        local mark = Trigger.GetScriptCmd( Level.DynamiteTrigger );

        Level.EnableLevelMark( mark , false );
        Level.AddLargeMessage( MissionText.Message_DynSetuped, 10.0, 255, 255, 255 );

        local dynamiteMark = Level.FindWeaponItem( mark );
        if ( dynamiteMark != nil ) then
             Level.DeleteItem( dynamiteMark ); 
        end;

        local dupMark = nil;

        if ( mark == 'DYN5' ) then 
              dupMark = 'PYN5';
        elseif ( mark == 'DYN1' ) then
              dupMark = 'PYN1';
        elseif ( mark == 'DYN4' ) then
              dupMark = 'PYN4';
        elseif ( mark == 'DYN6' ) then
              dupMark = 'PYN6';  
        end;

        if ( dupMark != nil ) then
            local entityMark = Level.FindWeaponItem( dupMark );
            if ( entityMark != nil ) then
               Level.DeleteItem( entityMark );
            end;
        end;

        Level.UnregisterTrigger( Level.DynamiteTrigger );
        Level.DynamiteTrigger = nil;
        Level.RemovePlayerAction("SDYN");
        if ( saveCheckpoint == true ) then
            Level.AutoSave();
        end;

     end;

  end;

  function Level.OnKillSniper( markId )

      if ( Level.SniperComplete == true ) then
           return; 
      end;

      if (Level.SniperKilledList[markId] == true) then
         return;
      end

      Level.SniperKilledList[markId] = true;

      if ( Level.IsMissionFailed() != false ) then
          return;
      end;

      Level.SniperKilled = Level.SniperKilled + 1;

      Level.AddLargeMessage( MissionText.Message_KillSniper, 10.0, 255, 255, 255 );
      Level.EnableLevelMark( markId, false );

      if ( Level.SniperKilled < 8 ) then
          return;
      end;

      Level.CompleteSniperTask();      

  end;

  function Level.OnKillSniper_1()
      Level.OnKillSniper( 'SNP1' );
  end;

  function Level.OnKillSniper_2()
      Level.OnKillSniper( 'SNP2' );
  end;

  function Level.OnKillSniper_3()
      Level.OnKillSniper( 'SNP3' );
  end;

  function Level.OnKillSniper_4()
      Level.OnKillSniper( 'SNP4' );
  end;

  function Level.OnKillSniper_5()
      Level.OnKillSniper( 'SNP5' );
  end;

  function Level.OnKillSniper_6()
      Level.OnKillSniper( 'SNP6' );
  end;

  function Level.OnKillSniper_7()
      Level.OnKillSniper( 'SNP7' );
  end;

  function Level.OnKillSniper_8()
      Level.OnKillSniper( 'SNP8' );
  end;

  function Level.OnEnterTriggerArea( sender, trgname, trgcmd )

    if ( Level.IsMissionFailed() != false ) then
      return;
    end;

    if ( trgname == 'LeaveTrigger' or 
         trgname == 'LeaveTrigger01' or
         trgname == 'LeaveTrigger02' or
         trgname == 'LeaveTrigger03' ) then

       if ( Level.SniperComplete == true and
            Level.IsMissionTaskCompleted('DYN1') and
            Level.IsMissionTaskCompleted('DYN2') ) then

             Level.PlayMenuSound("task_finish"); -- Liz Shaw
             Level.CompleteMissionTask('LEAV', 15.0 );

       end;

    elseif ( trgname == 'SniperTrigger' ) then

       if ( Level.SniperComplete == false ) then
             Level.OnSniperNotice();
       end;

    elseif ( trgname == 'MechanicHintTrigger') then

       if ( (Level.GetDifficulty() == 1) and
            (AI.GetPlayerForm() != "HMO1") and
            AI.IsDefault(AI.FindNPC('GS80')) ) then
         Level.AddSmallMessage( MissionText.Message_MechanicHint, 15.0 , 255, 255, 255 );
         Actor.MarkAsTarget( Level.FindActor( 'GO01' ) , true );
         Actor.MarkAsTarget( Level.FindActor( 'G105' ) , true );
         Actor.MarkAsTarget( Level.FindActor( 'MM01' ) , true );
         Actor.MarkAsTarget( Level.FindActor( 'GS73' ) , true );

       else

           if ( (Level.GetDifficulty() == 2) and
                (AI.GetPlayerForm() != "HMO1") and
                AI.IsDefault(AI.FindNPC('GS80')) ) then
                Level.AddSmallMessage( MissionText.Message_MechanicHint, 15.0 , 255, 255, 255 );
                Actor.MarkAsTarget( Level.FindActor( 'GO01' ) , true );
                Actor.MarkAsTarget( Level.FindActor( 'G105' ) , true );
                Actor.MarkAsTarget( Level.FindActor( 'MM01' ) , true );
                Actor.MarkAsTarget( Level.FindActor( 'GS73' ) , true );
           end;
       end;

    elseif ( trgname == 'DynShow' ) then

        --Level.EnableLevelMark( trgcmd, false );

    end;

  end;

  function Level.OnLeaveTriggerArea( sender, trgname, trgcmd )

  end;

  function Level.OnFinishAlert( alertGroupId )

    AI.Debug(nil, "Level.OnFinishAlert", "group", alertGroupId);

    AI.SetLocalAlert(alertGroupId, false);

    if (AI.IsLocalAlert(2) == false and
        AI.IsLocalAlert(3) == false and
        AI.IsLocalAlert(4) == false and
        AI.IsLocalAlert(5) == false and
        AI.IsLocalAlert(6) == false and
        AI.IsLocalAlert(7) == false and
        AI.IsLocalAlert(8) == false) then

        Level.AddSmallMessage( MissionText.Message_AlarmFinished, 10.0, 255, 255, 0);
        Level.EnableAlarmSound(false);

    end

  end

  function Level.OnAlert( alertGroupId )

    AI.Debug(nil, "Level.OnAlert", "group", alertGroupId);

    AI.SetLocalAlert(2, true, AI.TransformAlertTime(400));
    AI.SetLocalAlert(3, true, AI.TransformAlertTime(400));
    AI.SetLocalAlert(4, true, AI.TransformAlertTime(400));
    AI.SetLocalAlert(5, true, AI.TransformAlertTime(400));
    AI.SetLocalAlert(6, true, AI.TransformAlertTime(400));
    AI.SetLocalAlert(7, true, AI.TransformAlertTime(400));
    AI.SetLocalAlert(8, true, AI.TransformAlertTime(400));

    Level.AddSmallMessage( MissionText.Message_Alarm, 10.0, 255, 0, 0);
    Level.EnableAlarmSound(true);
    AI.AddAlertValue(1);

  end

  function Level.StartCustomAnimationJob( botUID, anim, posX, posY, posZ, dirX, dirY, dirZ )
    local bot = AI.FindNPC(botUID);
    if (bot != nil) then
     local properties = Level.CreateCustomParams();
     Level.SetValue(properties, "Return spawn place", true);
     Level.SetValue(properties, "Animation name", anim);
     Level.SetValue(properties, "Can Patrol Point", false);
     Level.SetValue(properties, "Can Smoke", false);
     Level.SetValue(properties, "Can Speak", false);
     Level.SetValue(properties, "Restore spawn direction", true);
     Level.SetValue(properties, "Return place noise", 0.0);
     Level.SetValue(properties, "Can use anchors", false);
     Level.SetValue(properties, "Spawn place return limit", 0.0);
     Level.SetValue(properties, "Ignore attention", false);

     Level.SetValue(properties, "Position", posX, posY, posZ);
     Level.SetValue(properties, "Direction", dirX, dirY, dirZ);
     AI.Idle( bot, properties );
    else
     print("Warning. Can't find npc " .. botUID);
    end
  end

  function Level.SetupEasy()
    -- Liz Shaw Level.StartCustomAnimationJob('GS80', "Act_ProjectY_WatchDevice", 22.0, 67.0, -101.0, 0.0, 0.0, -1.0);
    Level.StartCustomAnimationJob('GS80', "Act_ProjectY_WatchDevice", 22.0, 65.9, -101.0, 0.0, 0.0, -1.0);
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

  if (zone == "mmZoneA1" or
      zone == "mmZoneB1" or
      zone == "mmZoneC1") then
    if (playerForm == "FGS1" or
        playerForm == "FGO1") then
      Level.AddSmallMessage(MissionText.MM_StopMove_FGS, 5.0, 175, 175, 175);
    end
    AI.HandleVoice(npc, "male_ger_stopmove_stopmove_18");
  elseif (zone == "mmZoneD1") then
    if (playerForm == "FGS1" or
        playerForm == "FGO1") then
      Level.AddSmallMessage(MissionText.MM_StopMove_FGS, 5.0, 175, 175, 175);
    else
      Level.AddSmallMessage(MissionText.MM_StopMove_Building, 5.0, 175, 175, 175);
    end
    AI.HandleVoice(npc, "male_ger_stopmove_stopmove_18");
  elseif (zone == "mmZoneL1") then
    Level.AddSmallMessage(MissionText.MM_StopMove_Ladder, 5.0, 175, 175, 175);
    AI.HandleVoice(npc, "male_ger_stopmove_stopmove_08");
  elseif (zone == "mmZoneT1") then
    Level.AddSmallMessage(MissionText.MM_StopMove_Tower, 5.0, 175, 175, 175);
    AI.HandleVoice(npc, "male_ger_stopmove_stopmove_19");
  end
end

--------------------------------------------------------
-- Name: Level.OnRadistClothChange()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.OnRadistClothChange()
  local player = Level.GetPlayer();
  if (player != nil) then
    Actor.EnableMesh(player, "sabg_equipment_up", false);
    Actor.EnableMesh(player, "sabg_equipment_down", false);
    Actor.EnableMesh(player, "mesh_helmet", false);
  end
end

--------------------------------------------------------
-- Name: Level.OnKilledWorker()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.OnKilledWorker()
   Level.KilledWorker = true;
   Level.EnableLevelMark('ORDR', false);
   Actor.MarkAsTarget( Level.FindActor( 'GO01' ) , false );
   Actor.MarkAsTarget( Level.FindActor( 'G105' ) , false );
   Actor.MarkAsTarget( Level.FindActor( 'MM01' ) , false );
   Actor.MarkAsTarget( Level.FindActor( 'GS73' ) , false );
end

--------------------------------------------------------
-- Name: Level.UninstallOrderWorkerTask()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.UninstallOrderWorkerTask()
   if (Level.HasPlayerAction('ORDR') != false) then
       Level.RemovePlayerAction('ORDR');
   end

   Level.EnableLevelMark('ORDR', false);
   Actor.MarkAsTarget( Level.FindActor( 'GO01' ) , false );
   Actor.MarkAsTarget( Level.FindActor( 'G105' ) , false );
   Actor.MarkAsTarget( Level.FindActor( 'MM01' ) , false );
   Actor.MarkAsTarget( Level.FindActor( 'GS73' ) , false );
   Level.UnregisterTrigger( Level.FindTrigger( 'MechanicHintTrigger' ) );
end

----------------------------------------------------------
-- Name: Level.OnBike1Enter()
-- MoTmod Addon
-- Liz Shaw
----------------------------------------------------------
function Level.OnBike1Enter()
  local mm15 = AI.FindNPC('MM15');
  local mm16 = AI.FindNPC('MM16');
  local mm17 = AI.FindNPC('MM17');
  if (mm15 != nil) then
    AI.SetDecamouflageLevel(AI.AI_TARGET_UID, "MM15", Actor.ACTOR_TYPE_OFFICER);
  end
  if (mm16 != nil) then
    AI.SetDecamouflageLevel(AI.AI_TARGET_UID, "MM16", Actor.ACTOR_TYPE_OFFICER);
    AI.HandleVoice(mm16, "male_ger_ohers_postoroniy");
  end
  if (mm17 != nil) then
    AI.SetDecamouflageLevel(AI.AI_TARGET_UID, "MM17", Actor.ACTOR_TYPE_OFFICER);
  end
end

--------------------------------------------------------
-- Name: Level.OnBike2Enter()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.OnBike2Enter()
  local diff = Level.GetDifficulty();
  if (diff == 0 or
      diff == 1) then

     local unteroffizier = AI.FindNPC('MM90');
     if (unteroffizier != nil) then
       AI.SetDecamouflageLevel(AI.AI_TARGET_UID, "MM90", Actor.ACTOR_TYPE_OFFICER);
     end
  end
end
