local Root = script.Parent.Parent
local Components = Root.Components

local Roact: Roact = require(Root.Packages.Roact)
local RoactRouter = require(Root.Packages.RoactRouter)

local Transition = require(Components.Transition)

local CoinDisplay = require(script.CoinDisplay)

local bind = require(Root.Util.Bind)
local e = Roact.createElement

return function()
    return e(RoactRouter.Route, {
        path = "/",
        exact = true,
        always = true,

        render = function(routing)
            return e(Transition.Fade, {
                whenHidden = .5,
                unmount = false,
                show = routing.match,
            }, {
                CoinDisplay = e(CoinDisplay, {
                    onClick = bind(routing.history.push, routing.history, "/shop"),
                }),
            })
        end,
    })
end
