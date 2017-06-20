---
--- Created by luzhuqiu.
--- DateTime: 2017/6/20 下午1:43
---
require 'Tools/StackItem'

Stack = class()
function Stack:ctor()
    self.size = 0
    self.head = nil
end

function Stack:GetSize()
    return self.size
end

function Stack:SetSize(size)
    self.size = size
end

function Stack:Push(data)

end

function Stack:ForEach(func)

end