---
--- Created by luzhuqiu.
--- DateTime: 2017/6/6 下午5:23
---
LogicFrameManager = class()
function LogicFrameManager:GetInstance()
    if self.m_instance == nil then
        self.m_instance = LogicFrameManager.new()
    end
    return self.m_instance
end

function LogicFrameManager:Init()

end