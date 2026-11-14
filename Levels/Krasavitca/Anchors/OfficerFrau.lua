
Anchor = 
{
};


function Anchor:Setup( uid, npc )
  AI.Debug(npc, "Anchor", "GermanFrau::Setup");

  NPC.Stand(npc);
  NPC.SetStandPolicy( npc, NPC.STAND_POLICY_NORMAL );
  NPC.SetBodyPolicy( npc, NPC.BODY_POLICY_SIMPLE_STANDING );
  NPC.SetHeadPolicy(npc, NPC.HEAD_POLICY_DEFAULT);
  NPC.SetFirePolicy(npc, NPC.FIRE_POLICY_NEUTRAL);

  local frau = AI.FindNPC('GF09');

  if (AI.IsDefault(frau)) then
     AI.DoCustomAnimationEx( npc, "Relaxed_Talk_Express1:male_ger_script_script_43:10" );
  else
     AI.DoCustomAnimationEx( npc, "Relaxed_Talk_Scratch2" );
  end

  return true;
end


function Anchor:Notify( uid, npc, time )
  AI.Debug(npc, "Anchor", "GermanFrau::Notify");
  return true;
end

function Anchor:Stop( uid, npc )
  AI.Debug(npc, "Anchor", "GermanFrau::Stop");
  return true;
end


function Anchor:Execute( uid, npc )
  AI.Debug(npc, "Anchor", "GermanFrau::Execute");

  local frau = AI.FindNPC('GF09');

  -- Init idle to spy
  if (AI.IsDefault(frau)) then
     local properties = Level.CreateCustomParams();
     Level.SetValue(properties, "CustomString_1", 'AN66');
     Level.SetValue(properties, "CustomString_2", 'AN65');
     Level.SetValue(properties, "CustomString_3", 'AN67');
     Level.SetValue(properties, "CustomString_4", 'AN68');
     AI.RunScriptTask(frau, "scripts:job\\AnchorJob4.lua", AI.LOGIC_DEFAULT, properties);
  end        
                                                                          
  return true;
end