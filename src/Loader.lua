local LocalPlayer = game:GetService("Players").LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Packages = script.Parent.Packages
local Components = script.Parent.Components

local Roact: Roact = require(Packages.Roact)

local AppComponent = require(Components.App)

return function()
    local appRootComponent = Roact.createElement("ScreenGui", {
        DisplayOrder = 10,
        Enabled = true,
        IgnoreGuiInset = true,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    }, {
        Root = Roact.createElement(AppComponent),
    })

    local roactHandle = Roact.mount(
        appRootComponent, PlayerGui, "GameInterface"
    )

    return {
        RoactHandle = roactHandle,
    }
end
