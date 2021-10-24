AddCSLuaFile()

local appel = nil
local listPanels = {}

function drawGUI(appels)
    listPanels = {}
    appel = appels

    for k,v in pairs(appel) do
        if k < 5 then
            local panelAppel = vgui.Create("DFrame")
            panelAppel:SetPos( ScrW() - 240, 100 * k )
            panelAppel:SetSize( 215, 100 )
            panelAppel:ShowCloseButton( false )
            panelAppel:SetDraggable( false )
            panelAppel:SetTitle( string.gsub(G_TICKETS.messages.call, "{{name}}", v.name) )
            panelAppel.Paint = function()
                draw.RoundedBox( 3, 0, 0, panelAppel:GetWide(), panelAppel:GetTall(), Color(0, 104, 255) )
            end

            local describAppel = vgui.Create("RichText", panelAppel)
            describAppel:SetPos( 5, 23 )
            describAppel:SetSize( 210, 28 )
            describAppel:AppendText( v.message )

            local panelCloseButton = vgui.Create( "DButton", panelAppel )
            panelCloseButton:SetPos( 175, 5 )
            panelCloseButton:SetText( "" )
            panelCloseButton:SetSize( 35, 15 )
            panelCloseButton.Paint = function()
                draw.RoundedBox( 0, 0, 0, panelCloseButton:GetWide(), panelCloseButton:GetTall(), Color(100, 25, 25) )
                draw.DrawText( G_TICKETS.messages.close, "Default", panelCloseButton:GetWide() / 2, 2,  Color(255, 255, 255), TEXT_ALIGN_CENTER )
            end
            panelCloseButton.DoClick = function()
                traiterAppel(k, "close")
            end

            local panelTpButton = vgui.Create( "DButton", panelAppel )
            panelTpButton:SetPos( 5, 70 )
            panelTpButton:SetText( "" )
            panelTpButton:SetSize( panelAppel:GetWide() / 3 - 6, 20 )
            panelTpButton.Paint = function()
                draw.RoundedBox( 0, 0, 0, panelTpButton:GetWide(), panelTpButton:GetTall(), Color(255, 185, 0 ) )
                draw.DrawText( "Teleport", "Default", panelTpButton:GetWide() / 2, 3,  Color(255, 255, 255), TEXT_ALIGN_CENTER )
            end
            panelTpButton.DoClick = function()
              RunConsoleCommand("_FAdmin", "Teleport", v.userid)
                traiterAppel(k, "Teleportez moi !")
            end

            local panelGotoButton = vgui.Create( "DButton", panelAppel )
            panelGotoButton:SetPos( panelTpButton:GetWide() + 10, 70 )
            panelGotoButton:SetText( "" )
            panelGotoButton:SetSize( panelAppel:GetWide() / 3 - 6, 20 )
            panelGotoButton.Paint = function()
                draw.RoundedBox( 0, 0, 0, panelGotoButton:GetWide(), panelGotoButton:GetTall(), Color(0, 70, 255 ) )
                draw.DrawText( "J'y vais !", "Default", panelGotoButton:GetWide() / 2, 3,  Color(255, 255, 255), TEXT_ALIGN_CENTER )
            end
            panelGotoButton.DoClick = function()
              RunConsoleCommand("_FAdmin", "goto", v.userid)
                traiterAppel(k, "J'arrive !")
            end

            local panelKickButton = vgui.Create( "DButton", panelAppel )
            panelKickButton:SetPos( panelTpButton:GetWide()*2 + 15, 70 )
            panelKickButton:SetText( "" )
            panelKickButton:SetSize( panelAppel:GetWide() / 3 - 6, 20 )
            panelKickButton.Paint = function()
                draw.RoundedBox( 0, 0, 0, panelKickButton:GetWide(), panelKickButton:GetTall(), Color(0, 255, 209 ) )
                draw.DrawText( "Kick", "Default", panelKickButton:GetWide() / 2, 3,  Color(255, 255, 255), TEXT_ALIGN_CENTER )
            end
            panelKickButton.DoClick = function()
                traiterAppel(k, "kick")
            end

            table.insert(listPanels, panelAppel)
        end
    end

    local panelOverflowText = vgui.Create( "DLabel", panelAppel )
    panelOverflowText:SetPos( ScrW() - 240, 100 * 5 - 10 )
    panelOverflowText:SetText( "" )
    panelOverflowText:SetSize( 215, 20 )
    panelOverflowText.Paint = function()
        if (table.getn(appel) > 4) then
            draw.DrawText( "And " .. table.getn(appel) - 4 .. " others...", "Default", 0, 3,  Color(255, 255, 255), TEXT_ALIGN_LEFT )
        end
    end
end

net.Receive( "send_tickets_table", function( len )
    for i,panel in pairs(listPanels) do
        panel:Close()
    end

    drawGUI( net.ReadTable() )
end )

function traiterAppel(indexAppel, action)
    net.Start("traiter_tickets_table")
        net.WriteInt(indexAppel, 4)
        net.WriteString(action)
    net.SendToServer()
end
