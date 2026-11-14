
Anchor = 
{
};


function Anchor:Setup( uid, npc )
  AI.Debug(npc, "Anchor", "MayerMaderStation::Setup");

  NPC.Stand(npc);

  NPC.SetStandPolicy( npc, NPC.STAND_POLICY_NORMAL );
  NPC.SetBodyPolicy( npc, NPC.BODY_POLICY_SIMPLE_STANDING );
  NPC.DoCustomAnimation( npc, "Act_Rasplata_Radio", NPC.ANIM_NO_WEAPON);

  return true;
end


function Anchor:Notify( uid, npc, time )
  AI.Debug(npc, "Anchor", "MayerMaderStation::Notify");
  return true;
end

function Anchor:Stop( uid, npc )
  AI.Debug(npc, "Anchor", "MayerMaderStation::Stop");
  return true;
end

function Anchor:Execute( uid, npc )
  AI.Debug(npc, "Anchor", "MayerMaderStation::Execute", Level.RadioBroken);

  if (Level.RadioBroken != false) then
     AI.Debug(npc, "Anchor", "Radio broken - kill actor");
     AI.SetGameFlag(npc, AI.F_ACCIDENT_BODY, true);

     Level.PlayEffect( "levels\\rasplata\\radio_break.sef" , 125.12, 34.1, 2222.0 );
     Level.PlayCustomSound('DamageRadio');
     AI.AddSound( AI.SOUND_TYPE_DEFAULT, 30.0, 125.12, 34.1, 2222.0);

     AI.KillNPC( npc, 0.0 );
  end

  return true;
end