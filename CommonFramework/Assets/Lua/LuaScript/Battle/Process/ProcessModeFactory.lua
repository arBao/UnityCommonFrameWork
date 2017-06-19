---
--- Created by luzhuqiu.
--- DateTime: 2017/6/14 下午3:22
---
require 'Battle/Process/ProcessMode'
require 'Battle/Process/ProcessMode/ProcessModeNormal'

ProcessModeFactory = class()

function ProcessModeFactory.Create(name)
    if name == ProcessModeName.ProcessModeNormal then
        return ProcessModeNormal.new()
    elseif name == '2' then

    end
end
