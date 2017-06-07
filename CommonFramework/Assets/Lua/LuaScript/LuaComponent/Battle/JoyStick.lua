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
    self.JoyStickCircle = self.gameObject.transform:Find('JoyStickCircle').transform
    self.CenterPos = self.gameObject.transform:Find('CenterPos').transform
    self.EventArea = EventTriggerListener.GetListener(self.gameObject.transform:Find('EventArea').gameObject)
    self.EventArea:SetOnPointerUp(self,JoyStick.OnPointerUp)
    self.EventArea:SetOnDrag(self,JoyStick.OnDrag)
    self.EventArea:SetOnPointerDown(self,JoyStick.OnPointerDown)
    self.uiCamera = CameraManager:GetInstance():GetUICamera()
    self.maxDistance = 2.5
    self.OnDragCallback = nil
    self.EndDragCallback = nil
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

function JoyStick.SetJoyStickCirclePos(self,eventData)
    local pos = self.uiCamera:ScreenToWorldPoint(eventData.position)
    pos.z = self.CenterPos.position.z
    local posCenter = self.CenterPos.position
    local distance = Vector3.Distance(pos,posCenter)
    --Debugger.LogError('distance ' .. distance)
    if distance > self.maxDistance then
        local scale = self.maxDistance / distance
        pos.x = posCenter.x + (pos.x - posCenter.x) * scale
        pos.y = posCenter.y + (pos.y - posCenter.y) * scale
    end
    self.JoyStickCircle.position = pos
    if self.OnDragCallback ~= nil then
        local direction = Vector2.New(pos.x - posCenter.x,pos.y - posCenter.y)
        direction = direction:Normalize()
        self.OnDragCallback(direction)
    end
end

function JoyStick.OnPointerUp(self,eventData)
    self.JoyStickCircle.position = self.CenterPos.position
    if self.EndDragCallback ~= nil then
        self.EndDragCallback()
    end
end

function JoyStick.OnDrag(self,eventData)
    JoyStick.SetJoyStickCirclePos(self,eventData)
end

function JoyStick.OnPointerDown(self,eventData)
    JoyStick.SetJoyStickCirclePos(self,eventData)
end