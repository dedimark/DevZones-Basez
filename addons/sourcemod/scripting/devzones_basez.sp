#include <sourcemod>
#include <sdktools>
#include <cstrike>
#include <sdkhooks>
#include <multicolors>
#include <devzones>
#include <warden>

#pragma semicolon 1
#pragma newdecls required

int basezone[MAXPLAYERS + 1];

ConVar ConVar_slapdamage;

public Plugin myinfo = 
{
	name = "SM DEV ZONES - Basez",
	author = "ByDexter",
	description = "",
	version = "1.0",
	url = "https://steamcommunity.com/id/ByDexterTR/"
};

public void OnPluginStart()
{
	RegConsoleCmd("sm_slaybase", Baseslay);
	RegConsoleCmd("sm_respawnbase", Baserespawn);
	RegConsoleCmd("sm_slapbase", Baseslap);
	ConVar_slapdamage = CreateConVar("sm_baseslap_damage", "0", "Basede ki oyuncuya atılan slap hasarı");
}

public void Zone_OnClientEntry(int client, const char[] zone)
{
	if(client < 1 || client > MaxClients || !IsClientInGame(client) ||!IsPlayerAlive(client)) 
		return;
		
	if(StrContains(zone, "basez", false) == 0)
	{
		basezone[client] = 1;
	}
}

public void Zone_OnClientLeave(int client, const char[] zone)
{
	if(client < 1 || client > MaxClients || !IsClientInGame(client) ||!IsPlayerAlive(client)) 
		return;
		
	if(StrContains(zone, "basez", false) == 0)
	{
		basezone[client] = 0;
	}
}

public Action Baseslay(int client, int args)
{
	if(warden_iswarden(client) || CheckCommandAccess(client, "sm_slay", ADMFLAG_SLAY, false))
	{
		if(basezone[client] == 1 && IsPlayerAlive(client))
		{
			CPrintToChat(client, "{darkred}[ByDexter] {green}Base bölgesinde {default}olduğun için öldün!");
			ForcePlayerSuicide(client);
		}
	}
}

public Action Baserespawn(int client, int args)
{
	if(warden_iswarden(client) || CheckCommandAccess(client, "sm_slay", ADMFLAG_SLAY, false))
	{
		if(basezone[client] == 1 && !IsPlayerAlive(client))
		{
			CPrintToChat(client, "{darkred}[ByDexter] {green}Base bölgesinde {default}olduğun için doğdun!");
			CS_RespawnPlayer(client);
		}
	}
}

public Action Baseslap(int client, int args)
{
	if(warden_iswarden(client) || CheckCommandAccess(client, "sm_slay", ADMFLAG_SLAY, false))
	{
		if(basezone[client] == 1 && IsPlayerAlive(client))
		{
			CPrintToChat(client, "{darkred}[ByDexter] {green}Base bölgesinde {default}olduğun için tokat yedin!");
			SlapPlayer(client, ConVar_slapdamage.IntValue, true);
		}
	}
}