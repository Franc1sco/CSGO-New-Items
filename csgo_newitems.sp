#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <cstrike>
#undef REQUIRE_PLUGIN
#include <multi1v1>

#define DATA "1.1"

Handle cvar1, cvar2;

new Handle:g_CVarAdmFlag;
new g_AdmFlag;

bool g_bMode;

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
	
	g_CVarAdmFlag = CreateConVar("sm_csgonewitems_adminflag", "0", "Admin flag required to use csgonewitems. 0 = No flag needed. Can use a b c ....");
	
	cvar1 = CreateConVar("sm_csgonewitems_healthshot", "1", "Enable or disable healthshot on spawn");
	cvar2 = CreateConVar("sm_csgonewitems_tagrenade", "1", "Enable or disable tagrenade on spawn");
	
	HookConVarChange(g_CVarAdmFlag, CVarChange);
	
	g_bMode = (FindPluginByFile("multi1v1")==INVALID_HANDLE?false:true);
}

public CVarChange(Handle:convar, const String:oldValue[], const String:newValue[]) {

	g_AdmFlag = ReadFlagString(newValue);
}

public Event_PlayerSpawn(Handle:event, const String:name[], bool:dontBroadcast)
{	
	if (g_bMode)return;
	
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	
	if ((g_AdmFlag > 0) && !CheckCommandAccess(client, "sm_csgonewitems_override", g_AdmFlag, true))return;
	
	if(GetClientTeam(client) < 2) return;

	if(GetConVarBool(cvar1)) GivePlayerItem(client, "weapon_healthshot");
	if(GetConVarBool(cvar2)) GivePlayerItem(client, "weapon_tagrenade");
}

public OnLibraryAdded(const String:name[])
{
	g_bMode = (FindPluginByFile("multi1v1")==INVALID_HANDLE?false:true);
}

public OnLibraryRemoved(const String:name[])
{
	g_bMode = (FindPluginByFile("multi1v1")==INVALID_HANDLE?false:true);
}

public void Multi1v1_AfterPlayerSetup(int client) 
{
	if ((g_AdmFlag > 0) && !CheckCommandAccess(client, "sm_csgonewitems_override", g_AdmFlag, true))return;
	
	if(GetClientTeam(client) < 2) return;

	if(GetConVarBool(cvar1)) GivePlayerItem(client, "weapon_healthshot");
	if(GetConVarBool(cvar2)) GivePlayerItem(client, "weapon_tagrenade");
}