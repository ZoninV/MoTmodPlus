
Anchor =
{
};


function Anchor:Setup( uid, npc )
  AI.Debug(npc, "Anchor", "RegistrateAnchor::Setup");

  NPC.Stand(npc);

  NPC.SetBodyPolicy( npc, NPC.BODY_POLICY_SIMPLE_STANDING );
  NPC.SetHeadPolicy( npc, NPC.HEAD_POLICY_DEFAULT );
  NPC.SetFirePolicy( npc, NPC.FIRE_POLICY_NEUTRAL );

  NPC.DoCustomAnimation( npc, "Act_Hotel_Manager", NPC.ANIM_NO_WEAPON);

  return true;
end


function Anchor:Notify( uid, npc, time )
  AI.Debug(npc, "Anchor", "RegistrateAnchor::Notify");
  return true;
end

function Anchor:Stop( uid, npc )
  AI.Debug(npc, "Anchor", "RegistrateAnchor::Stop");
  NPC.Stand(npc);

  NPC.SetStandPolicy( npc, NPC.STAND_POLICY_NORMAL );
  NPC.SetHeadPolicy( npc, NPC.HEAD_POLICY_DEFAULT );
  NPC.SetBodyPolicy( npc, NPC.BODY_POLICY_SIMPLE_STANDING );

  return true;
end

function Anchor:Execute( uid, npc )
  AI.Debug(npc, "Anchor", "RegistrateAnchor::Execute");

  -- Hotelmanager heiﬂt einem Willkommen nach dem Einchecken. AHO, 07.09.2008
  Level.AddSmallMessage(MissionText.Manager1,10.0,0,255,0);
  Level.AddSmallMessage(MissionText.Manager2,10.0,0,255,0);
  Level.AddSmallMessage("",10.0,0,255,0);
  Level.AddSmallMessage(MissionText.Player,10.0,255,255,0);
  Level.AddSmallMessage("",10.0,255,255,0);
  --
  Level.AddSmallMessage( MissionText.Message_GetsTicket, 15.0, 255, 255, 255 ); -- AHO, 16.09.2008

  Level.GiveTicket();

  return true;
end