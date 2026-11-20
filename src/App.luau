local UIService = require("Services.UIService")
local App = {}

local Root = UIService.Root
local Frame = require("Classes.UI.Frame")
local Label = require("Classes.UI.Label")
local Button = require("Classes.UI.Button")
local ScrollingFrame = require("Classes.UI.ScrollingFrame")

local TextureViewer = Frame { -- Texture viewer
        Anchor = {1,0},
        Size = {1, 0, 0.5, 0},
        Pos = {0, 0, 0.5, 0},
        Background = {Color = {1, 1, 1, 1}},

        ScrollingFrame { -- Texture List
            Anchor = {1,0.5},
            Size = {0.35, 0, 1, 0},
            Pos = {1,0,0.5,0}
        },

        Frame { -- Selected Texture Draw Frame
            Anchor = {0,0.5},
            Size = {1-0.35,0,1,0},
            Pos = {0,0,0.5,0},
            Color = {1,0.5,0.5,1}
        }
}

local Editor = ScrollingFrame {
    Anchor = {0.5, 0.5},
    Size = {1,0,1,0},
    Pos = {0.5,0,0.5,0},
    Color = {1,1,1,1},
    AutoCanvasSize = true,

    Frame { -- Test Frame
        Anchor = {0.5,0},
        Size = {0,50,2,0},
        Pos = {0.5,0,0.5,0},
        Color = {1,0,0,1}
    }
}

local AppFrame = Frame {
    Anchor = {1, 0.5},
    Size = {0.5, 0, 1, 0},
    Pos = {1, 0, 0.5, 0},
    Background = {Color = {0.5, 0.5, 0.5, 1}},

    Editor,
    TextureViewer
}

Root:AddChild(AppFrame)

return App