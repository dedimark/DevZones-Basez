#include <sourcemod>
#include <sdktools_functions>
#include <devzones>

#pragma semicolon 1
#pragma newdecls required

ConVar slapdamage;

public Plugin myinfo = 
{
	name = "SM DEV ZONES - Basez", 
	author = "ByDexter", 
	description = "", 
	version = "1.1", 
	url = "https://steamcommunity.com/id/ByDexterTR/"
};

public void OnPluginStart()
{
	LoadTranslations("devzones_basez.phrases");
	
	RegAdminCmd("sm_slaybase", Command_slaybase, ADMFLAG_SLAY);
	RegAdminCmd("sm_slapbase", Command_slapbase, ADMFLAG_SLAY);
	
	slapdamage = CreateConVar("sm_baseslap_damage", "50", "Basede ki oyuncuya atılan slap hasarı");
	
	AutoExecConfig(true, "DevZones-Basez", "ByDexter");
}

public Action Command_slaybase(int client, int args)
{
	for (int i = 1; i <= MaxClients; i++)
	{
		if (IsValidClient(i) && Zone_IsClientInZone(i, "basez"))
		{
			ForcePlayerSuicide(client);
		}
	}
	PrintToChatAll("[SM] %N: %T", client, "slaybase");
	return Plugin_Handled;
}

public Action Command_slapbase(int client, int args)
{
	for (int i = 1; i <= MaxClients; i++)
	{
		if (IsValidClient(i) && Zone_IsClientInZone(i, "basez"))
		{
			SlapPlayer(i, slapdamage.IntValue, true);
		}
	}
	PrintToChatAll("[SM] %N: %T", client, "slapbase");
	return Plugin_Handled;
}

bool IsValidClient(int client, bool nobots = true)
{
	if (client <= 0 || client > MaxClients || !IsClientConnected(client) || (nobots && IsFakeClient(client)))
	{
		return false;
	}
	return IsClientInGame(client);
} 