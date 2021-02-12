#include <sourcemod>
#include <sdkhooks>

bool Go = false;

ConVar cnvr_nhs_mode = null;

#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo = 
{
	name = "[CS:S / CS:GO] No Head Shake", 
	author = "ByDexter", 
	description = "When the player receives a headshot, it prevents a head shake", 
	version = "1.0", 
	url = "https://steamcommunity.com/id/ByDexterTR - ByDexter#5494"
};

public void OnPluginStart()
{
	cnvr_nhs_mode = CreateConVar("nhs_mode", "1", "Whoever hits the player, let his head shake [ 0 = All | 1 = Friendly | 2 = Enemy ]", 0, true, 0.0, true, 2.0);
	AutoExecConfig(true, "NoHeadShake", "ByDexter");
}

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	EngineVersion g_engineversion = GetEngineVersion();
	if (g_engineversion == Engine_CSGO)
	{
		Go = true;
	}
	else if (g_engineversion == Engine_CSS)
	{
		Go = false;
	}
}

public void OnClientPutInServer(int client)
{
	SDKHook(client, SDKHook_OnTakeDamage, OnTakeDamage);
}

public Action OnTakeDamage(int victim, int &attacker, int &inflictor, float &damage, int &damagetype)
{
	if (IsValidClient(victim) && IsValidClient(attacker))
	{
		if (cnvr_nhs_mode.IntValue == 0)
		{
			if (Go)
			{
				SetEntPropVector(victim, Prop_Send, "m_aimPunchAngle", NULL_VECTOR);
				SetEntPropVector(victim, Prop_Send, "m_aimPunchAngleVel", NULL_VECTOR);
			}
			else
			{
				SetEntPropVector(victim, Prop_Send, "m_vecPunchAngle", NULL_VECTOR);
				SetEntPropVector(victim, Prop_Send, "m_vecPunchAngleVel", NULL_VECTOR);
			}
		}
		else if (cnvr_nhs_mode.IntValue == 1)
		{
			if (GetClientTeam(victim) == GetClientTeam(attacker))
			{
				if (Go)
				{
					SetEntPropVector(victim, Prop_Send, "m_aimPunchAngle", NULL_VECTOR);
					SetEntPropVector(victim, Prop_Send, "m_aimPunchAngleVel", NULL_VECTOR);
				}
				else
				{
					SetEntPropVector(victim, Prop_Send, "m_vecPunchAngle", NULL_VECTOR);
					SetEntPropVector(victim, Prop_Send, "m_vecPunchAngleVel", NULL_VECTOR);
				}
			}
		}
		else if (cnvr_nhs_mode.IntValue == 2)
		{
			if (GetClientTeam(victim) != GetClientTeam(attacker))
			{
				if (Go)
				{
					SetEntPropVector(victim, Prop_Send, "m_aimPunchAngle", NULL_VECTOR);
					SetEntPropVector(victim, Prop_Send, "m_aimPunchAngleVel", NULL_VECTOR);
				}
				else
				{
					SetEntPropVector(victim, Prop_Send, "m_vecPunchAngle", NULL_VECTOR);
					SetEntPropVector(victim, Prop_Send, "m_vecPunchAngleVel", NULL_VECTOR);
				}
			}
		}
	}
}

bool IsValidClient(int client, bool nobots = true)
{
	if (client <= 0 || client > MaxClients || !IsClientConnected(client) || (nobots && !IsFakeClient(client)))
	{
		return false;
	}
	return IsClientInGame(client);
} 