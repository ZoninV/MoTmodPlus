
  MissionText = 
  {
      --Mission text
      Task_1                          = " Найти капитана";
      Task_2                          = " Освободить капитана";
      Task_3                          = " Покинуть замок";
      Task_4                          = " Вывести капитана";
      Message_2                       = "Задания обновлены";
      Message_3                       = "Задания изменены";
      Message_4                       = "Задание выполнено : Ликвидировать Полякова";
      Message_Alarm                   = "Поднята тревога. Охрана стала более внимательна.";
      Message_AlarmFinished           = "Охрана успокоилась.";
      Docs_Access                     = "Разрешение на доступ к заключенному";
      Docs_Extra                      = "Бумаги для вызова на допрос";
      Message_ShowEnterDocument       = "РАЗРЕШЕНИЕ НА ДОСТУП";
      Message_ShowExtraditionDocument = "ВЫЗВАТЬ НА ДОПРОС";
      Message_MoveSpy                 = "Капитана отконвоируют к офицеру на допрос (синяя отметка).";
      Message_Move                    = "ИДЕМ";
      Message_Stop                    = "ЖДИ ЗДЕСЬ";
      Message_Key                     = "Ключ от камер";
      Message_SpyWaitThink            = "Вернитесь за капитаном";

      Message_PassName                = "Разрешение на доступ к тюремным камерам";
      Message_PassNameL               = "ПРОПУСК В ТЮРЬМУ";
      Message_ShowDocs                = "ПОКАЗАТЬ ПРОПУСК";
      Message_LureCommendat           = "ОТВЛЕЧЬ КОМЕНДАНТА";
      Message_BrakeRadio              = "ЗАМКНУТЬ РАДИО";
      Message_Poison                  = "ОТРАВИТЬ";
      Poison_Need                     = "! Нужен яд, чтобы отравить.";
      Message_WorkerRadioHelp         = "Возможно, вам будет проще настроить радио, если вы оденетесь как рабочий...";
      Message_SpyAlert                = "! Охрана заметила Полякова и собирается поднять тревогу!";
      Message_KeyReceived             = "Вам выдан ключ от камер.";

      -- Liz Shaw
      MM_StopMove_CIV           = "@ Доступ в эту часть здания разрешен только солдатам и офицерам СС!";
      MM_StopMove_WKR           = "@ Рабочим здесь не место!";
      MM_StopMove_YLLW          = "@ Этот тюремный блок закрыт! Покажите нам ваше разрешение на доступ!";
      MM_StopMove_NoEntry       = "@ Этот тюремный блок закрыт!";
      MM_StopMove_PassDocs      = "@ У вас есть разрешение находиться здесь?";
      MM_StopMove_NoPrisoners   = "@ В этом тюремном блоке на данный момент нет заключенных!";
      MM_StopMove_DocsClear     = "@ Все в порядке, пожалуйста, проходите.";
      MM_StopMove_DocsClearYLLW = "@ Вы можете увидеться с ним, но он не должен покидать свою камеру.";
      MM_StopMove_NearConf      = "@ В зале проходит совещание офицеров!";
      MM_StopMove_Conf_SOL      = "@ Немедленно покиньте зал совещания!";
      MM_StopMove_Conf_OFF      = "@ Что вы здесь делаете?";
      MM_StopMove_NearIntrg     = "@ Я не могу пустить вас в эту комнату!";
      MM_StopMove_Intrg         = "@ Что вы здесь делаете? Это моя комната!";
      MM_StopMove_Comendat      = "@ Коменданта нельзя беспокоить, если только клерк не сообщит нам о выступлении пианиста!";
      MM_StopMove_ComendatCIV   = "@ Скоро начнется выступление пианиста?";
      MM_StopMove_Chapel        = "@ Вход в часовню запрещен!";
      MM_StopMove_NearCellar    = "@ Вам нечего делать в винном погребе!";
      MM_StopMove_Cellar        = "@ Эй! Вам сюда нельзя!";
      MM_StopMove_NearRadio     = "@ Я не могу пустить вас в радиорубку!";
      MM_StopMove_Radio         = "@ Немедленно покиньте радиорубку!";
      MM_StopMove_DiningRoom    = "@ В настоящее время столовая закрыта на уборку!";
      MM_StopMove_NearBedroom   = "@ Вам нечего делать в этой комнате!";
      MM_StopMove_Bedroom       = "@ Убирайтесь отсюда!";
      MM_StopMove_Nums          = "@ У нас тут совещание! Пожалуйста, уходите!";
      MM_StopMove_NearTeaRoom   = "@ Нам приказано впускать только клерка!";
      MM_StopMove_TeaRoom_SOL   = "@ Покиньте комнату немедленно!";
      MM_StopMove_TeaRoom_OFF   = "@ Что вы здесь делаете? Нас нельзя беспокоить!";
  };

  function Level.OnCompleteMission()

      System:ConsoleCommand( 'l_loadlevel "rolik_lubyanka" 7' );

  end;

  function Level.OnFinishLoad()

      -- forlik System:SetVar( "r_glow", true );
      -- forlik System:SetVar( "r_glow_r", 2.0 );
     Level.OnFinishLoad_Common(); -- forlik
     Level.SetDOFPostFilter( 1, 0.0, 1600.0, 3500.0 ); --forlik

      --- init music

      Level.AddMusic( Level.MUSIC_MOOD_ATTENTION   , "#0.50#sounds\\music\\danger.ogg");
      Level.AddMusic( Level.MUSIC_MOOD_ACTION, "#0.50#sounds\\music\\insurgent.ogg" );
      Level.AddMusic( Level.MUSIC_MOOD_DEFAULT, "#0.50#sounds\\music\\imbroken03.ogg" );

      local cameraDoor = Level.FindDoor('CAMD');

      if ( cameraDoor != nil ) then
        Level.SetDoorNotifyScript( cameraDoor , true );       
      end;

      Level.SpyActor     = Level.FindActor('GSPY');

      Level.SetDoorUnlockKey(Level.FindDoor('CAMD'), 'KEY1');
      Level.SetDoorUnlockKey(Level.FindDoor('DR01'), 'KEY1');
      Level.SetDoorUnlockKey(Level.FindDoor('DR02'), 'KEY1');
      Level.SetDoorUnlockKey(Level.FindDoor('DR03'), 'KEY1');
      Level.SetDoorUnlockKey(Level.FindDoor('DR04'), 'KEY1');
      Level.SetDoorUnlockKey(Level.FindDoor('DR05'), 'KEY1');
      Level.SetDoorUnlockKey(Level.FindDoor('DR06'), 'KEY1');
      Level.SetDoorUnlockKey(Level.FindDoor('DR07'), 'KEY1');
      Level.SetDoorUnlockKey(Level.FindDoor('DR08'), 'KEY1');
      Level.SetDoorUnlockKey(Level.FindDoor('DR09'), 'KEY1');
      Level.SetDoorUnlockKey(Level.FindDoor('DR10'), 'KEY1');

      Level.LeaveTrigger = Level.FindTrigger( 'LeaveTrigger' );

      -- patch
      local backpack = Level.FindContainer();
      if (backpack != nil) then
          Level.EnableItemPickup(backpack, true);
      end

  end;

  function Level.OnSave()

     Stream.WriteBool( Level.SpyKilled );
     Stream.WriteBool( Level.SpyMoving );
     Stream.WriteBool( Level.TimerInstalled );
     Stream.WriteBool( Level.MarkRemoved );

     Stream.WriteBool( Level.EnterDocumentShowed );
     Stream.WriteBool( Level.ExtraditionDocumentShowed );
     Stream.WriteBool( Level.RoomTrigger_1 );

     Stream.WriteInt ( Level.ComendatFormId ); 
     Stream.WriteBool( Level.SpyCheckGuards );
     Stream.WriteBool( Level.AtCameraTrigger );

     Stream.WriteBool( Level.AlertCalled ); -- Liz Shaw

     Stream.WriteBool( Level.TeaPoisson );
     Stream.WriteBool( Level.StationBroken );
     Level.WriteArray( Level.SaySpyAlertAnchors );

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

     Level.SpyKilled                 = Stream.ReadBool();
     Level.SpyMoving                 = Stream.ReadBool();
     Level.TimerInstalled            = Stream.ReadBool();
     Level.MarkRemoved               = Stream.ReadBool();

     Level.EnterDocumentShowed       = Stream.ReadBool();
     Level.ExtraditionDocumentShowed = Stream.ReadBool();
     Level.RoomTrigger_1             = Stream.ReadBool();

     Level.ComendatFormId            = Stream.ReadInt();
     Level.SpyCheckGuards            = Stream.ReadBool();
     Level.AtCameraTrigger           = Stream.ReadBool();

     Level.AlertCalled               = Stream.ReadBool(); -- Liz Shaw

     Level.TeaPoisson                = Stream.ReadBool();
     Level.StationBroken             = Stream.ReadBool();
     Level.SaySpyAlertAnchors        = Level.ReadArray();

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
     System:SaveGame( "_krasavitca_" .. tostring(nextSlot) .. ".asv" , false );
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

     System:LoadGame( "_krasavitca_" .. tostring(slot) .. ".asv" , true );

     return true;

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

  function Level.OnLoaded()

     Level.OnLoaded_Common(); -- forlik

     Level.SoundName  = { "radioger01" };
     Level.SoundState = { true };

     Level.AddMissionTask( MissionText.Task_1, 'FIND', "levels\\krasavitca\\find_task.txt", 1);
     Level.AddMissionTask( MissionText.Task_2, 'RELS', "levels\\krasavitca\\get_task.txt" );

     Level.AddActionHandler( Level.AH_ACTOR_KILLED , "GSPY" , "OnKilledSpy");
     Level.AddActionHandler( Level.AH_FINISH_CHANGECLOTH, "OFF1", "OnChangeOfficerCloth" );
     Level.AddActionHandler( Level.AH_FINISH_CHANGECLOTH, "CIV2", "OnChangeClerkCloth" );
     Level.AddActionHandler( Level.AH_FINISH_CHANGECLOTH, "WKR2", "OnChangeWorkerCloth" );
     Level.AddActionHandler( Level.AH_FINISH_CHANGECLOTH, "GCOM", "OnComendatCloth" );

     Level.AddActionHandler( Level.AH_FOLLOW_WAIT_THINK , "GSPY" , "OnFollowWaitThink");

     Level.SpyKilled      = false;
     Level.SpyMoving      = false;
     Level.TimerInstalled = false;
     Level.MarkRemoved    = false;

     Level.SpyCheckGuards = true;

     Level.EnterDocumentShowed       = false;
     Level.ExtraditionDocumentShowed = false;

     Level.RoomTrigger_1   = false;
     Level.AtCameraTrigger = false;

     Level.AlertCalled     = false; -- Liz Shaw

     Level.TeaPoisson      = false;
     Level.StationBroken   = false;
     Level.SaySpyAlertAnchors     = { 'AN72', 'AN73', 'AN74', 'AN75', 'AN76', 'AN77', 'AN78', 'AN79', 'AN80', 'AN81', 'AN83', 'AN84', 'AN85', 'AN86', 'AN88', 'AN89', 'AN90', 'AN92' };

     local comendat = Level.FindActor( 'GCOM' );
   
     if ( comendat != nil ) then
        Actor.MarkAsTarget( comendat , true );
        Level.ComendatFormId = Actor.GetWearFormId( comendat );
     else
        Level.ComendatFormId = 0;
     end;

     local spy = Level.FindActor( 'GSPY' );
     if ( spy != nil ) then
       Actor.SetMapHidden( spy, true );
     end;

     NPC.SetFlag( AI.FindNPC('GSPY'), NPC.F_CANT_OPEN_LOCK_DOOR, true );
     -- access docs

     local access_docs = Level.CreateItem( "Custom" , "Equipment" );
     if ( access_docs != nil ) then

       Entity.SetUniqueID( access_docs, 'ADOC' );

       Level.SetCustomItemName( access_docs, MissionText.Docs_Access );
       Level.SetCustomItemIcon( access_docs, "ammo_doc" );
     
       local officer = Level.FindActor('GO05');
       if ( officer != nil ) then
         Actor.PutPouch( officer, Actor.GetEmptyPouch(officer), access_docs );
         Actor.MarkAsTarget( officer, true );
       end;

     end;

     local dopros_docs = Level.CreateItem( "Custom", "Equipment" );
     if ( dopros_docs != nil ) then
       Entity.SetUniqueID( dopros_docs, 'DDOC' );

       Level.SetCustomItemName( dopros_docs, MissionText.Docs_Extra );
       Level.SetCustomItemIcon( dopros_docs, "ammo_doc" );

       local officer = Level.FindActor('ZO16' );
       if ( officer != nil ) then
          Actor.PutPouch( officer, Actor.GetEmptyPouch(officer), dopros_docs );
          Actor.MarkAsTarget( officer, true );
       end;

     end;

     local pass = Level.FindItem('PAS1');
     if ( pass != nil ) then
       Entity.SetUniqueID( pass, 'PASS' );
       Entity.SetName( pass, MissionText.Message_PassNameL );
       Level.SetCustomItemName( pass, MissionText.Message_PassName );       
     end;

     local pass = Level.FindItem('PAS2');
     if ( pass != nil ) then
       Entity.SetUniqueID( pass, 'PASS' );
       Entity.SetName( pass, MissionText.Message_PassNameL );
       Level.SetCustomItemName( pass, MissionText.Message_PassName );       
     end;

     local pass = Level.FindItem('PAS3');
     if ( pass != nil ) then
       Entity.SetUniqueID( pass, 'PASS' );
       Entity.SetName( pass, MissionText.Message_PassNameL );
       Level.SetCustomItemName( pass, MissionText.Message_PassName );       
     end;

     NPC.SetFlag( AI.FindNPC('GSPY'), NPC.F_CANT_OPEN_LOCK_DOOR, true );

     Level.AddKey('GRD1', 'KEY1', MissionText.Message_Key);
     Level.AddKey('GRD2', 'KEY1', MissionText.Message_Key);
     Level.AddKey('GO01', 'KEY1', MissionText.Message_Key);
     Level.AddKey('GO02', 'KEY1', MissionText.Message_Key);
     Level.AddKey('GS08', 'KEY1', MissionText.Message_Key);
     Level.AddKey('GS11', 'KEY1', MissionText.Message_Key);
     Level.AddKey('GS12', 'KEY1', MissionText.Message_Key);
     Level.AddKey('GS13', 'KEY1', MissionText.Message_Key);
     Level.AddKey('GS14', 'KEY1', MissionText.Message_Key);
     Level.AddKey('GS19', 'KEY1', MissionText.Message_Key);
     Level.AddKey('GS20', 'KEY1', MissionText.Message_Key);
     Level.AddKey('GS23', 'KEY1', MissionText.Message_Key);
     Level.AddKey('GS24', 'KEY1', MissionText.Message_Key);
     Level.AddKey('GS25', 'KEY1', MissionText.Message_Key);
     Level.AddKey('GS26', 'KEY1', MissionText.Message_Key);

     Level.EnableLevelMark('POIS', true);

     if (Level.GetDifficulty() != 3) then
       Level.EnableLevelMark('OFF1', true);
       Level.EnableLevelMark('CIV2', true);
       Level.EnableLevelMark('WKR2', true);
       Level.EnableLevelMark('PAS1', true);
       Level.EnableLevelMark('PAS2', true);
       Level.EnableLevelMark('PAS3', true);
     end;

     --- init player

     local player     = Level.FindActor('PLYR');
     if ( player != nil ) then

       Actor.ChangeActorSkin( player, "Summer" );
       Level.ChangePlayerStand( 2 );

       if ( Level.HasPlayerEquipPack() == false ) then

         local machineGun = Level.CreateItem("delisle","Weapon");
         local pistol     = Level.CreateItem("NaganSilencer","Weapon");
         local knife      = Level.CreateItem("knife","Weapon");

         Actor.PutWeapon( player, Actor.WEAPON_SLOT_PISTOL , pistol );
         Actor.PutWeapon( player, Actor.WEAPON_SLOT_MACHINEGUN, machineGun );
         Actor.PutWeapon( player, Actor.WEAPON_SLOT_KNIFE, knife );

         Actor.PutWeaponAmmo( player, "delisle");
         Actor.PutWeaponAmmo( player, "nagan");
         Actor.PutWeaponAmmo( player, "nagan");
         Actor.PutWeaponAmmo( player, "nagan");
 
         Actor.PutEmptyPouch( player, "f1", "Weapon" );
         Actor.PutEmptyPouch( player, "f1", "Weapon" );
         Actor.PutEmptyPouch( player, "f1", "Weapon" );

         Actor.PutEmptyPouch( player, "lockpick", "Equipment" );
         Actor.PutEmptyPouch( player, "fiberwire", "Weapon"  );

       end;

     end;

     Level.EnableNotifyPickup( Level.FindItem('POIS'), true );

     Level.SetupPass();

     Level.AddActionHandler( Level.AH_PLAYER_INVENTORY );

     Level.EnableItemPickup( Level.FindItem('T303'), false );
     Level.EnableItemPickup( Level.FindItem('T304'), false );
     Level.EnableItemPickup( Level.FindItem('T305'), false );

     local form = Level.FindItem( 'CIV1' );
     if (form != nil) then
       AI.RegisterWearForm( form, "CIV1" );          
     end;

     local form = Level.FindItem( 'WKR1' );
     if (form != nil) then
       AI.RegisterWearForm( form, "WKR1" );          
     end;

     Level.AddActionHandler( Level.AH_FINISH_CHANGECLOTH, "CIV1", "OnChangeClerkCloth" );
     Level.AddActionHandler( Level.AH_FINISH_CHANGECLOTH, "WKR1", "OnChangeWorkerCloth" );

     local diff = Level.GetDifficulty();
     if (diff == 0 or
         diff == 1 or
         diff == 3) then

        -- forlik Level.StartCustomAnimationJob('GO14', "Act_ProjectY_WatchDevice", -42.0, -1.0, 662.5, -1.0, 0.0, 0.0);
        Level.StartCustomAnimationJob('GO14', "Act_ProjectY_WatchDevice", -42.0, -5.0, 662.5, -1.0, 0.0, 0.0);
        Level.StartCustomAnimationJob('GS48', "Relaxed_Idle_Guard", 32.35, 80.9, 1026.9, 0.0, 0.0, -1.0);

        if ( diff == 0 or
             diff == 3 ) then
           Level.StartCustomAnimationJob('GS67', "Relaxed_Idle_Guard", 244.17, -5.0, 1105.19, 0.0, 0.0, -1.0);
        end

     end

     if (Level.GetDifficulty() == 1) then
        AI.SetJob(AI.FindNPC('GS10'), "default");
     end

     if (Level.GetDifficulty() != 2) then
        AI.SetJob(AI.FindNPC('ZF02'), "default");
     end

     if (Level.GetDifficulty() == 2) then
        AI.SetForm(AI.FindNPC('SS55'), "SOL4");
     end

     local diff = Level.GetDifficulty();
     if (diff == 0 or
         diff == 1 or
         diff == 2) then

         AI.SetJob(AI.FindNPC('G103'), "guard");
     end;

     AI.OnPlayerEnterZone("global", 'GLSC'); -- forlik

     AI.EnableZone("mmZoneB3", false);
     AI.EnableZone("mmZoneC2", false);
     AI.EnableZone("InterrogationRoom_GSpy", false);
     AI.EnableZone("InterrogationRoom_Near", false);

     AI.Enable("notify_see_custom_actor"); -- Liz Shaw
     Level.OnFinishLoad();
     Level.AutoSave();

  end;

  AI.DoFile( "scripts:Levels\\Common.lua", false ); -- forlik

  function Level.OnComendatCloth()
     Level.EnableLevelMark('YOFS' , false );
  end;

  function Level.CompleteTaskFind()

    if ( Level.IsMissionTaskCompleted('FIND') == true ) then
       return;
    end;

    if ( Level.IsMissionFailed() == true ) then
       return; 
    end;

    Level.PlayMenuSound("task_finish"); -- Liz Shaw
    Level.CompleteMissionTask('FIND', 15.0 );
    Level.EnableLevelMark( 'TUR1', false );
    Level.EnableLevelMark( 'TUR2', false );

    --Level.MarkRemoved = true;
    --Level.RemoveActionHandler( Level.AH_PLAYER_INVENTORY );

    local spy = Level.FindActor('GSPY');

    if ( spy != nil ) then
       Actor.MarkAsTarget( spy, true );
       Actor.SetMapHidden( spy, false );
    end;

    Level.AddPlayerActorAction( 'MOVE', 'GSPY', MissionText.Message_Move, "OnActorPlayerAction" , false, true );
    Level.AutoSave();

  end;

  function Level.OnInventoryChanged()

    if ( Level.MarkRemoved == false ) then

      local player = Level.GetPlayer();

      local adoc = false;
      local ddoc = false;
      
      if ( Actor.HasCustomEquipment( player, 'ADOC' ) ) then

         AI.StartDecamouflage( 50.0, 100.0, 3.0 );
         Level.EnableLevelMark( 'ADOC', false );

         adoc = true;

      end;

      if ( Actor.HasCustomEquipment( player, 'DDOC' ) ) then

         AI.StartDecamouflage( 50.0, 100.0, 3.0 );
         Level.EnableLevelMark( 'DDOC', false );

         ddoc = true;

      end;

      if ( adoc == true and ddoc == true ) then     

         Level.RemoveActionHandler( Level.AH_PLAYER_INVENTORY );
         Level.MarkRemoved = true;

      end;

    else

      Level.RemoveActionHandler( Level.AH_PLAYER_INVENTORY );
      Level.MarkRemoved = true;

    end;

    -- Liz Shaw
    if (Level.PlayerHasPass() == true) then
       Level.EnableLevelMark('PAS1', false);
       Level.EnableLevelMark('PAS2', false);
       Level.EnableLevelMark('PAS3', false);
    end;

  end;

  function Level.CompleteTaskFree()

    if ( Level.IsMissionFailed() != false or Level.IsMissionTaskCompleted('RELS') == true ) then
      return;
    end;

    Level.AddMissionTask( MissionText.Task_4, 'OUTS', "levels\\krasavitca\\out_task.txt", 2 );
    Level.PlayMenuSound("task_finish"); -- Liz Shaw
    Level.CompleteMissionTask('RELS', 15.0 );
    Level.AddLargeMessage( MissionText.Message_2, 15.0, 255, 255, 255 );

    Level.EnableLevelMark( 'OUTS', true );
    Level.EnableLevelMark( 'DDOC', false );
    Level.EnableLevelMark( 'ADOC', false );
    Level.EnableLevelMark( 'YOFS', false );
    Level.EnableLevelMark( 'DEST', false );

    Level.MarkRemoved = true;
    Level.RemoveActionHandler( Level.AH_PLAYER_INVENTORY );
    Level.AutoSave();

  end;

  function Level.OnOpenDoor( door )

   if ( door == 'CAMD' ) then

      Level.CompleteTaskFree();

      local cameraDoor = Level.FindDoor('CAMD');

      if ( cameraDoor != nil ) then
        Level.SetDoorNotifyScript( cameraDoor , false );
      end;

   end;

  end;

  function Level.OnCloseDoor( door )

  end;  

  function Level.HasAccessDocs()

      local player = Level.GetPlayer();
      if ( player == nil ) then
         return;
      end;

      return Actor.HasCustomEquipment( player, 'ADOC' );

  end;

  function Level.HasInterrogationDocs()
      local player = Level.GetPlayer();
      if ( player == nil ) then
         return;
      end;

      return Actor.HasCustomEquipment( player, 'DDOC' );
 
  end;

  function Level.OnKilledSpy()

    if ( Level.IsMissionFailed() != false ) then
      return;
    end;

    if ( Level.SpyKilled == true ) then
      return;
    end;

    Level.AddMissionTask( MissionText.Task_3, 'LEAV', "levels\\krasavitca\\leav_task.txt", 2 );
    Level.RemoveMissionTask( 'OUTS' );
    Level.EnableLevelMark('OUTS',false );

    if ( Level.IsMissionTaskCompleted('RELS') == false ) then
         Level.RemoveMissionTask('RELS');
    end;

    -- PATCH
    if (Level.IsMissionTaskCompleted('FIND') == false) then
         Level.RemoveMissionTask('FIND');
    end;

    Level.AddLargeMessage( MissionText.Message_4, 15.0, 255, 255, 255 );
    Level.AddLargeMessage( MissionText.Message_3, 15.0, 255, 255, 255 );

    Level.SpyKilled = true;

    if ( Level.LeaveTrigger != nil ) then

      if ( Trigger.IsIntersectNode( Level.LeaveTrigger, Entity.GetNode( Level.GetPlayer() ) ) == true ) then

          Level.PlayMenuSound("task_finish"); -- Liz Shaw
          Level.CompleteMissionTask('LEAV', 15.0 );

          if ( Level.TimerInstalled == true ) then
            Level.RemoveTimer( 'CHEK' );
            Level.TimerInstalled = false;
          end;

      end;  

    end;

    if (Level.IsMissionTaskCompleted('LEAV') == false) then
       Level.PlayMenuSound("task_finish"); -- Liz Shaw
    end

  end;

  function Level.OnEnterTriggerArea( sender, trgname, trgcmd )

    if ( Level.IsMissionFailed() != false ) then
      return;
    end;

    if ( trgname == 'FindTrigger' ) then

       Level.CompleteTaskFind();
       Level.UnregisterTrigger( Level.FindTrigger( 'FindTrigger' ) );

    elseif ( trgname == 'FindTrigger_2' ) then

       Level.EnableLevelMark( 'TUR2', false );
       Level.UnregisterTrigger( Level.FindTrigger( 'FindTrigger_2' ) );

    elseif ( trgname == 'LeaveTrigger' ) then

         if ( Level.SpyKilled == true ) then
              Level.PlayMenuSound("task_finish"); -- Liz Shaw
              Level.CompleteMissionTask( 'LEAV', 15.0 );
         else

            if ( Level.HasMissionTask('OUTS') == true ) then
                
               local completed = false;

               local player = Level.GetPlayer();
               if ( player != nil ) then

                  completed = Actor.HasPickupedActor( player, 'GSPY');

                  if ( completed == false and Level.SpyActor != nil and Level.LeaveTrigger != nil ) then

                    completed = Trigger.IsIntersectNode( Level.LeaveTrigger, Entity.GetNode( Level.SpyActor ) );
  
                  end;

               end;
 
               if ( completed != false ) then
                 Level.PlayMenuSound("task_finish"); -- Liz Shaw
                 Level.CompleteMissionTask('OUTS', 15.0 );
               else
                 if ( Level.TimerInstalled == false ) then
                   Level.AddTimer( 'CHEK', "OnCheckSpyArea", 0.25, true );
                   Level.TimerInstalled = true;
                 end;
               end;

            end;
        end;

    elseif ( trgname == 'WorkerRadioHintTrigger') then

       if ( (Level.GetDifficulty() != 3) and
            (AI.GetPlayerForm() != "WKR1") and
            (Level.StationBroken == false) ) then
         Level.AddSmallMessage( MissionText.Message_WorkerRadioHelp, 15.0 , 255, 255, 255 );
       end;

    end;

  end;

  function Level.OnLeaveTriggerArea( sender, trgname, trgcmd )

    if ( trgname == 'LeaveTrigger' ) then
        if ( Level.TimerInstalled == true ) then
             Level.RemoveTimer( 'CHEK' );
             Level.TimerInstalled = false;
        end;

    elseif (trgname == "RestoreZonesTrigger") then
       -- restore zones...

       Level.RestoreZones();

    end;

  end;

  function Level.OnCheckSpyArea()

    if ( Level.SpyActor != nil and Level.LeaveTrigger != nil ) then

      if ( Trigger.IsIntersectNode( Level.LeaveTrigger, Entity.GetNode( Level.SpyActor ) ) == true ) then
          Level.PlayMenuSound("task_finish"); -- Liz Shaw
          Level.CompleteMissionTask('OUTS', 15.0 );
          Level.RemoveTimer( 'CHEK' );
          Level.TimerInstalled = false;
      end;  
    end;

  end;

  function Level.FollowPlayer( bWait ) 

    local spy = AI.FindNPC('GSPY');
    local player = Level.FindActor('PLYR');

    if (spy != nil and player != nil) then
      if (AI.IsFollowingActor(spy, player) != false) then
         AI.EnableFollowActorPause(spy, bWait);
      else
        local properties = Level.CreateCustomParams();
        Level.SetValue(properties, "DistanceRun", true);
        Level.SetValue(properties, "ParentPolicy", true);
        Level.SetValue(properties, "IdlePolicy", true);
        Level.SetValue(properties, "FollowActorPause", bWait);
        Level.SetValue(properties, "CriticPathDistance", 270.0);

        AI.FollowActor( spy, player, 0.0, -20.0, properties);

        AI.SetWatchActor( Level.FindActor('GSPY') );
      end
    end

    if (spy != nil and bWait == false) then
       AI.OnPlayerEnterZone("PlayerSpyZone", 'PSZN');
    else
       AI.OnPlayerLeaveZone("PlayerSpyZone", 'PSZN');
    end

  end

  function Level.OnActorPlayerAction( actionId )

    if ( actionId == 'MOVE' ) then

      if ( Level.SpyMoving == false ) then
         Level.FollowPlayer( false );
         Level.SpyMoving = true;
         Level.SetPlayerActorActionDesc( 'MOVE', MissionText.Message_Stop );
  
         if ( Level.IsMissionTaskCompleted('RELS') == false ) then
              Level.CompleteTaskFree();
         end;

      else
         Level.FollowPlayer( true );
         Level.SpyMoving = false;
         Level.SetPlayerActorActionDesc( 'MOVE', MissionText.Message_Move );
      end;

    end;

  end;

 function Level.IsPlayerCommendant()

     local player = Level.GetPlayer();
     if ( player == nil ) then
        return false;
     end;

     if ( Actor.GetWearFormId( player ) == Level.ComendatFormId ) then
        return true;
     else
        return false;
     end;
  end


  function Level.OnFinishAlert( alertGroupId )
     
     AI.Debug(nil, "Level.OnFinishAlert", "group", alertGroupId);
     AI.SetLocalAlert( alertGroupId, false );

     local alertLast = true;
     for i = 1, 8, 1 do
        if (AI.IsLocalAlert( i ) != false) then
           alertLast = false;
        end
     end

     if (alertLast != false) then
        AI.Debug(nil, "Level.OnFinishAlert", "EnableAlarmSound:false");

        Level.AddSmallMessage( MissionText.Message_AlarmFinished, 10.0, 255, 255, 0);

        Level.AlertCalled = true;
     end 
  end

  function Level.OnAlert( alertGroupId )

    AI.Debug(nil, "Level.OnAlert", "group", alertGroupId);

    Level.AddSmallMessage( MissionText.Message_Alarm, 10.0, 255, 0, 0);

    AI.SetLocalAlert(1, true, AI.TransformAlertTime(300));
    AI.SetLocalAlert(2, true, AI.TransformAlertTime(300));
    AI.SetLocalAlert(3, true, AI.TransformAlertTime(300));
    AI.SetLocalAlert(4, true, AI.TransformAlertTime(300));
    AI.SetLocalAlert(5, true, AI.TransformAlertTime(300));
    AI.SetLocalAlert(6, true, AI.TransformAlertTime(300));
    AI.SetLocalAlert(7, true, AI.TransformAlertTime(300));
    AI.SetLocalAlert(8, true, AI.TransformAlertTime(300));

    Level.AlertCalled = true;

    local diff = Level.GetDifficulty();
    if (diff == 0) then

        AI.SetJob(AI.FindNPC('GS50'), "default");
    end;

    AI.SetJob(AI.FindNPC('ZS53'), "alert");
    AI.SetJob(AI.FindNPC('ZS54'), "alert");
    AI.SetJob(AI.FindNPC('ZS55'), "alert");

    if (alertGroupId == 8) then

       AI.SafeFind(AI.FindNPC('SS60'), true);
       AI.SafeFind(AI.FindNPC('SS63'), true);
       AI.SafeFind(AI.FindNPC('SS64'), true);
       AI.SafeFind(AI.FindNPC('SS65'), true);

       AI.SetJob(AI.FindNPC('SS60'), "alert");
       AI.SetJob(AI.FindNPC('SS63'), "alert");
       AI.SetJob(AI.FindNPC('SS64'), "alert");
       AI.SetJob(AI.FindNPC('SS65'), "alert");

       AI.SetJob(AI.FindNPC('GS75'), "alert");
       AI.SetJob(AI.FindNPC('ZS69'), "alert");
       AI.SetJob(AI.FindNPC('GS68'), "alert");
       AI.SetJob(AI.FindNPC('GO13'), "alert");
       AI.SetJob(AI.FindNPC('GO14'), "alert");

       AI.AddAlertValue(1);
       AI.SetAttention(AI.AI_TARGET_ALERT_GROUP, "8", AI.ATTENTION_ALARM, true);

    elseif (alertGroupId == 1 or
            alertGroupId == 2 or
            alertGroupId == 3 or
            alertGroupId == 4) then

       AI.SetAttention(AI.AI_TARGET_ALERT_GROUP, "2", AI.ATTENTION_ALARM, true);
       AI.SetAttention(AI.AI_TARGET_ALERT_GROUP, "3", AI.ATTENTION_ALARM, true);

       AI.SafeFind(AI.FindNPC('GS31'), true);
       AI.SafeFind(AI.FindNPC('GS32'), true);

       AI.SetAttention(AI.AI_TARGET_ALERT_GROUP, "1", AI.ATTENTION_ALARM, true);
       AI.SetAttention(AI.AI_TARGET_ALERT_GROUP, "2", AI.ATTENTION_ALARM, true);
       AI.SetAttention(AI.AI_TARGET_ALERT_GROUP, "3", AI.ATTENTION_ALARM, true);

       AI.AddAlertValue(2);
    end
  end

  function RunS()
    local officer = AI.FindNPC('GO01');

    local properties = Level.CreateCustomParams();
    Level.SetValue(properties, "CustomString_1", 'AN16');
    Level.SetValue(properties, "CustomString_2", 'AN18');
    AI.RunScriptTask(officer, "scripts:job\\AnchorJob2.lua", AI.LOGIC_DEFAULT, properties);
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

  function Level.OnFollowWaitThink()
     Level.AddSmallMessage( MissionText.Message_SpyWaitThink, 10.0, 255, 255, 255 );
  end

--------------------------------------------------------
-- Name: Level.OnExecutePlayerAction()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
  function Level.OnExecutePlayerAction(id, completeUnregisterTrigger ) 
     if (Level.CanAddPlayerAction(id) == nil) then
        return false;
     end

     local onFinishUnregister = false;
       
     -- TODO...
     if (id == "PoissonTrigger") then
              
        if ( Actor.HasCustomEquipment( Level.GetPlayer(), 'POIS' ) == false ) then
           Level.AddSmallMessage( MissionText.Poison_Need, 8.0, 255, 255, 255 );
           return false;        
        end;
        
        if ( Level.StartPlayerCustomAnim("Custom_UsePoison", 0, true, true, 'UPSN') == false ) then
           return false;        
        end;

        if (AI.GetPlayerForm() != "CIV1") then
           AI.StartDecamouflage( 50.0, 100.0, 4.0 );
        end;

        Level.EnableLevelMark('TEAP', false);

     elseif ( id == "BreakStationTrigger") then

        if ( Level.StartPlayerCustomAnim("Custom_Radio", 0, true, true, 'BSTG') == false ) then        
           return false;        
        end;

        if (AI.GetPlayerForm() != "WKR1") then
           AI.StartDecamouflage( 50.0, 100.0, 6.5 );
        end;

        Level.AddPlayerAiSound(10.0);
        Level.EnableLevelMark('RADI', false);

     end;
     
     if ( onFinishUnregister == false ) then
     
        Level.FinishAnimTrigger    = id;
        Level.FinishAnimUnregister = completeUnregisterTrigger;
     
     else
     
        Level.FinishAnimTrigger    = "";
        
        if ( completeUnregisterTrigger == true ) then
        
            local t = Level.FindTrigger( id );
            if ( t != nil ) then            
                Level.UnregisterTrigger( t );            
            end;
        end;
     end;
     
     return true;
     
  end

--------------------------------------------------------
-- Name: Level.CanAddPlayerAction()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
  function Level.CanAddPlayerAction(id)

     -- playing custom animation..
     if ( Level.FinishAnimTrigger != "" ) then
        return nil;     
     end;
     
     if (id == "PoissonTrigger") then
      
        if (Level.TeaPoisson == false) and (AI.FindNPC('ZO16') != nil) then
           return MissionText.Message_Poison;
        end

     elseif ( id == "BreakStationTrigger") then

            if (Level.StationBroken == false) then
               return MissionText.Message_BrakeRadio;
            end
     
     end;

     return nil
  end

--------------------------------------------------------
-- Name: Level.OnLureCommendatTimer()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.OnLureCommendatTimer()
   local npc = AI.FindNearestNpc(AI.TASK_SHOW_STOP_MOVE, "");

   if (npc != nil) then
      local distance = Level.BalanceDistance( Level.GetPlayerPosition(), Level.GetNpcPosition(npc) );

      if (distance < 100.0) then
         return;
      end
   end

   Level.SafeRemoveLevelPlayerAction('LCOM');
   Level.RemoveTimer('LCTM');
end

--------------------------------------------------------
-- Name: Level.OnCheckShowPass()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.OnCheckShowPass()
   local npc = AI.FindNearestNpc(AI.TASK_SHOW_STOP_MOVE, "");

   if (npc != nil) then
      local distance = Level.BalanceDistance( Level.GetPlayerPosition(), Level.GetNpcPosition(npc) );

      if (distance < 100.0) then
         return;
      end
   end

   Level.SafeRemoveLevelPlayerAction('SHP1');
   Level.SafeRemoveLevelPlayerAction('SHP2');
   Level.RemoveTimer('CHSP');
end

--------------------------------------------------------
-- Name: Level.OnFinishPlayerCustomAnim()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
  function Level.OnFinishPlayerCustomAnim(animName, animUniqueId, boolBreaked )
 
     if ( boolBreaked == true ) then
        Level.OnBreakActionTrigger();
        AI.StopDecamouflage();
        Level.StopAllCustomAnimSounds();

        return;
     end;
     
     if (animUniqueId == 'UPSN') then
     
        Level.TeaPoisson = true;
        AI.SetJob(AI.FindNPC('ZO16'), "TeaTime");
        AI.SetJob(AI.FindNPC('ZO17'), "TeaTime");
        AI.SetJob(AI.FindNPC('GS86'), "TeaTime");
        Level.InstallDpc( "Level.RunAnchorJob_Run(AI.FindNPC('ZO17'), 'MM28', true)", 15.5);
        Level.InstallDpc( "AI.SetJob( AI.FindNPC('GS86'), 'PoisonKill')", 25.5 );
        Level.InstallDpc( "AI.SetJob( AI.FindNPC('GS88'), 'PoisonKill')", 25.5 );
        Level.InstallDpc( "AI.EnableZone('mmZoneB1', false)", 30.0 );
        Level.InstallDpc( "AI.EnableZone('mmZoneB2', false)", 30.0 );
        Level.InstallDpc( "AI.EnableZone('mmZoneB3', true)", 30.0 );
        Level.InstallDpc( "AI.SetForm(AI.FindNPC('GS86'), 'SOL1')", 45.0);

        local npc = AI.FindNPC('ZO16');

        AI.SetGameFlag(npc, AI.F_ACCIDENT_BODY, true);
        AI.KillNPC( npc, 15.0 );

     elseif (animUniqueId == 'BSTG') then
        
        Level.StationBroken = true;
        Level.EnableSound('radioger01', false );
        AI.SetJob(AI.FindNPC('GS34'), "RadioBroken");
        AI.SetJob(AI.FindNPC('GO06'), "RadioBroken");
        Level.InstallDpc( "Level.RunAnchorJob(AI.FindNPC('GO05'), 'MM39', true)", 2.0);
        Level.InstallDpc( "AI.HandleVoice( AI.FindNPC('GO05'), 'male_ger_ohers_chto_proizoshlo');", 2.0);
        Level.InstallDpc( "Level.RunAnchorJob_Run(AI.FindNPC('GO06'), 'MM40', true)", 25.5);
        Level.InstallDpc( "AI.SetJob( AI.FindNPC('GS34'), 'BreakRadioKill')", 25.5 );
        Level.InstallDpc( "AI.EnableZone('mmZoneC1', false)", 25.5 );
        Level.InstallDpc( "AI.EnableZone('mmZoneC2', true)", 25.5 );
        
     end;
     
     if ( Level.FinishAnimTrigger != "" and Level.FinishAnimUnregister == true ) then
     
         local t = Level.FindTrigger( Level.FinishAnimTrigger );
         if ( t != nil ) then
            Level.UnregisterTrigger( t );         
         end;
            
     end;
     
     Level.FinishAnimTrigger    = "";
     Level.FinishAnimUnregister = false;
     
     Level.PlayerAnimSounds     = {};
       
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

--------------------------------------------------------
-- Name: Level.NeedEnableMark()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.NeedEnableMark(markId)

   --print('NeedEnableMark ' .. tostring( markId ) );

   if (markId == 'TEAP') then
      return (Level.TeaPoisson == false) and (AI.FindNPC('ZO16') != nil);
   elseif (markId == 'RADI') then
      return (Level.StationBroken == false) and (AI.FindNPC('GO05') != nil);
   end
   
   return true;
end

--------------------------------------------------------
-- Name: Level.SetupPass()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.SetupPass()

   local passActors = { 'GRD1', 'GRD2', 'GS08', 'GS11', 'GS12', 'GS13',
                        'GS14', 'GS19', 'GS20', 'GS23', 'GS24', 'GS25',
                        'GS26', 'GS29', 'GS30', 'GS31', 'GS32', 'GS61',
                        'GS62', 'G100', 'G101'
                      };

   local n = table.getn(passActors);

   for i = 1, n do

      local docs = Level.CreateItem( "Custom" , "Equipment" );

      if ( docs != nil ) then

          Entity.SetUniqueID( docs, 'PASS' );

          Level.SetCustomItemName( docs, MissionText.Message_PassName );
          Level.SetCustomItemIcon( docs, "ammo_doc" );
     
          local soldier = Level.FindActor( passActors[i] );
          if ( soldier != nil ) then 
             Actor.PutPouch( soldier, Actor.GetEmptyPouch(soldier), docs );
          end
      end
   end
end

--------------------------------------------------------
-- Name: Level.PlayerHasPass()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.PlayerHasPass()
   return Actor.HasCustomEquipment(Level.GetPlayer(), 'PASS') == true;
end

--------------------------------------------------------
-- Name: Level.OnChangeOfficerCloth()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.OnChangeOfficerCloth()
    
   local player = Level.GetPlayer();
   if ( player != nil ) then
     Actor.EnableMesh( player, "mesh_glasses" , false );     
   end;
   Level.EnableLevelMark('OFF1', false);
   Level.RemoveActionHandler(Level.AH_FINISH_CHANGECLOTH, 'OFF1');

end;

--------------------------------------------------------
-- Name: Level.OnChangeClerkCloth()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.OnChangeClerkCloth()
  Level.EnableLevelMark('CIV2', false);
  Level.RemoveActionHandler(Level.AH_FINISH_CHANGECLOTH, 'CIV2');
end

--------------------------------------------------------
-- Name: Level.OnChangeWorkerCloth()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.OnChangeWorkerCloth()
  Level.EnableLevelMark('WKR2', false);
  Level.RemoveActionHandler(Level.AH_FINISH_CHANGECLOTH, 'WKR2');
end

--------------------------------------------------------
-- Name: Level.OnAnchor_LureCommendat()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.OnAnchor_LureCommendat()
    AI.SetJob(AI.FindNPC('GCOM'), "distraction");

    local properties = {};
    properties["DistanceRun"]    = true;
    properties["ParentPolicy"]   = true;
    properties["WatchCommander"] = true;
    properties["TurnCommander"]  = true;

    AI.FollowActor( AI.FindNPC('GS57'), Level.FindActor('GCOM'), 0.0, -10.0, Level.ToCustomParams(properties));
    Level.InstallDpc( "AI.EnableZone('CommendatRoom', false)", 10.0 );
end

--------------------------------------------------------
-- Name: Level.OnAnchor_MeetClerk()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.OnAnchor_MeetClerk()
    Level.RunAnchorJob( AI.FindNPC('GS93'), 'MM76', true );
end

--------------------------------------------------------
-- Name: Level.OnAnchor_StopCommendat()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.OnAnchor_StopCommendat()
    AI.SetJob(AI.FindNPC('GCOM'), "default");
    Level.InstallDpc( "Level.RunAnchorJob2(AI.FindNPC('GCOM'), 'MM78', 'MM79', true)", 2.0);
    Level.InstallDpc( "AI.SetJob( AI.FindNPC('GS57'), 'default')", 20.0 );
    Level.InstallDpc( "AI.EnableZone('CommendatRoom', true)", 25.0 );
    Level.InstallDpc( "AI.EnableZone('CommendatRoom_Near', true)", 60.0 );
end

--------------------------------------------------------
-- Name: Level.OnAnchor_SendGuard()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.OnAnchor_SendGuard()
    AI.SetJob(AI.FindNPC('ZO17'), "PoisonKill");
    Level.RunAnchorJob_Run( AI.FindNPC('GS78'), 'MM31', true );
    AI.SetJob(AI.FindNPC('GS81'), "PoisonKill");
    AI.SetJob(AI.FindNPC('GS82'), "PoisonKill");
end

--------------------------------------------------------
-- Name: Level.OnAnchor_CheckBody()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.OnAnchor_CheckBody()
    AI.SetForm(AI.FindNPC('GS78'), "SOL4");
    AI.SetJob(AI.FindNPC('GS78'), "PoisonKill");
end

--------------------------------------------------------
-- Name: Level.OnUseRadioForce()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.OnUseRadioForce()

 local actor = Level.FindActor('GO05');
 if ( actor != nil ) then
      Actor.ApplyForce( actor, 15000.0, 15000.0, 15000.0 );
 end;
        
end;
  
--------------------------------------------------------
-- Name: Level.OnUseRadio()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.OnUseRadio()
   if (Level.StationBroken == true) then

      local npc = AI.FindNPC('GO05');

      AI.SetGameFlag(npc, AI.F_ACCIDENT_BODY, true);
      AI.KillNPC( npc, 0.0, AI.HIT_DAMAGE );
        
      Level.AddTimer( 'URFR', "OnUseRadioForce", 0.05, false );
      
      Level.PlayEffect( "levels\\Krasavitca\\radio_break.sef" , 260.0, -111.1, 816.8 );
      Level.PlayCustomSound('DamageRadio');
   end;
end;

--------------------------------------------------------
-- Name: Level.OnAnchor_MMAnchor40()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.OnAnchor_MMAnchor40()
    AI.SetJob(AI.FindNPC('GO06'), "BreakRadioKill");
end

--------------------------------------------------------
-- Name: Level.SetupSaySpyScript()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.SetupSaySpyScript( npc, msg )
   local job = AI.GetScriptJob("TASK_SCRIPT_CALL_ALERT");
   if (job != nil) then
       return false;
   end
   
   if (Level.SaySpyAlertAnchors == nil) then
      return false;
   end
   
   assert(npc != nil, "");
   local anchorId = Level.FindNearestAnchor(Level.SaySpyAlertAnchors, Level.GetNpcPosition(npc));
       
   if (anchorId == nil) then
      return false;
   end
   
   local anchor = AI.FindAnchor(anchorId);
          
   if (anchor == nil) then
      return false;
   end
          
   if (AI.IsAnchorBinded(anchor) == true) then
      return false;
   end
          
   AI.Debug(npc, "See custom actor alert", anchorId);
          
   AI.AnchorBindProtect(anchor, true);

   local properties = Level.CreateCustomParams();
   Level.SetValue(properties, "CustomString_1", anchorId );
		
   Level.AddSmallMessage( msg, 10.0, 255, 0, 0);

   AI.RunScriptTask(npc, "scripts:job\\CallAlert.lua", AI.LOGIC_NEUTRAL, properties);
   
   return true;
end

--------------------------------------------------------
-- Name: Level.OnSeeCustomActor()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.OnSeeCustomActor(npc, actor)
   AI.Debug(npc, "Level.OnSeeCustomActor", "");

   if (Level.AlertCalled == true) then
      return;
   end

   -- This next command is to prevent Polyakov himself from using any of the alert anchors.
   local npcForm = AI.GetForm(npc);
   if (npcForm == "GSPY") then
      return;
   end

   local actorPos = Level.GetEntityPosition( actor );
   local npcPos   = Level.GetNpcPosition( npc );
   local distance = Level.BalanceDistance( npcPos, actorPos );
   
   if (distance < 200.0) then
      AI.SetScriptThreat( npc, 1.0, true, 0.0 );
      
      Level.SetupSaySpyScript( npc, MissionText.Message_SpyAlert );
   else
   
      local job = AI.GetScriptJob("TASK_SCRIPT_CALL_ALERT");
      if (job == nil) then
         local threat = saturate(1.0 - (distance - 200.0) / 2000.0);
         local oldThreat = AI.GetScriptThreat( npc );

         threat = saturate(threat + oldThreat);
         AI.SetScriptThreat( npc, threat, true, 0.2 );

         if (threat >= 0.98) then
            Level.SetupSaySpyScript( npc, MissionText.Message_SpyAlert );
         end
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
         --Level.RemovePlayerAction(id);
         Level.SafeRemoveLevelPlayerAction(id);
         Level.RemoveTimer('CHSP');
         return;
      end

      Level.SafeRemoveLevelPlayerAction(id);
      --Level.RemovePlayerAction(id);

      local properties = Level.CreateCustomParams();

      Level.SetValue(properties, "CustomString_1", "Level.OnReadDocs()" );

      AI.RunScriptTask(npc, "scripts:job\\ReadDocsTask.lua", AI.LOGIC_DEFAULT, properties);

      if (id == 'SHP1') then
         AI.EnableZone("CellBlockB_NoPass", false);
         AI.EnableZone("CellBlockB_Near",   false);

      elseif (id == 'SHP2') then
         AI.EnableZone("CellBlockC_NoPass", false);
         AI.EnableZone("CellBlockC_Near",   false);

      end

      Level.StartPlayerCustomAnim("Custom_PassticketShow", 0, true, true);
      Level.RemoveTimer('CHSP');

   elseif (id == 'LCOM') then

      -- get show stop move bot...
      local npc = AI.FindNearestNpc(AI.TASK_SHOW_STOP_MOVE, "");
      if (npc == nil) then
         Level.SafeRemoveLevelPlayerAction('LCOM');
         Level.RemoveTimer('LCTM');
         return;
      end  

      Level.SafeRemoveLevelPlayerAction('LCOM');
      AI.EnableZone("CommendatRoom_Near", false);
      Level.RunAnchorJob( AI.FindNPC('GS56'), 'MM75', true );
      Level.RemoveTimer('LCTM');
   end
end

--------------------------------------------------------
-- Name: Level.GetSearchMan()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.GetReadDocsMan()
   local job = AI.GetScriptJob("TASK_SCRIPT_READ_DOCS");
   if (job != nil) then
      return Job.GetNPC( job );
   end

   return nil; 
end

--------------------------------------------------------
-- Name: Level.OnReadDocs()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.OnReadDocs()
   Level.AddSmallMessage( MissionText.MM_StopMove_DocsClear, 5.0, 175, 175, 175 );
   AI.HandleVoice( Level.GetReadDocsMan(), "~3male_ger_script_script_42");
end

--------------------------------------------------------
-- Name: Level.RestoreZones()
-- MoTmod Addon
-- Liz Shaw
--------------------------------------------------------
function Level.RestoreZones()
    AI.EnableZone("CellBlockA_NoPass",  true);
    AI.EnableZone("CellBlockA_Near",    true);
    AI.EnableZone("CellBlockB_NoPass",  true);
    AI.EnableZone("CellBlockB_Near",    true);
    AI.EnableZone("CellBlockC_NoPass",  true);
    AI.EnableZone("CellBlockC_Near",    true);
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
  local class = AI.GetClass(npc);

  if (zone == nil) then 
    return;
  end

  if (zone == "mmZoneA1") then
    Level.AddSmallMessage(MissionText.MM_StopMove_WKR, 5.0, 175, 175, 175);
    AI.HandleVoice(npc, "male_ger_stopmove_stopmove_08");
  elseif (zone == "mmZoneB1") then
    Level.AddSmallMessage(MissionText.MM_StopMove_NearTeaRoom, 5.0, 175, 175, 175);
    AI.HandleVoice(npc, "male_ger_stopmove_stopmove_17");
  elseif (zone == "mmZoneB2") then
    if (npcForm == "SOL4") then
      Level.AddSmallMessage(MissionText.MM_StopMove_TeaRoom_SOL, 5.0, 175, 175, 175);
      AI.HandleVoice(npc, "male_ger_stopmove_stopmove_19");
    elseif (npcForm == "OFF1") then
      Level.AddSmallMessage(MissionText.MM_StopMove_TeaRoom_OFF, 5.0, 175, 175, 175);
      AI.HandleVoice(npc, "male_ger_stopmove_stopmove_03");
    end
  elseif (zone == "mmZoneB3" or
          zone == "mmZoneC2") then
    Level.AddSmallMessage(MissionText.MM_StopMove_TeaRoom_SOL, 5.0, 175, 175, 175);
    AI.HandleVoice(npc, "male_ger_stopmove_stopmove_19");
  elseif (zone == "PrisonStairway_Near") then
    Level.AddSmallMessage(MissionText.MM_StopMove_CIV, 5.0, 175, 175, 175);
    AI.HandleVoice(npc, "male_ger_stopmove_stopmove_13");
  elseif (zone == "CellBlockA_Near") then
    if (playerForm == "YLLW") then
      Level.AddSmallMessage(MissionText.MM_StopMove_YLLW, 5.0, 175, 175, 175);
      AI.HandleVoice(npc, "male_ger_stopmove_stopmove_10");
    else
      Level.AddSmallMessage(MissionText.MM_StopMove_NoEntry, 5.0, 175, 175, 175);
      AI.HandleVoice(npc, "male_ger_stopmove_stopmove_17");
    end
  elseif (zone == "CellBlockB_Near") then
    Level.AddSmallMessage(MissionText.MM_StopMove_PassDocs, 5.0, 175, 175, 175);
    AI.HandleVoice(npc, "male_ger_stopmove_stopmove_10");
    if (Level.PlayerHasPass() == true) then
      if (Level.HasPlayerAction('SHP1') == false) then
         --Level.AddPlayerAction('SHP1', MissionText.Message_ShowDocs, "Level", false );
         Level.SafeAddLevelPlayerAction('SHP1', MissionText.Message_ShowDocs);
         Level.AddTimer('CHSP', "OnCheckShowPass", 1.0, true );
      end
    end
  elseif (zone == "CellBlockC_Near") then
    Level.AddSmallMessage(MissionText.MM_StopMove_PassDocs, 5.0, 175, 175, 175);
    AI.HandleVoice(npc, "male_ger_stopmove_stopmove_10");
    if (Level.PlayerHasPass() == true) then
      if (Level.HasPlayerAction('SHP2') == false) then
         --Level.AddPlayerAction('SHP2', MissionText.Message_ShowDocs, "Level", false );
         Level.SafeAddLevelPlayerAction('SHP2', MissionText.Message_ShowDocs);
         Level.AddTimer('CHSP', "OnCheckShowPass", 1.0, true );
      end
    end
  elseif (zone == "CellBlockD_Near") then
    if (playerForm == "YLLW") then
      Level.AddSmallMessage(MissionText.MM_StopMove_NoPrisoners, 5.0, 175, 175, 175);
      Level.EnableLevelMark( 'TUR2', false );
    else
      Level.AddSmallMessage(MissionText.MM_StopMove_NoEntry, 5.0, 175, 175, 175);
    end
    AI.HandleVoice(npc, "male_ger_stopmove_stopmove_17");
  elseif (zone == "ConferenceRoom_Near") then
    Level.AddSmallMessage(MissionText.MM_StopMove_NearConf, 5.0, 175, 175, 175);
    AI.HandleVoice(npc, "male_ger_stopmove_stopmove_20");
  elseif (zone == "ConferenceRoom") then
    if (npcForm == "SOL4") then
      Level.AddSmallMessage(MissionText.MM_StopMove_Conf_SOL, 5.0, 175, 175, 175);
      AI.HandleVoice(npc, "male_ger_stopmove_stopmove_05");
    elseif (npcForm == "OFF1") then
      Level.AddSmallMessage(MissionText.MM_StopMove_Conf_OFF, 5.0, 175, 175, 175);
      AI.HandleVoice(npc, "male_ger_stopmove_stopmove_03");
    end
  elseif (zone == "InterrogationRoom_Near") then
    Level.AddSmallMessage(MissionText.MM_StopMove_NearIntrg, 5.0, 175, 175, 175);
    AI.HandleVoice(npc, "male_ger_stopmove_stopmove_17");
  elseif (zone == "InterrogationRoom") then
    Level.AddSmallMessage(MissionText.MM_StopMove_Intrg, 5.0, 175, 175, 175);
    AI.HandleVoice(npc, "male_ger_stopmove_stopmove_14");
  elseif (zone == "CommendatRoom_Near") then
    if (playerForm == "CIV1") then
      Level.AddSmallMessage(MissionText.MM_StopMove_ComendatCIV, 5.0, 175, 175, 175);
    else
      Level.AddSmallMessage(MissionText.MM_StopMove_Comendat, 5.0, 175, 175, 175);
    end
    AI.HandleVoice(npc, "male_ger_stopmove_stopmove_17");
    if (playerForm == "CIV1" and AI.FindNPC('GCOM') != nil) then
      if (Level.HasPlayerAction('LCOM') == false) then
         Level.SafeAddLevelPlayerAction('LCOM', MissionText.Message_LureCommendat);
         Level.AddTimer('LCTM', "OnLureCommendatTimer", 1.0, true );
      end
    end
  elseif (zone == "Chapel_Near") then
    Level.AddSmallMessage(MissionText.MM_StopMove_Chapel, 5.0, 175, 175, 175);
    AI.HandleVoice(npc, "male_ger_stopmove_stopmove_17");
  elseif (zone == "WineCellar_Near") then
    Level.AddSmallMessage(MissionText.MM_StopMove_NearCellar, 5.0, 175, 175, 175);
    AI.HandleVoice(npc, "male_ger_stopmove_stopmove_08");
  elseif (zone == "WineCellar") then
    Level.AddSmallMessage(MissionText.MM_StopMove_Cellar, 5.0, 175, 175, 175);
    AI.HandleVoice(npc, "male_ger_stopmove_stopmove_08");
  elseif (zone == "RadioRoom_Near") then
    Level.AddSmallMessage(MissionText.MM_StopMove_NearRadio, 5.0, 175, 175, 175);
    AI.HandleVoice(npc, "male_ger_stopmove_stopmove_17");
  elseif (zone == "RadioRoom") then
    Level.AddSmallMessage(MissionText.MM_StopMove_Radio, 5.0, 175, 175, 175);
    AI.HandleVoice(npc, "male_ger_stopmove_stopmove_08");
  elseif (zone == "DiningRoom") then
    Level.AddSmallMessage(MissionText.MM_StopMove_DiningRoom, 5.0, 175, 175, 175);
    AI.HandleVoice(npc, "male_ger_stopmove_stopmove_19");
  elseif (zone == "Bedroom01_Near" or
          zone == "Bedroom02_Near" or
          zone == "Nums2_Near") then
    Level.AddSmallMessage(MissionText.MM_StopMove_NearBedroom, 5.0, 175, 175, 175);
    if (class == "civilian_woman" or
        class == "enemy_woman") then
      AI.HandleVoice(npc, "female_ger_panic_panic_04");
    else
      AI.HandleVoice(npc, "male_ger_stopmove_stopmove_08");
    end
  elseif (zone == "Bedroom01" or
          zone == "Bedroom02" or
          zone == "Nums2") then
    Level.AddSmallMessage(MissionText.MM_StopMove_Bedroom, 5.0, 175, 175, 175);
    if (class == "civilian_woman" or
        class == "enemy_woman") then
      AI.HandleVoice(npc, "female_ger_panic_panic_04");
    else
      AI.HandleVoice(npc, "male_ger_stopmove_stopmove_18");
    end
  elseif (zone == "Nums") then
    Level.AddSmallMessage(MissionText.MM_StopMove_Nums, 5.0, 175, 175, 175);
    AI.HandleVoice(npc, "male_ger_stopmove_stopmove_18");
  end
end
