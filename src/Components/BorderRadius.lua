local Root = script.Parent.Parent

local Roact: Roact = require(Root.Packages.Roact)
local Llama = require(Root.Packages.Llama)

local Theme = require(Root.Theme)

local e = Roact.createElement
local max = math.max

local RoundifyImage = "rbxassetid://5038702297"
local RoundifyHalf = 1024 / 2

local function backgroundFrame(position: UDim2, colour: Color3, transparency: number?)
    return e("Frame", {
        BackgroundColor3 = colour,
        BackgroundTransparency = transparency or 0,
        BorderSizePixel = 0,
        Position = position,
        Size = UDim2.fromScale(.5, .5),
    })
end

return function(props)
    props = props or {}

    return Theme.withTheme(function(theme)
        local radius = props.radius or theme.borderRadius

        local topLeft = max(props.topLeft or props[1] or radius, 0)
        local topRight = max(props.topRight or props[2] or topLeft, 0)
        local bottomRight = max(props.bottomRight or props[3] or topRight, 0)
        local bottomLeft = max(props.bottomLeft or props[4] or topLeft, 0)

        local imageProps = {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(.5, .5),
            Image = RoundifyImage,
            ImageColor3 = props.colour or theme.palette.background.default,
            ImageRectSize = Vector2.new(RoundifyHalf, RoundifyHalf),
            ImageTransparency = props.transparency,
            ScaleType = Enum.ScaleType.Slice,
            SliceCenter = Rect.new(RoundifyHalf, RoundifyHalf, RoundifyHalf, RoundifyHalf),
            SliceScale = topLeft / RoundifyHalf,
        }

        return e("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
        }, {
            TopLeft = topLeft > 0 and e("ImageLabel", imageProps)
                or backgroundFrame(UDim2.new(), imageProps.ImageColor3, props.transparency),

            TopRight = topRight > 0 and e("ImageLabel", Llama.Dictionary.merge(imageProps, {
                Position = UDim2.fromScale(.5, 0),
                ImageRectOffset = Vector2.new(RoundifyHalf, 0),
                SliceCenter = Rect.new(0, RoundifyHalf, 0, RoundifyHalf),
                SliceScale = topRight / RoundifyHalf,
            })) or backgroundFrame(UDim2.fromScale(.5, 0), imageProps.ImageColor3, props.transparency),

            BottomRight = bottomRight > 0 and e("ImageLabel", Llama.Dictionary.merge(imageProps, {
                Position = UDim2.fromScale(.5, .5),
                ImageRectOffset = Vector2.new(RoundifyHalf, RoundifyHalf),
                SliceCenter = Llama.None,
                SliceScale = bottomRight / RoundifyHalf,
            })) or backgroundFrame(UDim2.fromScale(.5, .5), imageProps.ImageColor3, props.transparency),

            BottomLeft = bottomLeft > 0 and e("ImageLabel", Llama.Dictionary.merge(imageProps, {
                Position = UDim2.fromScale(0, .5),
                ImageRectOffset = Vector2.new(0, RoundifyHalf),
                SliceCenter = Rect.new(RoundifyHalf, 0, RoundifyHalf, 0),
                SliceScale = bottomLeft / RoundifyHalf,
            })) or backgroundFrame(UDim2.fromScale(0, .5), imageProps.ImageColor3, props.transparency),

            Roact.createFragment(props[Roact.Children]),
        })
    end)
end
