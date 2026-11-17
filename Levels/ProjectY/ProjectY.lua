
  MissionText = 
  {
      --Mission text
      Task_1                = " Переснять чертежи";
      Task_2                = " Достать документы";
      Task_3                = " Покинуть здание";
      Fail_Cris             = "Полковник Скот Бэкер убит";
      Fail_Prof             = "Профессор Чарльз Браун убит";
      Message_Foto          = "СФОТОГРАФИРОВАТЬ";
      Foto_Made             = "Чертеж сфотографирован";
      Foto_Fail             = "Чертеж заснят не полностью";
      Message_2             = "Задания обновлены";
      Message_Docs          = "ВЗЯТЬ ДОКУМЕНТЫ";
      Message_DisableAlert  = "ОТКЛЮЧИТЬ ТРЕВОГУ";
      Message_3             = "Задания изменены";
      Key_Name_1            = "Ключ от сейфа в лаборатории";
      Key_Name_2            = "Ключ от сейфа в кабинете полковника";
      Key_Name_3            = "Key to the conference room";
      Message_PassName      = "Удостоверение ученого";
      Message_PassNameL     = "УДОСТОВЕРЕНИЕ УЧЕНОГО";
      Message_Pass2Name     = "Допуск от Полковника Бэкера";
      Alarm_Timer           = "Поднята тревога. У вас осталось %02d:%02d на выполнение задания до того как все выходы из здания будут заблокированы";
      Fail_Alarm            = "Все выходы из здания заблокированы";
      Message_ShowDocs      = "ПОКАЗАТЬ УДОСТОВЕРЕНИЕ УЧЕНОГО";
      Message_ShowPermit    = "ПОКАЗАТЬ ДОПУСК ОТ ПОЛКОВНИКА";
      Kill_Msg_1            = "Еще ";
      Kill_Msg_3            = "Еще ";
      Kill_Msg_2            = " до того как охрана обнаружит неладное и поднимет тревогу.";
      Kill_Soldiers         = "Вы уничтожили слишком много солдат.";
      Kill_Civilian         = "Вы уничтожили слишком много ученных.";
      Kill_Officers         = "Вы унчитожили слишком много офицеров.";
      Message_Alarm         = "Поднята тревога. Охрана стала более внимательна.";
      Message_AlarmFinished = "Охрана успокоилась.";
      Message_Key           = "У вас нету ключа, чтобы открыть сейф.";
      Message_NoFoto        = "У вас нету фотоаппарата.";
      Message_SmokeStation  = "СИМУЛИРОВАТЬ ПОЛОМКУ";
      Message_CrashAlert    = "АВАРИЙНЫЙ СИГНАЛ";
      Message_AlarmSignal   = "ВЫЗВАТЬ ДЕЖУРНОГО";
      Message_TalkScientist = "@ Сэр, один из генераторов сбоит. Можете взглянуть на него по-быстрому, пожалуйста?";

	  -- Wunder
      Intro                 = "США, лаборатории Лос-Аламоса, 1944 г.";
      docs                  = "Секретные документы";

      -- Liz Shaw
      MM_StopMove_Pass          = "@ Стоять! Покажите ваше удостоверение!";
      MM_StopMove_DocsClear     = "@ Все в порядке, можете проходить.";
      MM_StopMove_Search        = "@ Стойте! Мне придется вас обыскать.";
      MM_StopMove_SearchClear   = "@ Все чисто. Спасибо, проходите.";
      MM_StopMove_SearchFail    = "@ Здесь нельзя носить скрытое оружие.";
      MM_StopMove_Box           = "@ Что вы медлите? Полковник хочет, чтобы немедленно доставили еще ящиков!";
      MM_StopMove_Lab           = "@ В эту часть здания разрешен вход только ученым и офицерам.";
      MM_StopMove_Office        = "@ Я здесь работаю! Что вам нужно?";
      MM_StopMove_Office2       = "@ Что вы здесь делаете? Это мой кабинет!";
      MM_StopMove_LeaveRoom     = "@ Вы должны немедленно покинуть эту комнату!";
      MM_StopMove_ColonelRoom   = "@ Это кабинет полковника Бэкера! Вам сюда нельзя!";
      MM_StopMove_ColonelPass   = "@ Можете войти, но ничего не трогайте, пока не вернется Полковник.";
  };

  function Level.OnCompleteMission()

      System:ConsoleCommand( 'l_loadlevel "rolik_mashina" 1' );

  end;

  function Level.PlayCrashAlertSound( onOff )

   local sound = Level.FindSound( 'broke01' );

   if ( sound == -1 ) then
      return;
   end;

   if ( onOff == true ) then

       Level.PlaySound( sound );
       Level.CrashSound = true;
 
   else

       Level.StopSound( sound );
       Level.CrashSound = false;

   end;


  end;

  function Level.PlayCrashAlertSound_2( onOff )

   local sound = Level.FindSound( 'broke02' );

   if ( sound == -1 ) then
      return;
   end;

   if ( onOff == true ) then

       Level.PlaySound( sound );
       Level.CrashSound2 = true;
 
   else

       Level.StopSound( sound );
       Level.CrashSound2 = false;

   end;


  end;

  function Level.OnFinishLoad()

     Level.AddLargeMessage(MissionText.Intro , 10.0, 180, 180, 180 ); -- Wunder

     -- forlik System:SetVar( 'r_glow' , true );
     -- forlik System:SetVar( 'r_glow_r' , 2.0 );
     Level.OnFinishLoad_Common(); -- forlik
     Level.SetDOFPostFilter( 1, 0.0, 1600.0, 3500.0 ); --forlik

     --- init music

     Level.AddMusic( Level.MUSIC_MOOD_DEFAULT, "#0.50#sounds\\music\\coldzone.ogg");
     Level.AddMusic( Level.MUSIC_MOOD_ATTENTION   , "#0.50#sounds\\music\\danger.ogg");
     Level.AddMusic( Level.MUSIC_MOOD_ACTION, "#0.50#sounds\\music\\sustain.ogg" );

     Level.SeifLabDoor = Level.FindDoor( 'SEF1' );
     Level.SeifKabDoor = Level.FindDoor( 'SEF2' );
     Level.SeifTrigger = nil;
     Level.FotoTrigger = nil;

     if ( Level.SeifLabDoor != nil ) then
       Level.SetDoorNotifyScript( Level.SeifLabDoor , true );
       Level.SetDoorUnlockKey( Level.SeifLabDoor, 'KLAB' );
       Level.SetDoorLockPick( Level.SeifLabDoor, 0 );
     end;

     if ( Level.SeifKabDoor != nil ) then
       Level.SetDoorNotifyScript( Level.SeifKabDoor, true );
       Level.SetDoorUnlockKey( Level.SeifKabDoor, 'KKAB' );
       Level.SetDoorLockPick( Level.SeifKabDoor, 0 );
     end;

     if ( Level.CrashSound == true ) then

        Level.PlayCrashAlertSound(true);

     end;

     if ( Level.CrashSound2 == true ) then

        Level.PlayCrashAlertSound_2(true);

     end;

     Level.SetDoorKey('CFDR', 'KCNF' ); -- Liz Shaw

     -- patch
     local backpack = Level.FindContainer();
     if (backpack != nil) then
         Level.EnableItemPickup(backpack, true);
     end

  end;

  function Level.OnSave()

     Stream.WriteBool( Level.FotoMade[1] );
     Stream.WriteBool( Level.FotoMade[2] );
     Stream.WriteBool( Level.FotoMade[3] );
     Stream.WriteBool( Level.FotoMade[4] );

     Stream.WriteBool( Level.AlertCalled );

     Stream.WriteBool( Level.StationSmoke );
     Stream.WriteBool( Level.CrashAlert );
     Stream.WriteBool( Level.LocalAlarm );

     Stream.WriteBool( Level.CrashSound );
     Stream.WriteBool( Level.CrashSound2 );
                       
     Stream.WriteBool( Level.EnterRoom );

     Level.WriteArray( Level.Pass ); -- Liz Shaw
     Level.WriteArray( Level.GetPass ); -- Liz Shaw
     Stream.WriteString( Level.SearchZoneName ); -- Liz Shaw
     Stream.WriteBool  ( Level.SearchingStart ); -- Liz Shaw
     Stream.WriteBool  ( Level.SearchJustFinished ); -- Liz Shaw
     Stream.WriteBool(Level.HadForbidObjects); -- Liz Shaw
     Stream.WriteInt(Level.SearchTimes); -- Liz Shaw
     Stream.WriteBool( Level.AtSearchZone ); -- Liz Shaw
     Stream.WriteBool( Level.BoxJobWorker1 ); -- Liz Shaw
     Stream.WriteBool( Level.BoxJobWorker2 ); -- Liz Shaw
     Stream.WriteBool( Level.BoxJobWorker3 ); -- Liz Shaw

     Stream.WriteBool( Level.BoxComplete[1] ); -- Liz Shaw
     Stream.WriteBool( Level.BoxComplete[2] ); -- Liz Shaw
     Stream.WriteBool( Level.BoxComplete[3] ); -- Liz Shaw

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

     Level.FotoMade = {};

     Level.FotoMade[1] = Stream.ReadBool();
     Level.FotoMade[2] = Stream.ReadBool();
     Level.FotoMade[3] = Stream.ReadBool();
     Level.FotoMade[4] = Stream.ReadBool();

     Level.AlertCalled    = Stream.ReadBool();

     Level.StationSmoke   = Stream.ReadBool();
     Level.CrashAlert     = Stream.ReadBool();
     Level.LocalAlarm     = Stream.ReadBool();

     Level.CrashSound     = Stream.ReadBool();
     Level.CrashSound2    = Stream.ReadBool();
     
     Level.EnterRoom      = Stream.ReadBool();

     Level.Pass                  = Level.ReadArray(); -- Liz Shaw
     Level.GetPass               = Level.ReadArray(); -- Liz Shaw
     Level.SearchZoneName        = Stream.ReadString(); -- Liz Shaw
     Level.SearchingStart        = Stream.ReadBool(); -- Liz Shaw
     Level.SearchJustFinished    = Stream.ReadBool(); -- Liz Shaw
     Level.HadForbidObjects      = Stream.ReadBool(); -- Liz Shaw
     Level.SearchTimes           = Stream.ReadInt(); -- Liz Shaw
     Level.AtSearchZone          = Stream.ReadBool(); -- Liz Shaw
     Level.BoxJobWorker1         = Stream.ReadBool(); -- Liz Shaw
     Level.BoxJobWorker2         = Stream.ReadBool(); -- Liz Shaw
     Level.BoxJobWorker3         = Stream.ReadBool(); -- Liz Shaw

     Level.BoxComplete={}; -- Liz Shaw

     Level.BoxComplete[1]   = Stream.ReadBool(); -- Liz Shaw
     Level.BoxComplete[2]   = Stream.ReadBool(); -- Liz Shaw
     Level.BoxComplete[3]   = Stream.ReadBool(); -- Liz Shaw

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
     System:SaveGame( "_projecty_" .. tostring(nextSlot) .. ".asv" , false );
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

     System:LoadGame( "_projecty_" .. tostring(slot) .. ".asv" , true );

     return true;

  end;

  function Level.EnableExitTask( task )

     if ( (Level.IsMissionTaskCompleted('FOTO') == true or task == 'FOTO') and
          (Level.IsMissionTaskCompleted('SEF1') == true or task == 'SEF1') and
          (Level.IsMissionTaskCompleted('SEF2') == true or task == 'SEF2') ) then

        Level.AddMissionTask( MissionText.Task_3, 'LEAV', "levels\\projecty\\leave_task.txt" );
        Level.EnableLevelMark( 'LEVV', true );

      end;

  end;

  function Level.RemoveTaskMarks()

    if ( Level.IsMissionTaskCompleted('SEF1') == true ) then
       Level.EnableLevelMark('MAK2', false );
    end;

    if ( Level.IsMissionTaskCompleted('SEF2') == true ) then
      Level.EnableLevelMark('MAK1', false );
    end;

    Level.InstallSingleDpc("Level.AutoSave()", 0.1);

  end;

  function Level.OnLoaded()

     Level.OnLoaded_Common(); -- forlik
     Level.AddMissionTask( MissionText.Task_1, 'FOTO', "levels\\projecty\\foto_task.txt" );
     Level.AddMissionTask( MissionText.Task_2, 'SEF1', "levels\\projecty\\docs1_task.txt" );
     Level.AddMissionTask( MissionText.Task_2, 'SEF2', "levels\\projecty\\docs2_task.txt" );

     Level.AddActionHandler( Level.AH_ACTOR_KILLED , "CRIS" , "OnKilledCris");
     Level.AddActionHandler( Level.AH_ACTOR_KILLED , "MGAS" , "OnKilledProfessor");

     Level.AddActionHandler( Level.AH_FOTO_CAMERA );

     Level.AddActionHandler( Level.AH_ACTOR_NUMKILLED, 'Soldier', 5 );
     Level.AddActionHandler( Level.AH_ACTOR_NUMKILLED, 'Civilian', 3 );
     Level.AddActionHandler( Level.AH_ACTOR_NUMKILLED, 'Officer', 0 );

     Level.AddActionHandler( Level.AH_FINISH_CHANGECLOTH , "TCCL" , "OnTechiClothChange" );

     Level.AddActionHandler( Level.AH_PLAYER_INVENTORY );

     -- patch
     Level.AddActionHandler( Level.AH_ACTOR_KILLED , "PS04" , "OnKilledMarkedBot");
     Level.AddActionHandler( Level.AH_ACTOR_HITTED , "PS04" , "OnKilledMarkedBot");


     Level.EnableLevelMark( 'LEVV', false );
     Actor.MarkAsTarget( Level.FindActor( 'CRIS' ) , true );
     Actor.MarkAsTarget( Level.FindActor( 'MGAS' ) , true );

     Level.FotoMade = {};

     Level.FotoMade[1] = false;
     Level.FotoMade[2] = false;
     Level.FotoMade[3] = false;
     Level.FotoMade[4] = false;

     Level.AlertCalled    = false;

     Level.CrashAlert     = false;
     Level.StationSmoke   = false;
     Level.LocalAlarm     = false;

     Level.CrashSound     = false;
     Level.CrashSound2    = false;

     Level.EnterRoom      = false;

     Level.Pass = { 'PAS1' };
     Level.GetPass = { false };
     Level.SearchZoneName        = ""; -- Liz Shaw
     Level.SearchingStart        = false; -- Liz Shaw
     Level.SearchJustFinished    = false; -- Liz Shaw
     Level.HadForbidObjects = false; -- Liz Shaw
     Level.SearchTimes = 0; -- Liz Shaw
     Level.AtSearchZone           = false; -- Liz Shaw
     Level.BoxJobWorker1 = false; -- Liz Shaw
     Level.BoxJobWorker2 = false; -- Liz Shaw
     Level.BoxJobWorker3 = false; -- Liz Shaw

     Level.BoxComplete={}; -- Liz Shaw
     Level.BoxComplete[1] = false; -- Liz Shaw
     Level.BoxComplete[2] = false; -- Liz Shaw
     Level.BoxComplete[3] = false; -- Liz Shaw

     if (Level.GetDifficulty() != 3) then
       Level.EnableLevelMark('TCCL', true);
     end;

     --- init player 

     local player     = Level.FindActor('PLYR');
     if ( player != nil ) then

       Actor.ChangeActorSkin( player, "Scientist" ); -- Liz Shaw
       Actor.EnableMesh( player, "mesh_cap" , false );
       Actor.SetActorTypeId(player, Actor.ACTOR_TYPE_CIVILIAN, Actor.ACTOR_NATION_BRITISH );

       Actor.PutEmptyPouch( player, "foto", "Equipment" );

     end;

     -- Entities..

     Level.EnableEquipmentNotify( Level.FindItem('BOX3'), "drop", true );
     Level.EnableEquipmentNotify( Level.FindItem('BOX4'), "drop", true );
     Level.EnableEquipmentNotify( Level.FindItem('BOX5'), "drop", true );

     Level.EnableEquipmentNotify( Level.FindItem('BOX1'), "drop", true );
     Level.EnableEquipmentNotify( Level.FindItem('BOX2'), "drop", true );
     Level.EnableEquipmentNotify( Level.FindItem('BOX1'), "pickup", true );
     Level.EnableEquipmentNotify( Level.FindItem('BOX2'), "pickup", true );

     local boxes={ 'BOX3', 'BOX4', 'BOX5' };
     for b in boxes do
        local item = Level.FindItem( boxes[b] );
        if ( item != nil ) then
           Level.EnableItemPickup( item, false );
        end;       
     end;

     -- keys

     local key_1 = Level.CreateItem( "Custom" , "Equipment" );
     if ( key_1 != nil ) then

       Entity.SetUniqueID( key_1, 'KLAB' );

       Level.SetCustomItemName( key_1, MissionText.Key_Name_1 );
       Level.SetCustomItemIcon( key_1, "ammo_key" );
     
       local megaScientist = Level.FindActor('MGAS');
       if (megaScientist != nil) then 
          Actor.PutPouch( megaScientist, Actor.GetEmptyPouch(megaScientist), key_1 );          
       end
     end;

     local key_2 = Level.CreateItem( "Custom" , "Equipment" );
     if ( key_2 != nil ) then

       Entity.SetUniqueID( key_2, 'KKAB' );

       Level.SetCustomItemName( key_2, MissionText.Key_Name_2 );
       Level.SetCustomItemIcon( key_2, "ammo_key" );
     
       local officer = Level.FindActor('CRIS');
       if ( officer != nil ) then 
         Actor.PutPouch( officer, Actor.GetEmptyPouch(officer), key_2 );         
       end;

     end;

     local key_3 = Level.CreateItem( "Custom" , "Equipment" );
     if ( key_3 != nil ) then

       Entity.SetUniqueID( key_3, 'KCNF' );

       Level.SetCustomItemName( key_3, MissionText.Key_Name_3 );
       Level.SetCustomItemIcon( key_3, "ammo_key" );
     
       local soldier = Level.FindActor('AS01');
       if ( soldier != nil ) then 
         Actor.PutPouch( soldier, Actor.GetEmptyPouch(soldier), key_3 );         
       end;

     end;

     local properties = Level.CreateCustomParams();
     Level.SetValue(properties, "DistanceRun", true);
     Level.SetValue(properties, "ParentPolicy", true);

     AI.FollowActor( AI.FindNPC('MS03'), Level.FindActor('MO02'), 0.0, -15.0, properties);
     AI.FollowActor( AI.FindNPC('MS05'), Level.FindActor('MO03'), 0.0, -15.0, properties);

     AI.SetCustomGuarderBox( AI.FindNPC('AS02'), true, -63.0, 25.0, -479.0, -36.0, 40.0, -472.0 );

     AI.AddHideBodyBox(-301.7, -27.3, 62.2, -154.0, -0.1, 152.8);

     -- setup easy...
     if (Level.GetDifficulty() == 0) then
        Level.SetupEasy();
     end

     if (player != nil) then
       AI.RebuildPlayerForm();
       AI.AddFormChangedValue();
     end

       for i in Level.Pass do
          Level.SetEntityName(Level.Pass[i], MissionText.Message_PassNameL, MissionText.Message_PassName);
       end
       
       local passNpc = { 'AS04', 'MP02', 'AS05', 'LS06',
                         'MP03', 'MP05', 'AS07', 'MP06', 'AS10',
                         'LS08', 'LS10',
                         'AS12', 'MS13', 'MS14', 'MS15',
                         'MP08', 'AS16', 'DS20',
                         'DS21', 'DS22', 'DS23', 'MP01', 'DS24',
                         'DS25', 'DS26', 'DS28', 'DS29', 'DS30',
                         'DP02', 'AS17', 'MP07', 'AS11'
                         
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

     local pass_2 = Level.CreateItem( "Custom" , "Equipment" );
     if ( pass_2 != nil ) then

       Entity.SetUniqueID( pass_2, 'CPMT' );

       Level.SetCustomItemName( pass_2, MissionText.Message_Pass2Name );
       Level.SetCustomItemIcon( pass_2, "ammo_doc" );
     
       local officer = Level.FindActor('CRIS');
       if ( officer != nil ) then 
         Actor.PutPouch( officer, Actor.GetEmptyPouch(officer), pass_2 );         
       end;

     end;

     AI.ChangeLogic( AI.FindNPC('AS14'), "LiteScriptSoldier" );
     AI.ChangeLogic( AI.FindNPC('MS09'), "LiteScriptSoldier" );

     AI.SetPlayerForm("Scientist");
     AI.SetPlayerDefaultForm("Scientist");

     AI.OnPlayerEnterZone("global", 'GLSC'); -- forlik

     AI.EnableZone("SearchAlertZone_1", false );
     AI.EnableZone("SearchAlertZone_2", false );
     AI.EnableZone("NoWeapon", false );

     Level.OnFinishLoad();
     Level.AutoSave();

  end;

  AI.DoFile( "scripts:Levels\\Common.lua", false ); -- forlik

  -- patch
  function Level.OnKilledMarkedBot()

      if (AI.FindNPC('PS04') == nil) then 
         Level.EnableLevelMark( 'TUAL' , false );
      end

  end

  function Level.OnKilledCris()

     Level.FailedMission( MissionText.Fail_Cris );

  end;

  function Level.OnKilledProfessor()

     Level.FailedMission( MissionText.Fail_Prof );

  end;

  function Level.OnFotoCamera()

   if ( Level.FotoTrigger != nil ) then

     if ( Level.IsMissionFailed() != false or Level.IsMissionTaskCompleted('FOTO') != false ) then

       return;

     end;

     local fotoNumber = Trigger.GetUniqueIdAsNumber( Level.FotoTrigger );

     if ( fotoNumber == nil or Level.FotoMade[fotoNumber] != false ) then
        return;
     end;

     -- forlik
     Level.PlayMenuSound("foto");

     if ( Level.CheckFotoTrigger( Level.FotoTrigger ) != false ) then

        Level.AddLargeMessage( MissionText.Foto_Made, 5.0, 255, 255, 255 );

        Level.FotoMade[fotoNumber] = true;

        Level.UnregisterTrigger( Level.FotoTrigger );
        Level.RemovePlayerAction("FOTO");
        Level.EnableLevelMark( Trigger.GetScriptCmd( Level.FotoTrigger ), false );

        Level.FotoTrigger = nil;

        if ( Level.FotoMade[1] == true and Level.FotoMade[2] == true and
             Level.FotoMade[3] == true and Level.FotoMade[4] == true ) then

            Level.EnableExitTask('FOTO');

            Level.EnableLevelMark( 'MAK5', false );
            Level.PlayMenuSound("task_finish"); -- Liz Shaw
            Level.CompleteMissionTask('FOTO', 15.0 );
            Level.AutoSave();
        end;

     else

        Level.AddLargeMessage( MissionText.Foto_Fail, 5.0, 255, 255, 255 );

     end;

   end;

  end;

  function Level.OnOpenDoor( door )

   if ( Level.SeifTrigger != nil ) then

      AI.StartDecamouflage( 50.0, 70.0, 2.0 );
      Level.SeifTrigger:OnEnterArea();

   end;

  end;

  function Level.OnCloseDoor( door )

    if ( door == 'SEF1' or door == 'SEF2' ) then

       Level.RemovePlayerAction("DOCS");

    end;

  end;  

  function Level.OnFinishMessageTimer()

    Level.FailedMission( MissionText.Fail_Alarm );

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

  function Level.OnActorNumKilled( numCivilian, numSoldiers, numOfficers, numMajors, numOverall, actorTypeId )

    if ( Level.AlertCalled == true ) then 
        return;
    end;

    if ( actorTypeId == Actor.ACTOR_TYPE_SOLDIER ) then

       Level.PersonKillHandler( 8, numSoldiers, MissionText.Kill_Soldiers );
       return;

    elseif ( actorTypeId == Actor.ACTOR_TYPE_CIVILIAN ) then

       Level.PersonKillHandler( 6, numCivilian, MissionText.Kill_Civilian );
       return;     

    elseif ( actorTypeId == Actor.ACTOR_TYPE_OFFICER ) then

       Level.PersonKillHandler( 2, numOfficers, MissionText.Kill_Officers );
       return;

    end;

  end;

  function Level.OnEnterTriggerArea( sender, trgname, trgcmd )

    if ( Level.IsMissionFailed() != false ) then
      return;
    end;

    if ( trgname == 'ExitTrigger' ) then

       if ( Level.IsMissionTaskCompleted('FOTO') == true and
            Level.IsMissionTaskCompleted('SEF1') == true and
            Level.IsMissionTaskCompleted('SEF2') == true ) then

         Level.PlayMenuSound("task_finish"); -- Liz Shaw
         Level.CompleteMissionTask('LEAV', 15.0 );
        
       end;

   elseif ( trgname == 'MarkTualet' ) then

         Level.EnableLevelMark('TUAL', false );
         Level.UnregisterTrigger( Level.FindTrigger( 'MarkTualet' ) );

   --elseif ( trgname == 'MarkTrigger_2' ) then
 
         --Level.UnregisterTrigger( Level.FindTrigger( 'MarkTrigger_2' ) );

   elseif ( trgname == 'MarkTrigger_3' ) then

         --Level.UnregisterTrigger( Level.FindTrigger( 'MarkTrigger_3' ) );

   elseif ( trgname == 'CheckKey_1' ) then

         if ( Actor.HasCustomEquipment( Level.FindActor('PLYR'), 'KLAB' ) == false ) then

            Level.AddSmallMessage( MissionText.Message_Key, 10.0 , 255, 255, 255 );

         end;

   elseif ( trgname == 'CheckKey_2' ) then

         if ( Actor.HasCustomEquipment( Level.FindActor('PLYR'), 'KKAB' ) == false ) then

            Level.AddSmallMessage( MissionText.Message_Key, 10.0 , 255, 255, 255 );

         end;

   elseif ( trgname == 'HackSearchZoneTrigger_01' ) then

      Level.AtSearchZone = true;

      if (AI.GetPlayerForm() != "Scientist") then
         AI.EnableZone("SearchZone_1",       false);
      end;

      if ((AI.IsDefault(AI.FindNPC('AS14')) == true and trgname == "HackSearchZoneTrigger_01")) then

         if (AI.IsZoneEnabled("SearchZone_1") == true) then

            AI.EnableZone("SearchAlertZone_1", true);
            local disableZoneString = "AI.EnableZone('SearchAlertZone_1', false)";
            Level.RemoveDpc(disableZoneString);
            Level.InstallDpc(disableZoneString, 20.0);
         end;

      end;

   elseif (trgname == 'DisableSearchZoneTrigger_01') then
      -- disable zone...

      Level.DisableSearchZone_01();

   elseif ( trgname == "StartBoxJobs" ) then

       if ( Level.BoxJobWorker1 == false ) then

          local worker_1 = AI.FindNPC('MS23');
          if ( worker_1 != nil and AI.IsDefault( worker_1 ) == true ) then               
            if ( Level.BoxComplete[1] == false ) then
                AI.SetJob( worker_1, "box1" );            
            end;
          end;

          Level.BoxJobWorker1 = true;

       end;

       if ( Level.BoxJobWorker2 == false ) then

          local worker_2 = AI.FindNPC('MS24');
          if ( worker_2 != nil and AI.IsDefault( worker_2 ) == true ) then
            if ( Level.BoxComplete[2] == false ) then
               Level.InstallDpc( "AI.SetJob( AI.FindNPC('MS24'), 'box1' )", 3.0 );
            end;
          end;

          Level.BoxJobWorker2 = true;

       end;

       if ( Level.BoxJobWorker3 == false ) then

          local worker_3 = AI.FindNPC('MS25');
          if ( worker_3 != nil and AI.IsDefault( worker_3 ) == true ) then
            if ( Level.BoxComplete[3] == false ) then
               Level.InstallDpc( "AI.SetJob( AI.FindNPC('MS25'), 'box1' )", 6.0 );
            end;
          end;

          Level.BoxJobWorker3 = true;

       end;

   elseif ( trgname == 'HackSearchZoneTrigger_02' ) then

      Level.AtSearchZone = true;

      if (AI.GetPlayerForm() != "Scientist") then
         AI.EnableZone("SearchZone_2",       false);
      end;

      if ((AI.IsDefault(AI.FindNPC('MS09')) == true and trgname == "HackSearchZoneTrigger_02")) then

         if (AI.IsZoneEnabled("SearchZone_2") == true) then

            AI.EnableZone("SearchAlertZone_2", true);
            local disableZoneString = "AI.EnableZone('SearchAlertZone_2', false)";
            Level.RemoveDpc(disableZoneString);
            Level.InstallDpc(disableZoneString, 20.0);
         end;

      end;

   elseif (trgname == 'DisableSearchZoneTrigger_02') then
      -- disable zone...

      Level.DisableSearchZone_02();

   end;

  end;

  function Level.OnLeaveTriggerArea( sender, trgname, trgcmd )

    if ( trgname == 'HackSearchZoneTrigger_01' ) then

      Level.AtSearchZone = false;

      if (AI.GetPlayerForm() != "Scientist") then
         AI.EnableZone("SearchZone_1",       true);
      end;

    elseif ( trgname == 'HackSearchZoneTrigger_02' ) then

      Level.AtSearchZone = false;

      if (AI.GetPlayerForm() != "Scientist") then
         AI.EnableZone("SearchZone_2",       true);
      end;

    end;

  end;

  function Level.OnFinishAlert( alertGroupId )
     
     AI.Debug(nil, "Level.OnFinishAlert", "group", alertGroupId);
     AI.SetLocalAlert( alertGroupId, false );

     local alertLast = true;
     for i = 1, 11, 1 do
        if (AI.IsLocalAlert( i ) != false) then
           alertLast = false;
        end
     end

     if (AI.IsLocalAlert( 20 ) != false ) then
        alertLast = false;
     end

     if (alertLast != false) then
        AI.Debug(nil, "Level.OnFinishAlert", "EnableAlarmSound:false");

        Level.AddSmallMessage( MissionText.Message_AlarmFinished, 10.0, 255, 255, 0);
        Level.EnableAlarmSound( false );

        Level.AlertCalled = true;
     end 
  end

  function Level.OnRoomTriggerTime()

    Level.EnterRoom = false;
    Level.RemoveTimer( 'TGTM' );

  end

  function Level.OnAlert( alertGroupId )

    local alertSoldierTime = 180;
    local alertScientistTime = 120;

    Level.AddSmallMessage( MissionText.Message_Alarm, 10.0, 255, 0, 0);
    Level.EnableAlarmSound( true );

    if ( Level.AlertCalled == false ) then
      Level.AlertCalled = true;

      AI.AddAlertValue(2); 
      Level.StartMessageTimer( MissionText.Alarm_Timer, 180.0, 255, 255, 255 );

    end;

    AI.Debug(nil, "Level.OnAlert", "group", alertGroupId);

    if (alertGroupId == 1 or alertGroupId == 2) then

       AI.StartFinding(AI.AI_TARGET_ALERT_GROUP, "4");
       AI.StartFinding(AI.AI_TARGET_ALERT_GROUP, "6");
       AI.StartFinding(AI.AI_TARGET_ALERT_GROUP, "8");
       AI.StartFinding(AI.AI_TARGET_ALERT_GROUP, "9");

       AI.SafeFind(AI.FindNPC('MS23'), true);
       AI.SafeFind(AI.FindNPC('MS24'), true);
       AI.SafeFind(AI.FindNPC('MS25'), true);

       AI.SetAttention(AI.AI_TARGET_ALERT_GROUP, "1", AI.ATTENTION_ALARM, true);
       AI.SetAttention(AI.AI_TARGET_ALERT_GROUP, "2", AI.ATTENTION_ALARM, true);

    elseif (alertGroupId == 3 or 
            alertGroupId == 4 or 
            alertGroupId == 5) then

       AI.StartFinding(AI.AI_TARGET_ALERT_GROUP, "6");
       AI.StartFinding(AI.AI_TARGET_ALERT_GROUP, "8");
       AI.StartFinding(AI.AI_TARGET_ALERT_GROUP, "9");

       AI.SafeFind(AI.FindNPC('MS23'), true);
       AI.SafeFind(AI.FindNPC('MS24'), true);
       AI.SafeFind(AI.FindNPC('MS25'), true);

       AI.SetAttention(AI.AI_TARGET_ALERT_GROUP, "2", AI.ATTENTION_ALARM, true);
       AI.SetAttention(AI.AI_TARGET_ALERT_GROUP, "3", AI.ATTENTION_ALARM, true);
       AI.SetAttention(AI.AI_TARGET_ALERT_GROUP, "4", AI.ATTENTION_ALARM, true);
       AI.SetAttention(AI.AI_TARGET_ALERT_GROUP, "5", AI.ATTENTION_ALARM, true);

    elseif (alertGroupId == 6 or alertGroupId == 7) then

       AI.StartFinding(AI.AI_TARGET_ALERT_GROUP, "1");
       AI.StartFinding(AI.AI_TARGET_ALERT_GROUP, "4");
       AI.StartFinding(AI.AI_TARGET_ALERT_GROUP, "9");

       AI.SafeFind(AI.FindNPC('MS20'), true);
       AI.SafeFind(AI.FindNPC('MS21'), true);
       AI.SafeFind(AI.FindNPC('MS27'), true);

       AI.SetAttention(AI.AI_TARGET_ALERT_GROUP, "5", AI.ATTENTION_ALARM, true);
       AI.SetAttention(AI.AI_TARGET_ALERT_GROUP, "6", AI.ATTENTION_ALARM, true);
       AI.SetAttention(AI.AI_TARGET_ALERT_GROUP, "7", AI.ATTENTION_ALARM, true);

    elseif (alertGroupId == 8) then

       AI.StartFinding(AI.AI_TARGET_ALERT_GROUP, "1");
       AI.StartFinding(AI.AI_TARGET_ALERT_GROUP, "4");
       AI.StartFinding(AI.AI_TARGET_ALERT_GROUP, "6");
       AI.StartFinding(AI.AI_TARGET_ALERT_GROUP, "9");

    elseif (alertGroupId == 9 or
            alertGroupId == 10 or 
            alertGroupId == 11) then

       AI.StartFinding(AI.AI_TARGET_ALERT_GROUP, "1");
       AI.StartFinding(AI.AI_TARGET_ALERT_GROUP, "4");
       AI.StartFinding(AI.AI_TARGET_ALERT_GROUP, "6");

       AI.SafeFind(AI.FindNPC('MS20'), true);
       AI.SafeFind(AI.FindNPC('MS21'), true);
       AI.SafeFind(AI.FindNPC('MS27'), true);

       AI.SetAttention(AI.AI_TARGET_ALERT_GROUP, "9", AI.ATTENTION_ALARM, true);
       AI.SetAttention(AI.AI_TARGET_ALERT_GROUP, "10", AI.ATTENTION_ALARM, true);
       AI.SetAttention(AI.AI_TARGET_ALERT_GROUP, "11", AI.ATTENTION_ALARM, true);

    elseif (alertGroupId == 20) then

       AI.StartFinding(AI.AI_TARGET_ALERT_GROUP, "1");
       AI.StartFinding(AI.AI_TARGET_ALERT_GROUP, "4");
       AI.StartFinding(AI.AI_TARGET_ALERT_GROUP, "6");
       AI.StartFinding(AI.AI_TARGET_ALERT_GROUP, "8");
       AI.StartFinding(AI.AI_TARGET_ALERT_GROUP, "9");

    end

    AI.SetAttention(AI.AI_TARGET_ALERT_GROUP, "1", AI.ATTENTION_ALARM, true);
    AI.SetAttention(AI.AI_TARGET_ALERT_GROUP, "4", AI.ATTENTION_ALARM, true);
    AI.SetAttention(AI.AI_TARGET_ALERT_GROUP, "6", AI.ATTENTION_ALARM, true);
    AI.SetAttention(AI.AI_TARGET_ALERT_GROUP, "8", AI.ATTENTION_ALARM, true);
    AI.SetAttention(AI.AI_TARGET_ALERT_GROUP, "9", AI.ATTENTION_ALARM, true);

    -- Common things
    AI.SetLocalAlert(1, true, alertSoldierTime);
    AI.SetLocalAlert(4, true, alertSoldierTime);
    AI.SetLocalAlert(6, true, alertSoldierTime);
    AI.SetLocalAlert(8, true, alertSoldierTime);
    AI.SetLocalAlert(9, true, alertSoldierTime);

    AI.SetLocalAlert(2, true, alertScientistTime);
    AI.SetLocalAlert(3, true, alertScientistTime);
    AI.SetLocalAlert(5, true, alertScientistTime);
    AI.SetLocalAlert(7, true, alertScientistTime);
    AI.SetLocalAlert(10, true, alertScientistTime);
    AI.SetLocalAlert(11, true, alertScientistTime);

    AI.SetLocalAlert(20, true, alertSoldierTime);

  end

  function Level.OnInventoryChanged()
    local player = Level.GetPlayer();
    if (Actor.HasCustomEquipment(player, 'KLAB') != false) then
       Level.EnableLevelMark( 'MAK4', false );
       Level.EnableLevelMark( 'MAK6', false );
       Level.EnableLevelMark( 'MAK2', false );
    end

    if (Actor.HasCustomEquipment(player, 'KKAB') != false) then
       Level.EnableLevelMark( 'MAK1', false );
    end

    for i in Level.Pass do 
       if (Level.GetPass[i] == false and 
           Actor.HasCustomEquipment(player, Level.Pass[i]) == true) then

          AI.StartDecamouflage( 50.0, 100.0, 3.0 );
          Level.GetPass[i] = true;
       end
    end

    if (Level.PlayerHasPass() == true) then
       Level.EnableLevelMark('MAK3', false);
    end

    Level.ResetSearchScript();

  end


  function Level.StartCustomAnimationJob( botUID, anim, posX, posY, posZ, dirX, dirY, dirZ, wp )
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
     Level.SetValue(properties, "Return place waypoint", wp );
	
     AI.Idle( bot, properties );
    else
     print("Warning. Can't find npc " .. botUID);
    end
  end

  function Level.SetupEasy()
    Level.StartCustomAnimationJob('AS15', "Act_Rasplata_Smoking", -107.0, -44.0, -862.0, 0.0, 0.0, -1.0, '2796');
  end

--------------------------------------------------------
-- Name: Level.HasForbidObjects()
-- Desc:
--------------------------------------------------------
function Level.HasForbidObjects()

--   local numKnifes = Actor.GetNumWeaponOfClass( Level.GetPlayer(), Level.WEAPON_CLASS_KNIFE, true );
--   if (numKnifes >= 1) then
--      return true;
--   end
   
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
-- Name: Level.ResetSearchScript()
-- Desc:
--------------------------------------------------------
function Level.ResetSearchScript()
   Level.RemoveDpc("Level.EnableSearchZone()");
   
   AI.EnableZone("SearchZone_1", true);
   AI.EnableZone("SearchZone_2", true);
end

--------------------------------------------------------
-- Name: Level.EnableSearchZone()
-- Desc:
--------------------------------------------------------
function Level.EnableSearchZone()
   AI.EnableZone("SearchZone_1", true);
   AI.EnableZone("SearchZone_2", true);
   
   AI.EnableZone("NoWeapon", false);
   AI.EnableZone("NoWeapon", false);
end

--------------------------------------------------------
-- Name: Level.CanEnableSearchZone()
-- Desc:
--------------------------------------------------------
function Level.CanEnableSearchZone()
   --return (Level.AtSearchZone == false) or (Level.HasForbidObjects() == true);
   return (Level.AtSearchZone == false);
end

--------------------------------------------------------
-- Name: Level.CanEnableSearchZone2()
-- Desc:
--------------------------------------------------------
function Level.CanEnableSearchZone2()
   return (Level.AtSearchZone == false) or (Level.HasForbidObjects() == true);
end

--------------------------------------------------------
-- Name: Level.OnSearchFinished()
-- Desc:
--------------------------------------------------------
function Level.OnSearchFinished()

   if (Level.HasForbidObjects() == true) then

      Level.SearchTimes = Level.SearchTimes + 1;
      Level.InstallDpc("Level.SearchTimes = 0", 20.0);

      if (Level.SearchTimes > 1 and false) then
      --if (false)
         AI.DecamouflagePlayer(Level.GetSearchMan());
      else
         -- Level.AddSmallMessage( MissionText.Message_StopMove_Weapon, 5.0, 175, 175, 175 );

         AI.EnableZone("SearchZone_1", false);
         AI.EnableZone("SearchZone_2", false);

         AI.EnableZone("NoWeapon", true);

         Level.InstallSingleSmartDpc("Level.EnableSearchZone()", 5.0, "Level.CanEnableSearchZone2()");
      end

   else
      Level.AddSmallMessage( MissionText.MM_StopMove_SearchClear, 5.0, 175, 175, 175 );
      AI.HandleVoice( Level.GetSearchMan(), "male_usa_script_script_41");

      AI.EnableZone("SearchAlertZone_1", false);
      AI.EnableZone("SearchZone_1", false);

      Level.InstallSingleSmartDpc("Level.EnableSearchZone()", 5.0, "Level.CanEnableSearchZone()");

      Level.SearchJustFinished = true;
      Level.InstallDpc("Level.SearchJustFinished = false", 15.0);
   end
end

--------------------------------------------------------
-- Name: Level.OnSearch2Finished()
-- Desc:
--------------------------------------------------------
function Level.OnSearch2Finished()

   if (Level.HasForbidObjects() == true) then

      Level.SearchTimes = Level.SearchTimes + 1;
      Level.InstallDpc("Level.SearchTimes = 0", 20.0);

      if (Level.SearchTimes > 1 and false) then
      --if (false)        
         AI.DecamouflagePlayer(Level.GetSearchMan());
      else
         -- Level.AddSmallMessage( MissionText.Message_StopMove_Weapon, 5.0, 175, 175, 175 );

         AI.EnableZone("SearchZone_1", false);
         AI.EnableZone("SearchZone_2", false);

         AI.EnableZone("NoWeapon", true);

         Level.InstallSingleSmartDpc("Level.EnableSearchZone()", 5.0, "Level.CanEnableSearchZone2()");
      end

   else
      Level.AddSmallMessage( MissionText.MM_StopMove_SearchClear, 5.0, 175, 175, 175 );
      AI.HandleVoice( Level.GetSearchMan(), "male_usa_script_script_41");

      AI.EnableZone("SearchAlertZone_2", false);
      AI.EnableZone("SearchZone_2", false);

      Level.InstallSingleSmartDpc("Level.EnableSearchZone()", 5.0, "Level.CanEnableSearchZone()");

      Level.SearchJustFinished = true;
      Level.InstallDpc("Level.SearchJustFinished = false", 15.0);
   end

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
      Level.SafeRemoveLevelPlayerAction('SHP3');
      Level.SafeRemoveLevelPlayerAction('SHP4');
      Level.SafeRemoveLevelPlayerAction('SHP5');
   end
end

--------------------------------------------------------
-- Name: Level.RestoreBombAreaZone()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.RestoreBombAreaZone()
   AI.EnableZone("BombArea_Pass",      true);
   AI.EnableZone("BombAreaEnter",      true);
end

--------------------------------------------------------
-- Name: Level.RestoreSafeAreaZone()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.RestoreSafeAreaZone()
   AI.EnableZone("SafeArea_Pass",      true);
   AI.EnableZone("SafeAreaEnter",      true);
end

--------------------------------------------------------
-- Name: Level.RestoreColonelAreaZone()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.RestoreColonelAreaZone()
   AI.EnableZone("ColonelArea",           true);
   AI.EnableZone("ColonelAreaEnter",      true);
end

--------------------------------------------------------
-- Name: Level.RestoreCyclotronZone()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.RestoreCyclotronZone()
   AI.EnableZone("Cyclotron_Pass",          true);
   AI.EnableZone("Cyclotron_NearPass",      true);
end

--------------------------------------------------------
-- Name: Level.RestoreColonelRoomZone()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.RestoreColonelRoomZone()
   AI.EnableZone("ColonelRoom",           true);
   AI.EnableZone("ColonelRoom_Near",      true);
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
-- Name: Level.PlayerHasPermit()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.PlayerHasPermit()
   local player = Level.GetPlayer();
     
   return (Actor.HasCustomEquipment(player, 'CPMT') == true);
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
         AI.HandleVoice(npc, "male_usa_script_script_29");
      end
   end
end

--------------------------------------------------------
-- Name: Level.OnReadDocs2()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.OnReadDocs2()
   Level.AddSmallMessage( MissionText.MM_StopMove_ColonelPass, 5.0, 175, 175, 175 );

   local job = AI.GetScriptJob("TASK_SCRIPT_READ_DOCS");
   if (job != nil) then
      local npc = Job.GetNPC( job );
      if (npc != nil) then
         AI.HandleVoice(npc, "male_usa_script_script_29");
      end
   end
end

--------------------------------------------------------
-- Name: Level:OnPlayerAction()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level:OnPlayerAction(id)

   if (id == 'SHP1' or id == 'SHP2' or id == 'SHP3' or id == 'SHP4') then

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

         Level.DisableBombAreaZone();

      elseif (id == 'SHP2') then

         Level.DisableSafeAreaZone();

      elseif (id == 'SHP3') then

         Level.DisableColonelAreaZone();

      elseif (id == 'SHP4') then

         Level.DisableCyclotronZone();

      end

      local player = Level.GetPlayer();

      if (Actor.GetPickupItem(player) == nil) then 
         Level.PlayerShowDocsAnim();
      else
         Actor.DropPickupItem(player, false);
         Level.InstallDpc("Level.PlayerShowDocsAnim()", 0.8);
      end

   elseif (id == 'SHP5') then

      -- get show stop move bot...
      local npc = AI.FindNearestNpc(AI.TASK_SHOW_STOP_MOVE, "");
      if (npc == nil) then
         Level.SafeRemoveLevelPlayerAction(id);
         Level.RemoveTimer('PSTM');
         return;
      end

      Level.SafeRemoveLevelPlayerAction(id);

      local properties = Level.CreateCustomParams();

      Level.SetValue(properties, "CustomString_1", "Level.OnReadDocs2()" );

      AI.RunScriptTask(npc, "scripts:job\\ReadDocsTask.lua", AI.LOGIC_DEFAULT, properties);

      Level.DisableColonelRoomZone();

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
-- Name: Level.DisableBombAreaZone()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.DisableBombAreaZone()
   AI.EnableZone("BombArea_Pass",      false);
   AI.EnableZone("BombAreaEnter",      false);

   Level.AddTimer( 'RBZN', "RestoreBombAreaZone", 5.0 * 60.0, false );
end

--------------------------------------------------------
-- Name: Level.DisableSafeAreaZone()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.DisableSafeAreaZone()
   AI.EnableZone("SafeArea_Pass",      false);
   AI.EnableZone("SafeAreaEnter",      false);

   Level.AddTimer( 'RSZN', "RestoreSafeAreaZone", 5.0 * 60.0, false );
end

--------------------------------------------------------
-- Name: Level.DisableColonelAreaZone()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.DisableColonelAreaZone()
   AI.EnableZone("ColonelArea",      false);
   AI.EnableZone("ColonelAreaEnter",      false);

   if (Level.SearchJustFinished == false) then
      AI.EnableZone("SearchZone_1",       true);
      AI.EnableZone("SearchAlertZone_1",       false);
   end

   Level.AddTimer( 'RCZN', "RestoreColonelAreaZone", 5.0 * 100.0, false );
end

--------------------------------------------------------
-- Name: Level.DisableCyclotronZone()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.DisableCyclotronZone()
   AI.EnableZone("Cyclotron_Pass",      false);
   AI.EnableZone("Cyclotron_NearPass",      false);

   if (Level.SearchJustFinished == false) then
      AI.EnableZone("SearchZone_2",       true);
      AI.EnableZone("SearchAlertZone_2",       false);
   end

   Level.AddTimer( 'RYZN', "RestoreCyclotronZone", 5.0 * 120.0, false );
end

--------------------------------------------------------
-- Name: Level.DisableColonelRoomZone()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.DisableColonelRoomZone()
   AI.EnableZone("ColonelRoom",      false);
   AI.EnableZone("ColonelRoom_Near",      false);

   Level.AddTimer( 'RCRZ', "RestoreColonelRoomZone", 5.0 * 30.0, false );
end

--------------------------------------------------------
-- Name: Level.OnNextBoxWorker()
-- Desc:
--------------------------------------------------------
function Level.OnNextBoxWorker( actorId )
      
   local npc = AI.FindNPC( actorId );

   if ( actorId == 'MS23' ) then

      if ( Level.BoxComplete[1] == true ) then
          AI.SetJob( npc, "default" );
      end;

   elseif ( actorId == 'MS24' ) then

      if ( Level.BoxComplete[2] == true ) then
          AI.SetJob( npc, "default" );
      end;

   elseif ( actorId == 'MS25' ) then
   
      if ( Level.BoxComplete[3] == true ) then
          AI.SetJob( npc, "default" );
      end;

   end;

end;

--------------------------------------------------------
-- Name: Level.EnablePlayerBoxes()
-- Desc:
--------------------------------------------------------
function Level.EnablePlayerBoxes( onOff )
   Level.EnableItemPickup( Level.FindItem('BOX1'), onOff );
   Level.EnableItemPickup( Level.FindItem('BOX2'), onOff );
end;

--------------------------------------------------------
-- Name: Level.OnNotifyPickupItem()
-- Desc:
--------------------------------------------------------
function Level.OnNotifyPickupItem( itemId, item )
   if (itemId == 'BOX1' or itemId == 'BOX2') then
      AI.EnableZone("WorkersSkladEnterBox", false);
      return;

   end;
end;

--------------------------------------------------------
-- Name: Level.OnNotifyDropItem()
-- Desc:
--------------------------------------------------------
function Level.OnNotifyDropItem( itemId, item )
   
   local offset = nil;
   
   if (itemId == 'BOX1' or itemId == 'BOX2') then
      AI.EnableZone("WorkersSkladEnterBox", true);
      return;
   end
      
   if ( itemId == 'BOX5' ) then
      Level.BoxComplete[1] = true;
   elseif ( itemId == 'BOX4' ) then
      --offset={ 0.0, 6.0, -4.0 };
      Level.BoxComplete[2] = true;
   elseif ( itemId == 'BOX3' ) then
      --offset={ 0.0, 6.0, -4.0 };
      Level.BoxComplete[3] = true;
   end;
   
   if ( offset != nil ) then
   
      local itemNode  = Entity.GetNode( item );
      local x,y,z = node.GetPosition( itemNode );
      
      x = x + offset[1];
      y = y + offset[2];
      z = z + offset[3];      
      
      node.SetPosition( itemNode, x, y, z );
      node.InvalidateTransforms( itemNode );  
   
   end;
end;

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
-- Name: Level.DisableSearchZone_01()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.DisableSearchZone_01()
    if (AI.GetPlayerForm() != "Scientist") then
       AI.EnableZone("SearchZone_1",       false);
    end
end

--------------------------------------------------------
-- Name: Level.DisableSearchZone_02()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.DisableSearchZone_02()
    if (AI.GetPlayerForm() != "Scientist") then
       AI.EnableZone("SearchZone_2",       false);
    end
end

--------------------------------------------------------
-- Name: Level.OnTechiClothChange()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.OnTechiClothChange()
  local player = Level.GetPlayer();
  if (player != nil) then
    Actor.EnableMesh(player, "mesh_helmet", false);
  end
  Level.EnableLevelMark('TCCL', false);
  Level.RemoveActionHandler(Level.AH_FINISH_CHANGECLOTH, 'TCCL');
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

  if (zone == "BombArea_Pass" or
      zone == "BombAreaEnter") then
    Level.AddSmallMessage(MissionText.MM_StopMove_Pass, 5.0, 175, 175, 175);
    AI.HandleVoice(npc, "male_usa_stopmove_stopmove_06");
    if (Level.PlayerHasPass() == true) then
      if (Level.HasPlayerAction('SHP1') == false) then
         --Level.AddPlayerAction('SHP1', MissionText.Message_ShowDocs, "Level", false );
         Level.SafeAddLevelPlayerAction('SHP1', MissionText.Message_ShowDocs);
         Level.AddTimer('PSTM', "OnCheckShowPass", 1.0, true );
      end
    end
  elseif (zone == "SafeArea_Pass" or
          zone == "SafeAreaEnter") then
    Level.AddSmallMessage(MissionText.MM_StopMove_Pass, 5.0, 175, 175, 175);
    AI.HandleVoice(npc, "male_usa_stopmove_stopmove_06");
    if (Level.PlayerHasPass() == true) then
      if (Level.HasPlayerAction('SHP2') == false) then
         --Level.AddPlayerAction('SHP2', MissionText.Message_ShowDocs, "Level", false );
         Level.SafeAddLevelPlayerAction('SHP2', MissionText.Message_ShowDocs);
         Level.AddTimer('PSTM', "OnCheckShowPass", 1.0, true );
      end
    end
  elseif (zone == "ColonelArea" or
          zone == "ColonelAreaEnter") then
    Level.AddSmallMessage(MissionText.MM_StopMove_Pass, 5.0, 175, 175, 175);
    AI.HandleVoice(npc, "male_usa_stopmove_stopmove_06");
    AI.EnableZone("SearchZone_1",       false);
    AI.EnableZone("SearchAlertZone_1",       true);
    if (Level.PlayerHasPass() == true) then
      if (Level.HasPlayerAction('SHP3') == false) then
         --Level.AddPlayerAction('SHP3', MissionText.Message_ShowDocs, "Level", false );
         Level.SafeAddLevelPlayerAction('SHP3', MissionText.Message_ShowDocs);
         Level.AddTimer('PSTM', "OnCheckShowPass", 1.0, true );
      end
    end
  elseif (zone == "Cyclotron_Pass" or
          zone == "Cyclotron_NearPass") then
    Level.AddSmallMessage(MissionText.MM_StopMove_Pass, 5.0, 175, 175, 175);
    AI.HandleVoice(npc, "male_usa_stopmove_stopmove_06");
    AI.EnableZone("SearchZone_2",       false);
    AI.EnableZone("SearchAlertZone_2",       true);
    if (Level.PlayerHasPass() == true) then
      if (Level.HasPlayerAction('SHP4') == false) then
         --Level.AddPlayerAction('SHP4', MissionText.Message_ShowDocs, "Level", false );
         Level.SafeAddLevelPlayerAction('SHP4', MissionText.Message_ShowDocs);
         Level.AddTimer('PSTM', "OnCheckShowPass", 1.0, true );
      end
    end
  elseif (zone == "BombArea" or
          zone == "BombAreaEnter2" or
          zone == "SafeArea" or
          zone == "SafeAreaEnter2" or
          zone == "WorkersSklad" or
          zone == "WorkersSkladEnter" or
          zone == "Cyclotron" or
          zone == "CyclotronEnter" or
          zone == "CyclotronObservation" or
          zone == "CyclotronObservationEnter") then
    Level.AddSmallMessage(MissionText.MM_StopMove_Lab, 5.0, 175, 175, 175);
    AI.HandleVoice(npc, "male_usa_ohers_stop_02");
  elseif (zone == "WorkersSkladEnterBox") then
    Level.AddSmallMessage(MissionText.MM_StopMove_Box, 5.0, 175, 175, 175);
    AI.HandleVoice(npc, "male_usa_panic_panic_08");
  elseif (zone == "ColonelRoom_Near") then
    Level.AddSmallMessage(MissionText.MM_StopMove_ColonelRoom, 5.0, 175, 175, 175);
    AI.HandleVoice(npc, "male_usa_ohers_stop");
    if (playerForm == "Scientist" or
        playerForm == "Professor") then
      if (Level.PlayerHasPermit() == true) then
        if (Level.HasPlayerAction('SHP5') == false) then
           --Level.AddPlayerAction('SHP5', MissionText.Message_ShowDocs, "Level", false );
           Level.SafeAddLevelPlayerAction('SHP5', MissionText.Message_ShowPermit);
           Level.AddTimer('PSTM', "OnCheckShowPass", 1.0, true );
        end
      end
    end
  elseif (zone == "GeneratorRoom" or
          zone == "Lab_Nums" or
          zone == "Lab_Nums2") then
    if (class == "civilian_woman" or
        class == "enemy_woman") then
      Level.AddSmallMessage(MissionText.MM_StopMove_Office, 5.0, 175, 175, 175);
      AI.HandleVoice(npc, "female_usa_stopmove_stopmove");
    else
      Level.AddSmallMessage(MissionText.MM_StopMove_Office, 5.0, 175, 175, 175);
      AI.HandleVoice(npc, "male_usa_stopmove_stopmove");
    end
  elseif (zone == "ConferenceRoom" or
          zone == "GuardRoom") then
    Level.AddSmallMessage(MissionText.MM_StopMove_LeaveRoom, 5.0, 175, 175, 175);
    AI.HandleVoice(npc, "male_usa_stopmove_stopmove_03");
  elseif (zone == "Offices") then
    if (class == "civilian_woman" or
        class == "enemy_woman") then
      Level.AddSmallMessage(MissionText.MM_StopMove_Office2, 5.0, 175, 175, 175);
      AI.HandleVoice(npc, "female_usa_stopmove_stopmove_03");
    else
      Level.AddSmallMessage(MissionText.MM_StopMove_Office2, 5.0, 175, 175, 175);
      AI.HandleVoice(npc, "male_usa_stopmove_stopmove_07");
    end
  elseif (zone == "SearchZone_1") then
    if (Level.GetSearchMan() == nil) then
       local playerPosition = Level.GetPlayerPosition();
       local npcPosition = Level.GetNpcPosition(npc);
       AI.EnableZone("SearchAlertZone_1", true);
       local disableZoneString = "AI.EnableZone('SearchAlertZone_1', false)";
       Level.RemoveDpc(disableZoneString);
       Level.InstallDpc(disableZoneString, 20.0);
       Level.SearchZoneName = zone;
       Level.AddSmallMessage( MissionText.MM_StopMove_Search, 5.0, 175, 175, 175 );
       AI.HandleVoice( npc, "male_usa_script_script_37");
       Level.InitSearchScript(npc);
       Level.HadForbidObjects = Level.HasForbidObjects();
    else
       Level.AddSmallMessage( MissionText.MM_StopMove_SearchFail, 5.0, 175, 175, 175 );
       AI.HandleVoice( npc, "male_usa_script_script_38");
    end
  elseif (zone == "SearchZone_2") then
    local playerPosition = Level.GetPlayerPosition();
    local npcPosition = Level.GetNpcPosition(npc);
    Level.SearchZoneName = zone;
    Level.AddSmallMessage( MissionText.MM_StopMove_Search, 5.0, 175, 175, 175 );
    AI.HandleVoice( npc, "male_usa_script_script_37");
    Level.InitSearch2Script(npc);
    Level.HadForbidObjects = Level.HasForbidObjects();
  elseif (zone == "NoWeapon") then
    Level.AddSmallMessage( MissionText.MM_StopMove_SearchFail, 5.0, 175, 175, 175 );
    AI.HandleVoice( npc, "male_usa_script_script_38");
  end
end
