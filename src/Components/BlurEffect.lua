local Lighting = game:GetService("Lighting")
local Root = script.Parent.Parent

local Roact: Roact = require(Root.Packages.Roact)
local Llama = require(Root.Packages.Roact)

local e = Roact.createElement

local defaultProps = {
    size = 0,
}

return function(props)
    props = Llama.Dictionary.merge(defaultProps, props)

    if props.transparency then
        props.size = props.transparency
    end

    if props.size > 0 then
        return e(Roact.Portal, {
            target = Lighting,
        }, {
            RoactUIBlurEffect = e("BlurEffect", {
                Size = props.size,
            }),
        })
    end

    return nil
end
