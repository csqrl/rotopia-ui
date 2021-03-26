local Components = script.Parent
local Packages = Components.Parent.Packages

local Roact: Roact = require(Packages.Roact)

local Styles = require(Components.Parent.Styles)

local LayerRouting = require(Components.AppLayers.Routing)

local ClientBaseLayer = require(Components.ClientAppLayers.ClientBaseLayer)
local ShopLayer = require(Components.ClientAppLayers.ShopLayer)

return function()
    return Roact.createElement(Styles.ThemeProvider.Provider, {
        theme = {
            primary = Styles.Colour.Hex.fromHex("#FF006A"),
        },
    }, {
        Roact.createElement("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            ClipsDescendants = true,
        }, {
            LayerRouting = Roact.createElement(LayerRouting, nil, {
                ClientBaseLayer = Roact.createElement(ClientBaseLayer),
                ShopLayer = Roact.createElement(ShopLayer),
            }),
        })
    })
end
