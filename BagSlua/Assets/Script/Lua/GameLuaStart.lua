import "UnityEngine"
import "UnityEngine.UI"

if not UnityEngine.GameObject or not  UnityEngine.UI then
	error("Click Make/All to generate lua wrap file")
end

require("baseclass")
require("BagClass")
require("Bag")

local GameLuaStart =  GameLuaStart or BaseClass()

function GameLuaStart:Start()
    print("------------------GameLuaStart   =========>Start")
    self:AllDictionary()
end

function GameLuaStart:AllDictionary()
    --BagClass.New()
    Bag.New()
end
function main()
    print("-----------------GameLuaStart")
end

function Start()
    GameLuaStart:Start()
end

