
Anchor = 
{
};


function Anchor:Setup( uid, npc )
  AI.Debug(npc, "Anchor", "SpyGo::Setup");

  NPC.Stand(npc);
  NPC.SetStandPolicy( npc, NPC.STAND_POLICY_NORMAL );
  NPC.SetBodyPolicy( npc, NPC.BODY_POLICY_SIMPLE_STANDING );

  NPC.DoCustomAnimation( npc, "Relaxed_Talk_Kivok1", NPC.ANIM_NO_WEAPON);

  return true;
end


function Anchor:Notify( uid, npc, time )
  AI.Debug(npc, "Anchor", "SpyGo::Notify");
  return true;
end

function Anchor:Stop( uid, npc )
  AI.Debug(npc, "Anchor", "SpyGo::Stop");
  return true;
end

function Anchor:Execute( uid, npc )
  AI.Debug(npc, "Anchor", "SpyGo::Execute");

  local spy = AI.FindNPC('GSPY');
  if (AI.IsDefault(spy)) then
     local properties = Level.CreateCustomParams();
     Level.SetValue(properties, "CustomString_1", 'AN14');
     AI.RunScriptTask(spy, "scripts:job\\AnchorJob.lua", AI.LOGIC_DEFAULT, properties);
  end

  AI.SetForm(AI.FindNPC('GRD1'), "SOL5");
  AI.SetForm(AI.FindNPC('GRD2'), "SOL5");

  return true;
end