local Replicated = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

local InterfaceLoader = require(Replicated.Client.Interface.Loader)

StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu, false)
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Health, false)
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)

InterfaceLoader()
