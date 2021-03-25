local Components = script.Parent.Parent.Parent
local Packages = Components.Parent.Packages

local Roact = require(Packages.Roact)

local Navigation = require(script.Parent.Navigation)

local e = Roact.createElement

return function()
	return e("Frame", {
		AnchorPoint = Vector2.new(.5, .5),
		BackgroundTransparency = 1,
		Position = UDim2.fromScale(.5, .5),
		Size = UDim2.fromOffset(868, 411),
		ClipsDescendants = true,
	}, {
		e("UIListLayout", { Padding = UDim.new() }),

		e("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
		}, {
			e("UIPadding", {
				PaddingRight = UDim.new(0, 16),
				PaddingTop = UDim.new(0, 4),
			}),

			Navigation = e(Navigation),
		})
	})
end
