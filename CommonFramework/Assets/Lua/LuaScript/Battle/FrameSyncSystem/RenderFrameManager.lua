---
--- Created by luzhuqiu.
--- DateTime: 2017/6/6 下午5:26
---
RenderFrameManager = class()
function RenderFrameManager:GetInstance()
    if self.m_instance == nil then
        self.m_instance = RenderFrameManager.new()
    end
    return self.m_instance
end

function RenderFrameManager:Init()

end