---
--- Created by luzhuqiu.
--- DateTime: 2017/6/9 上午11:56
---
require 'Battle/Process/Process'
require 'Battle/Process/ProcessConst'

ProcessManager = class()
function ProcessManager:GetInstance()
    if self.m_instance == nil then
        self.m_instance = ProcessManager.new()
    end
    return self.m_instance
end

function ProcessManager:Init()

end

function ProcessManager:Clear()

end
