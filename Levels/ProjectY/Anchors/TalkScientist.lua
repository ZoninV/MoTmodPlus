
Anchor = 
{
};


function Anchor:Setup( uid, npc )
  AI.Debug(npc, "Anchor", "TalkScientist::Setup");

  NPC.Stand(npc);

  NPC.SetStandPolicy( npc, NPC.STAND_POLICY_NORMAL );
  NPC.SetBodyPolicy( npc, NPC.BODY_POLICY_SIMPLE_STANDING );
  NPC.SetFirePolicy( npc, NPC.FIRE_POLICY_NEUTRAL );

  Level.AddSmallMessage( MissionText.Message_TalkScientist, 5.0, 175, 175, 175 );

  local scientist = AI.FindNPC('AS11');
  if (AI.IsDefault(scientist) != false) then

     NPC.DoCustomAnimation( npc, "Relaxed_Talk_1", NPC.ANIM_NO_WEAPON);

     local properties = Level.CreateCustomParams();
     Level.SetValue(properties, "CustomString_1", 'AN71');
     Level.SetValue(properties, "CustomString_2", 'AN70');

     AI.RunScriptTask(scientist, "scripts:job\\AnchorJob2_run.lua", AI.LOGIC_DEFAULT, properties);

  else
     NPC.DoCustomAnimation( npc, "Relaxed_Idle1", NPC.ANIM_NO_WEAPON);
  end

  return true;
end

function Anchor:Notify( uid, npc, time )
  AI.Debug(npc, "Anchor", "TalkScientist::Notify");
  return true;
end

function Anchor:Stop( uid, npc )
  AI.Debug(npc, "Anchor", "TalkScientist::Stop");
  return true;
end

function Anchor:Execute( uid, npc )
  AI.Debug(npc, "Anchor", "TalkScientist::Execute");

  return true;
end