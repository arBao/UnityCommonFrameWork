---
--- Created by luzhuqiu.
--- DateTime: 2017/6/7 上午10:21
---

JoyStick =
{
    name = 'JoyStick',
}

function JoyStick:Awake(monobehaviour)
    self.MonoComponent = monobehaviour
    self.gameObject = self.MonoComponent.gameObject
    self.gameObject:AddComponent(typeof(UIEventTransfer))
end

function JoyStick:Start()
end

function JoyStick:OnEnable()
end

function JoyStick:OnDisable()
end

function JoyStick:OnDestroy()
end

function JoyStick:New()
    local o = {}
    setmetatable(o,self)
    self.__index = self
    return o
end