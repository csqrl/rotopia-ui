local LocalPlayer = game:GetService("Players").LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Root = script.Parent

local Roact: Roact = require(Root.Packages.Roact)

local Device = require(Root.Device)
local AppComponent = require(Root.Components.App)

return function()
    local appRootComponent = Roact.createElement(Device.Provider, {
        class = "ScreenGui",

        props = {
            DisplayOrder = 10,
            Enabled = true,
            IgnoreGuiInset = true,
            ResetOnSpawn = false,
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        },
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
