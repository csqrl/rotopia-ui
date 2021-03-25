local Lighting = game:GetService("Lighting")

local Components = script.Parent.Parent
local Packages = Components.Parent.Packages

local Roact = require(Packages.Roact)
local Llama = require(Packages.Llama)

local e = Roact.createElement

local Fade = require(Components.Transition.Fade)

local Component = Roact.Component:extend("ShieldOverlay")

local defaultProps = {
	show = false,
	colour = Color3.fromRGB(26, 26, 26),
	transparency = .5,
	blur = nil,
	zindex = nil,

	onDismiss = nil,
}

function Component:init(props)
	if props.color then
		self.props.colour = props.color
	end

	if props.blur then
		self.blurSize = type(props.blur) == "number" and props.blur or 24
	end

	if props.onDismiss then
		self.onClick = function(rbx)
			if self.props.show and type(props.onDismiss) == "function" then
				props.onDismiss(rbx, self.props.show)
			end
		end
	end
end

function Component:render()
	local show = self.props.show
	local blurSize = nil

	if self.blurSize then
		local offset = 1 - self.props.shieldTransparency
		blurSize = (((self.props.shieldTransparency / self.props.transparency) - offset) / offset) * self.blurSize
	end

	local props = {
		BackgroundTransparency = self.props.transparency,
		BackgroundColor3 = self.props.colour,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		ZIndex = self.props.zindex,
	}

	if show then
		props.AutoButtonColor = false
		props.Modal = true

		props[Roact.Event.MouseButton1Click] = self.onClick
		props[Roact.Event.MouseButton2Click] = self.onClick
	end

	return e(show and "ImageButton" or "Frame", props, {
		blurSize and e(Roact.Portal, {
			target = Lighting,
		}, {
			UIShieldBlurEffect = e("BlurEffect", {
				Size = blurSize,
			}),
		}),

		Roact.createFragment(self.props[Roact.Children]),
	})
end

return function(props)
	props = Llama.Dictionary.merge(defaultProps, props)
	props.shieldTransparency = props.transparency

	return e(Fade, {
		show = props.show,
		whenShown = props.transparency,
	}, {
		ShieldOverlay = e(Component, props),
	})
end
