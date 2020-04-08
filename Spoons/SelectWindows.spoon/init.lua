local obj = {}
obj.__index = obj

-- Switch between visible windows with the ijkl keys.
-- This is useful when you have an ultrawide monitor

-- Metadata
obj.name = "SelectWindows"
obj.version = "1.0"
obj.author = "Eric Feliksik <feliksik@gmail.com>"
-- obj.homepage = "https://github.com/Hammerspoon/Spoons"
obj.license = "MIT - https://opensource.org/licenses/MIT"

local MODIFIER = { "cmd", "alt", "ctrl" }

local frontOnly = true
local angle45only = true

local windowNavigators = {
    ["I"] = function()
        hs.window.filter.defaultCurrentSpace:focusWindowNorth(nil, frontOnly, angle45only)
    end,
    ["K"] = function()
        hs.window.filter.defaultCurrentSpace:focusWindowSouth(nil, frontOnly, angle45only)
    end,
    ["J"] = function()
        hs.window.filter.defaultCurrentSpace:focusWindowWest(nil, frontOnly, angle45only)
    end,
    ["L"] = function()
        hs.window.filter.defaultCurrentSpace:focusWindowEast(nil, frontOnly, angle45only)
    end
}

local highlightingCanvas

function highlightWindow(win)
    if highlightingCanvas ~= nil then
        highlightingCanvas:hide()
    end
    local f = win:frame()
    local canvas = hs.canvas.new(f):appendElements({
        type = "rectangle",
        action = "stroke",
        strokeWidth = 10.0,
        strokeColor = { green = 1.0 },
        frame = { x = 0, y = 0, h = f.h, w = f.w }
    })               :show()

    hs.timer.doAfter(0.5, function()
        canvas:hide()
    end)
    highlightingCanvas = canvas
end

function navigateFocus(key)
    windowNavigators[key]()
    highlightWindow(hs.window.frontmostWindow())
end

for key, dc in pairs(windowNavigators) do
    hs.hotkey.bind(
            MODIFIER,
            key,
            function()
                navigateFocus(key)
            end
    )
end

return {}