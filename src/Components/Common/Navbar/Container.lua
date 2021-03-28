local Root = script.Parent.Parent.Parent.Parent
local Components = Root.Components

local Roact: Roact = require(Root.Packages.Roact)
local Llama = require(Root.Packages.Llama)

local Theme = require(Root.Theme)
local e = Roact.createElement

local UICorner = require(Components.Common.UICorner)
local UIPadding = require(Components.Common.UIPadding)

return function(props)
    props = props or {}

    return Theme.withTheme(function(theme)
        local childIndex = 0
        local children = Llama.Dictionary.map(props[Roact.Children], function(element)
            local elementProps = Llama.Dictionary.merge({
                LayoutOrder = childIndex,
            }, element.props, {
                Size = UDim2.new(1 / #props[Roact.Children], 1),
            })

            childIndex += 1
            return e(element.component, elementProps)
        end)

        return e("ImageButton", {
            BackgroundColor3 = theme.palette.background.default,
            Size = UDim2.new(1, 1),
            Image = "",
        }, {
            BorderRadius = e(UICorner),
            Padding = e(UIPadding),

            Roact.createFragment(children),
        })
    end)
end
