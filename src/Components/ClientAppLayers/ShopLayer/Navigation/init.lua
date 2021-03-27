local Components = script.Parent.Parent.Parent
local Packages = Components.Parent.Packages

local Roact = require(Packages.Roact)
local RoactRouter = require(Packages.RoactRouter)

local withTheme = require(Components.Parent.Theme.withTheme)
local e = Roact.createElement

local NavButton = require(script.NavButton)

return function()
	return withTheme(function(theme)
		return e("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, theme.spacing * 4.5),
		}, {
			e("UIPadding", { PaddingLeft = UDim.new(0, 104) }),

			CloseButton = e(RoactRouter.Context.Consumer, {
				render = function(routing)
					return e("ImageButton", {
						AnchorPoint = Vector2.new(1, 0),
						AutoButtonColor = false,
						BackgroundColor3 = theme.palette.background.default,
						Position = UDim2.fromScale(1, 0),
						Size = UDim2.fromOffset(theme.spacing * 4.5, theme.spacing * 4.5),
						Image = "",

						[Roact.Event.MouseButton1Click] = function()
							routing.history:goBack()
						end,
					}, {
						e("UICorner", { CornerRadius = UDim.new(0, theme.borderRadius) }),

						e("UIPadding", {
							PaddingBottom = UDim.new(0, 2),
							PaddingLeft = UDim.new(0, 2),
							PaddingRight = UDim.new(0, 2),
							PaddingTop = UDim.new(0, 2),
						}),

						e("Frame", {
							BackgroundColor3 = theme.palette.primary,
							Size = UDim2.fromScale(1, 1),
						}, {
							e("UICorner", { CornerRadius = UDim.new(0, theme.borderRadius - 2) }),

							e("ImageLabel", {
								AnchorPoint = Vector2.new(.5, .5),
								BackgroundTransparency = 1,
								Position = UDim2.fromScale(.5, .5),
								Size = UDim2.fromScale(.75, .75),
								Image = "rbxassetid://6031094678",
								ImageColor3 = theme.common.white,
								ScaleType = Enum.ScaleType.Fit,
							}),
						}),
					})
				end,
			}),

			NavigationContainer = e("ImageButton", {
				AutoButtonColor = false,
				BackgroundColor3 = theme.palette.background.default,
				Size = UDim2.new(1, -(theme.spacing * 4.5 + theme.spacing), 1, 0),
				Image = "",
			}, {
				e("UICorner", { CornerRadius = UDim.new(0, theme.borderRadius) }),

				e("UIPadding", {
					PaddingBottom = UDim.new(0, 2),
					PaddingLeft = UDim.new(0, 2),
					PaddingRight = UDim.new(0, 2),
					PaddingTop = UDim.new(0, 2),
				}),

				e("UIGridLayout", {
					CellPadding = UDim2.new(),
					CellSize = UDim2.fromScale(1 / 3, 1),
					FillDirection = Enum.FillDirection.Horizontal,
				}),

				TabButtonCoins = e(NavButton, {
					path = "/shop",
					label = "Coins",
				}),

				TabButtonPasses = e(NavButton, {
					path = "/shop/game-passes",
					label = "Game Passes",
					layoutOrder = 10,
				}),

				TabButtonCodes = e(NavButton, {
					path = "/shop/redeem-code",
					label = "Codes",
					layoutOrder = 20,
				}),
			}),
		})
	end)
end
