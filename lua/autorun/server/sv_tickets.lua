include("autorun/g_tickets_config.lua")

util.AddNetworkString("send_tickets_table")
util.AddNetworkString("traiter_tickets_table")

local appels = {}

hook.Add( "PlayerInitialSpawn", "admin_spawn_tickets", function( ply )
	ply:SetNWBool( "adminstatus", true )
end )

hook.Add( "PlayerSay", "call_admin_tickets", function( ply, text, team )
	if (string.find(text, "^" .. G_TICKETS.command)) then
        local appel = {}
        appel.steamid = ply:SteamID64()
        appel.name = ply:Nick()
        appel.player = ply
        appel.message = string.gsub(text, G_TICKETS.command .. " ", "")
				appel.userid = ply:UserID()
        appel.entraitement = false

        table.insert(appels, appel)

        sendTicketsToAdmins()
    end

	if text == G_TICKETS.commandStatus then
		changeAdminstatus(ply)
	end
end )

function changeAdminstatus(ply)
	if ply:GetNWBool( "adminstatus" ) then
		ply:SetNWBool( "adminstatus", false )
		ply:PrintMessage( HUD_PRINTTALK, G_TICKETS.messages.offline )
	else
		ply:SetNWBool( "adminstatus", true )
		ply:PrintMessage( HUD_PRINTTALK, G_TICKETS.messages.online )
	end
end

function sendTicketsToAdmins()
	for k,v in pairs(player.GetAll()) do
		for i,j in pairs(G_TICKETS.groups) do
			if (v:GetUserGroup() == j && v:GetNWBool( "adminstatus" )) then
				net.Start("send_tickets_table")
			        net.WriteTable(appels)
			    net.Send(v)
			end
		end
	end
end

net.Receive( "traiter_tickets_table", function( len, ply )
    local aDelete = net.ReadInt(4)
    local action = net.ReadString()

		if action == "teleport" then
			ply:Say("Teleportation !!")
		end

	if action == "goto" then
		ply:Say("Nickel !")
	end

	if action == "kick" then
		appels[aDelete].player:Kick(G_TICKETS.messages.excessive)
	end

	hook.Call("Pure_onTicketClosed", nil, ply)

    table.remove(appels, aDelete)

    sendTicketsToAdmins()
end )
