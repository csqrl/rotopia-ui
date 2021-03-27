local Components = script.Parent.Parent.Parent.Parent
local Packages = Components.Parent.Packages

local Roact = require(Packages.Roact)
local RoactRouter = require(Packages.RoactRouter)

local withTheme = require(Components.Parent.Theme.withTheme)
local e = Roact.createElement

local Component = Roact.Component:extend("NavButton")

Component.defaultProps = {
	path = nil,
	state = nil,

	label = "Button",
	position = nil, -- "start" or "end"

	layoutOrder = nil,
}

function Component:render()
	return withTheme(function(theme)
		return e(RoactRouter.Context.Consumer, {
			render = function(routing)
				return e("ImageButton", {
					BackgroundColor3 = theme.palette.primary,
					BackgroundTransparency = 1,
					LayoutOrder = self.props.layoutOrder,
					Size = UDim2.fromScale(1, 1),
					Image = "rbxassetid://5038702297",
					ImageColor3 = theme.palette.primary,
					-- ImageRectSize = Vector2.new(512, 1024),
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(512, 512, 512, 512),
					SliceScale = (theme.borderRadius - 2) / 512,

					[Roact.Event.MouseButton1Click] = function()
						routing.history:replace(
							self.props.path, self.props.state
						)
					end,
				}, {
					e("UIListLayout", {
						Padding = UDim.new(),
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Center,
					}),

					e("UIPadding", {
						PaddingBottom = UDim.new(0, theme.spacing * .5),
						PaddingLeft = UDim.new(0, theme.spacing),
						PaddingRight = UDim.new(0, theme.spacing),
						PaddingTop = UDim.new(0, theme.spacing * .5),
					}),

					e("TextLabel", {
						AutomaticSize = Enum.AutomaticSize.XY,
						BackgroundTransparency = 1,
						Font = theme.font.semibold,
						Text = self.props.label,
						TextColor3 = theme.common.white,
						TextSize = theme.fontSize,
						TextWrapped = true,
					}),
				})
			end,
		})
	end)
end

return Component
