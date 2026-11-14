
Anchor =
{
};


function Anchor:Setup( uid, npc )
  AI.Debug(npc, "Anchor", "DiplomatReadAnchor::Setup");

  NPC.Stand(npc);

  NPC.SetBodyPolicy( npc, NPC.BODY_POLICY_SIMPLE_STANDING );
  NPC.SetHeadPolicy( npc, NPC.HEAD_POLICY_DEFAULT );
  NPC.SetFirePolicy( npc, NPC.FIRE_POLICY_NEUTRAL );

  NPC.DoCustomAnimation( npc, "Act_Hotel_Newspaper", NPC.ANIM_NO_WEAPON);

  -- Start gad...
  -- Test player at room...
  if ( Level.IsMissionFailed() == false ) then

     local gad = AI.FindNPC( 'GAD1' );
     if (AI.IsDefault( gad ) or
         (gad != nil and
          AI.GetRoom(gad) == Level.GetRoom('LIBR') and
          AI.GetAttention(gad) != AI.ATTENTION_RELAX)) then

        Level.DocsInstalled = false;

        local properties = Level.CreateCustomParams();

        Level.SetValue(properties, "CustomString_1", 'AN95' );
        Level.SetValue(properties, "CustomString_2", 'AN96' );

        AI.RunScriptTask(gad, "scripts:job\\AnchorJob2.lua", AI.LOGIC_DEFAULT, properties);
        Level.EnableAttentionCheckTimer( true );

        if (Level.IsPlayerAtLibrary() == false) then

           Level.AddSmallMessage( MissionText.Message_DocsChanging, 15.0, 255, 255, 255 ); -- AHO, 16.09.2008  

        end

     else

        Level.FailedMission(MissionText.Failed_Alert);

     end

  end

  return true;
end


function Anchor:Notify( uid, npc, time )
  AI.Debug(npc, "Anchor", "DiplomatReadAnchor::Notify");
  return true;
end

function Anchor:Stop( uid, npc )
  AI.Debug(npc, "Anchor", "DiplomatReadAnchor::Stop");
  NPC.Stand(npc);

  NPC.SetStandPolicy( npc, NPC.STAND_POLICY_NORMAL );
  NPC.SetHeadPolicy( npc, NPC.HEAD_POLICY_DEFAULT );
  NPC.SetBodyPolicy( npc, NPC.BODY_POLICY_SIMPLE_STANDING );

  return true;
end

function Anchor:Execute( uid, npc )
  AI.Debug(npc, "Anchor", "DiplomatReadAnchor::Execute");

  if (Level.IsMissionFailed() == false and
      Level.DocsInstalled != false and
      Level.DocsDiplomat == false) then

     local properties = Level.CreateCustomParams();

     Level.SetValue(properties, "CustomString_1", 'AN97' );

     AI.RunScriptTask(npc, "scripts:job\\AnchorJob.lua", AI.LOGIC_NEUTRAL, properties);

  else

     Level.FailedMission(MissionText.Failed_Alert);

  end

  return true;
end