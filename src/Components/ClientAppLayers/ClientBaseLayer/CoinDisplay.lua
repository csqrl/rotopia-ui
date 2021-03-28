local Root = script.Parent.Parent.Parent.Parent

local Roact: Roact = require(Root.Packages.Roact)
local Device = require(Root.Device)

local Theme = require(Root.Components.Parent.Theme)
local e = Roact.createElement

local Component = Roact.Component:extend("CoinDisplay")

Component.defaultProps = {
	transparency = 0,
	onClick = nil,
}

function Component:init()
	self:setState({
		coinsValue = 0,
	})
end

function Component:render()
	local state = self.state
	local props = self.props

	local coinsText = tostring(state.coinsValue)

	return Device.withDevice(function(device)
		local xsOffset = math.clamp((device.height - 320) / (375 - 320), 0, 1)
		local baseSize = UDim2.fromOffset(110, 88):Lerp(UDim2.fromOffset(142, 112), xsOffset)

		return Theme.withTheme(function(theme)
			return e("ImageButton", {
				AnchorPoint = Vector2.new(1, 0),
				BackgroundTransparency = 1,
				Position = UDim2.new(1, -16, 0, theme.spacing),
				Size = baseSize,
				ClipsDescendants = true,
				Image = "rbxassetid://6551803737",
				ImageColor3 = theme.palette.background.default,
				ImageTransparency = props.transparency,

				[Roact.Event.MouseButton1Click] = props.onClick,
				[Roact.Event.MouseButton2Click] = props.onRightClick,
				[Roact.Event.TouchLongPress] = props.onRightClick,
			}, {
				Icon = e("ImageLabel", {
					AnchorPoint = Vector2.new(0, 1),
					BackgroundTransparency = 1,
					Position = UDim2.fromScale(.056, .92),
					Size = UDim2.fromScale(.887, .857),
					ZIndex = 20,
					Image = "rbxassetid://6551820072",
					ImageColor3 = nil,
					ImageTransparency = props.transparency,
				}),

				IconBorder = e("ImageLabel", {
					AnchorPoint = Vector2.new(0, 1),
					BackgroundTransparency = 1,
					Position = UDim2.fromScale(.056, .92),
					Size = UDim2.fromScale(.887, .857),
					ZIndex = 10,
					Image = "rbxassetid://6551817243",
					ImageColor3 = theme.palette.background.default,
					ImageTransparency = props.transparency,
				}),

				ValueBackground = e("ImageLabel", {
					AnchorPoint = Vector2.new(0, 1),
					BackgroundTransparency = 1,
					Position = UDim2.fromScale(.056, .92),
					Size = UDim2.fromScale(.887, .857),
					ZIndex = 1,
					Image = "rbxassetid://6551810103",
					ImageColor3 = theme.palette.primary,
					ImageTransparency = props.transparency,
				}),

				Value = e("TextLabel", {
					AnchorPoint = Vector2.new(.5, 1),
					BackgroundTransparency = 1,
					Position = UDim2.fromScale(.479, .777),
					Rotation = 5,
					Size = UDim2.fromScale(.65, .196),
					ZIndex = 30,
					Font = theme.font.semibold,
					Text = coinsText,
					TextColor3 = theme.common.white,
					TextScaled = true,
					TextTransparency = props.transparency,
				}),
			})
		end)
	end)
end

return Component
