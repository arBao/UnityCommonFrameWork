---
--- Created by luzhuqiu.
--- DateTime: 2017/6/6 下午5:23
---
LogicFrameManager = class()

---每秒多少帧逻辑帧
local framesPerSec = 30

function LogicFrameManager:GetInstance()
    if self.m_instance == nil then
        self.m_instance = LogicFrameManager.new()
    end
    return self.m_instance
end

function LogicFrameManager:Init()
    self.frameLogicCal = 0
end

function LogicFrameManager:Pause()

end

function LogicFrameManager:Update(delTime)

end