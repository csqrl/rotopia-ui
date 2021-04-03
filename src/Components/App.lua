local Root = script.Parent.Parent

local Roact: Roact = require(Root.Packages.Roact)
local RoactRouter = require(Root.Packages.RoactRouter)

local Theme = require(Root.Theme)

local IndexPage = require(Root.Pages.Index)
local ShopPage = require(Root.Pages.Shop)

local e = Roact.createElement

return function()
    return e(Theme.Provider, nil, {
        e(RoactRouter.Router, nil, {
            Index = e(IndexPage),
            Shop = e(ShopPage),
        }),
    })
end
