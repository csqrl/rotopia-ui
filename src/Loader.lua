local LocalPlayer = game:GetService("Players").LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Root = script.Parent

local Roact: Roact = require(Root.Packages.Roact)

local DeviceProvider = require(Root.Device.Provider)
local AppComponent = require(Root.Components.App)

return function()
    local appRootComponent = Roact.createElement(DeviceProvider, {
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
