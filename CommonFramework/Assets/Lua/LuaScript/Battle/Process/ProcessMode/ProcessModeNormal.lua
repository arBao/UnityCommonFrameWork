---
--- Created by luzhuqiu.
--- DateTime: 2017/6/14 下午3:26
---
require 'Battle/Process/Processes/ProcessFight'
require 'Battle/Process/Processes/ProcessPlot'

ProcessModeNormal = class(ProcessMode)

function ProcessModeNormal:OnInit()
    self:AddProcess(ProcessFight.new())
    self:AddProcess(ProcessPlot.new())
end

function ProcessModeNormal:OnClear()

end

function ProcessModeNormal:OnAlwaysUpdate(deltaTime)

end

function ProcessModeNormal:OnUpdate(deltaTime)
    --Debugger.LogError('ProcessModeNormal:OnUpdate  ' .. deltaTime)
end