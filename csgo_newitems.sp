#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <cstrike>

#define ADMFLAG_NEEDED ADMFLAG_CUSTOM6

#define DATA "1.0"

Handle cvar1, cvar2;

public Plugin:myinfo =
{
	name = "SM CS:GO New Items",
	author = "Franc1sco franug",
	description = "Testing new items in csgo",
	version = DATA,
	url = "http://steamcommunity.com/id/franug/"
};


public OnPluginStart()
{
	HookEvent("player_spawn", Event_PlayerSpawn);
	
	cvar1 = CreateConVar("sm_csgonewitems_healthshot", "1", "Enable or disable healthshot on spawn");
	cvar2 = CreateConVar("sm_csgonewitems_tagrenade", "1", "Enable or disable tagrenade on spawn");
}

public Event_PlayerSpawn(Handle:event, const String:name[], bool:dontBroadcast)
{	
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	
	if(GetClientTeam(client) < 2) return;
	
	if(!(GetUserFlagBits(client) & ADMFLAG_NEEDED)) return;

	if(GetConVarBool(cvar1)) GivePlayerItem(client, "weapon_healthshot");
	if(GetConVarBool(cvar2)) GivePlayerItem(client, "weapon_tagrenade");
}