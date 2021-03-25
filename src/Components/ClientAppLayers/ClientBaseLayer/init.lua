local Components = script.Parent.Parent
local Packages = Components.Parent.Packages

local Roact: Roact = require(Packages.Roact)
local RoactRouter = require(Packages.RoactRouter)

local e = Roact.createElement

local Fade = require(Components.Transition.Fade)
local CoinDisplay = require(script.CoinDisplay)

return function()
	return e(RoactRouter.Route, {
		path = "/",
		always = true,
		exact = true,

		render = function(routing)
			return e(Fade, {
				whenHidden = .5,
				unmount = false,
				show = routing.match,
			}, {
				CoinDisplay = e(CoinDisplay, {
					onClick = function()
						routing.history:push("/shop")
					end,
				}),
			})
		end,
	})
end
