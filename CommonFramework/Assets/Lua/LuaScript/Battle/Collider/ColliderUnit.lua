--- 碰撞单位方块
--- Created by luzhuqiu.
--- DateTime: 2017/6/9 下午5:36
---

ColliderPair = class()
function ColliderPair:Set(e1,e2)
    self.element1 = e1
    self.element2 = e2
end

-----------------------##

ColliderElement = class()

function ColliderElement:Set(id,type)
    self.id = id
    self.type = type
end

--------------------------##

ColliderUnit = class()
function ColliderUnit:ctor()
    self.x = 0
    self.y = 0
    self.posOrign = nil
    self.elements = {}
end

function ColliderUnit:AddType(id,type)
    local element = ColliderElement.new()
    element:Set(id,type)
    table.insert(self.elements,element)
end

---返回两两碰撞的元素
function ColliderUnit:Detect()
    local pairs = {}
    for i = 1,#self.elements,1 do
        for j = i+1,#self.elements,1 do
            local elementI = self.elements[i]
            local elememtJ = self.elements[j]

            if elementI.type ~= elememtJ.type then
                local pair = ColliderPair.new()
                pair:Set(elementI,elememtJ)
                table.insert(pairs,pair)

                --Debugger.LogError('pair.element1.id  ' .. pair.element1.id .. '  pair.element1.type  ' .. pair.element1.type )
                --Debugger.LogError('pair.element2.id  ' .. pair.element2.id .. '  pair.element2.type  ' .. pair.element2.type )
            end
        end
    end
    return pairs
end

