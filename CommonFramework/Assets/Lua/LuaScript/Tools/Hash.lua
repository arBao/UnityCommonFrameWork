---
--- Created by luzhuqiu.
--- DateTime: 2017/6/20 下午5:53
---
Hash = class()
function Hash:ctor()
    self.items = {}
end

function Hash:RefreshLength()
    local length = 0
    for k,v in pairs(self.items) do
        length = length + 1
    end
    self.length = length
end

function Hash:Add(id,item)
    self.items[id] = item
end

function Hash:Delete(id)
    self.items[id] = nil
end

function Hash:Get(id)
    return self.items[id]
end

function Hash:ForEach(func)
    for k,v in pairs(self.items) do
        local isBreak = func(k,v)
        if isBreak then
            break
        end
    end
end

function Hash:GetLength()
    return self.length
end

function Hash:RemoveAtTail()
    self:Delete(self.length)
    self.length = self.length - 1
    if self.length < 0 then
        self.length = 0
    end
end
