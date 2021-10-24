AddCSLuaFile()

-- https://puresystem.eu/ 

G_TICKETS = {}

G_TICKETS.command = "///"
G_TICKETS.groups = {"superadmin", "admin", "modo-test"}
G_TICKETS.commandStatus = "!service"

G_TICKETS.messages = {}
G_TICKETS.messages.online = "<hsv>(GTickets) Tu es maintenant en service  bg !</hsv>"
G_TICKETS.messages.offline = "<hsv>(GTickets) Tu n'es plus en service bg !</hsv>"
G_TICKETS.messages.call = "Appel de {{name}}"
G_TICKETS.messages.close = "Fermer"
G_TICKETS.messages.excessive = "[GTickets] Utilisation abusive des tickets !"
