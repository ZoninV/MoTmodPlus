
Anchor = 
{
};


function Anchor:Setup( uid, npc )
  AI.Debug(npc, "Anchor", "SpeakSoldier::Setup");

  NPC.Stand(npc);
  NPC.SetStandPolicy( npc, NPC.STAND_POLICY_NORMAL );
  NPC.SetBodyPolicy( npc, NPC.BODY_POLICY_SIMPLE_STANDING );

  local soldier = AI.FindNPC('S176');
  if (AI.IsDefault(soldier)) then
     NPC.DoCustomAnimation( npc, "Relaxed_Talk_Express1", NPC.ANIM_NO_WEAPON);

     local properties = Level.CreateCustomParams();
     Level.SetValue(properties, "CustomString_1", 'AA34');
     AI.RunScriptTask(soldier, "scripts:job\\AnchorJob.lua", AI.LOGIC_DEFAULT, properties);
  else
     NPC.DoCustomAnimation( npc, "Relaxed_Idle1", NPC.ANIM_NO_WEAPON);
  end


  return true;
end


function Anchor:Notify( uid, npc, time )
  AI.Debug(npc, "Anchor", "SpeakSoldier::Notify");
  return true;
end

function Anchor:Stop( uid, npc )
  AI.Debug(npc, "Anchor", "SpeakSoldier::Stop");
  return true;
end

function Anchor:Execute( uid, npc )
  AI.Debug(npc, "Anchor", "SpeakSoldier::Execute");
                                                                          
  return true;
end