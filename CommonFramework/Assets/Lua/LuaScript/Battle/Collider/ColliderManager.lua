---
--- Created by luzhuqiu.
--- DateTime: 2017/6/9 下午5:06
---
require 'Battle/Collider/ColliderUnit'
--ColliderType = {['']}

ColliderManager = class()

local rowMax = 1500
local lineMax = 750
local lineSpace = 0.2
local debug = true

function ColliderManager:GetInstance()
    if self.m_instance == nil then
        self.m_instance = ColliderManager.new()
    end
    return self.m_instance
end

function ColliderManager:Init()
    self.unitList = {}
    self.objUseList = {}
    self.objUnuseList = {}
    self.max = math.max(rowMax,lineMax)
    if debug then
        UpdateBeat:Add(ColliderManager.DrawColliderMesh,self)
    end

end

function ColliderManager.GetMeshCache(self)
    local obj = self.objUnuseList[1]

    if obj == nil then
        obj = AssetsManager.Instance:GetAsset('Assets/Res/Model/Prefab/Quad.prefab',typeof(UnityEngine.GameObject))
        obj.transform.localScale = Vector3.New(lineSpace,lineSpace,lineSpace)
    else
        table.remove(self.objUnuseList,1)
    end

    table.insert(self.objUseList,obj)
    --Debugger.LogError('objUnuseList  ----------')
    --Debugger.LogError(PrintTable.ToString(self.objUnuseList))
    --Debugger.LogError('objUseList  ----------')
    --Debugger.LogError(PrintTable.ToString(self.objUseList))
    return obj
end

function ColliderManager.DrawColliderMesh(self)
    for k,v in pairs(self.objUseList) do
        v.transform.position = Vector3.New(1000,0,0)
        table.insert(self.objUnuseList,v)
    end

    self.objUseList = {}

    local leftX = (0 - rowMax / 2 + 0.5) * lineSpace
    local rightX = (0 + rowMax / 2 + 0.5) * lineSpace
    local bottomY = (0 - lineMax / 2 + 0.5) * lineSpace
    local topY = (0 + lineMax / 2 + 0.5) * lineSpace

    for i=0,rowMax,1 do
        local x = leftX + lineSpace * i
        UnityEngine.Debug.DrawLine(Vector3.New(x,topY,-10),Vector3.New(x,bottomY,-10),Color.blue)
    end
    for i=0,lineMax,1 do
        local y = bottomY + lineSpace * i
        UnityEngine.Debug.DrawLine(Vector3.New(leftX,y,-10),Vector3.New(rightX,y,-10),Color.blue)
    end

    for k,v in pairs(self.unitList) do
        local unit = v
        local obj = ColliderManager.GetMeshCache(self)
        obj.transform.position = Vector3.New(lineSpace * (v.x ),lineSpace * (v.y ),-11)
    end

end

---每次检测前都要清理一次
function ColliderManager:Clean()
    self.unitList = {}
end

---碰撞元素入栈
function ColliderManager:Stack(pos,width,height,colliderType)
    local modX = math.abs(math.mod(pos.x,lineSpace))
    local modY = math.abs(math.mod(pos.y,lineSpace))

    local addX = 0
    local addY = 0

    if modX > lineSpace / 2 and pos.x > 0 then
        addX = 1
    elseif modX < lineSpace / 2 and pos.x< 0 then
        addX = 1
    end

    if modY > lineSpace / 2 and pos.y > 0 then
        addY = 1
    elseif modY < lineSpace / 2 and pos.y < 0 then
        addY = 1
    end

    ---中心位置
    local centerX = math.floor(pos.x / lineSpace)
    local centerY = math.floor(pos.y / lineSpace)
    ---总长
    local xCnt = width / lineSpace
    local yCnt = height / lineSpace

    local xBegin = math.floor((0 - xCnt) / 2) + 1 + addX
    local xEnd = math.floor((0 + xCnt) / 2)+ addX

    local jBegin = math.floor((0 - yCnt) / 2) + 1 + addY
    local jEnd = math.floor((0 + yCnt) / 2)+ addY

    --Debugger.LogError('centerX  ' .. centerX .. '  lineY  ' .. centerY)

    local str = ''
    local strID = ''
    local cnt = 0
    for i = xBegin,xEnd, 1 do
        for j = jBegin, jEnd, 1 do
            local x = centerX + i
            local y = centerY + j
            local id = x * self.max + y

            cnt = cnt + 1
            str = str .. '(' ..x .. ',' .. y .. ')'
            strID = strID .. ',' .. id

            local unit = self.unitList[id]
            if unit == nil then
                unit = ColliderUnit.new()
                unit.id = id
                unit.x = x
                unit.y = y
                unit.centerX = centerX
                unit.centerY = centerY
                self.unitList[id] = unit
            end

            unit:AddType(colliderType)
        end
    end

    --Debugger.LogError('cnt ' .. cnt)
    --Debugger.LogError('str ' .. str)
    --Debugger.LogError('strID ' .. strID)
    --Debugger.LogError(PrintTable.ToString(self.unitList))

    self:DebugUnitList()
end

function ColliderManager:DebugUnitList()
    local cnt = 0
    for k,v in pairs(self.unitList) do
        cnt = cnt +1
    end
    --Debugger.LogError('DebugUnitList  cnt ' .. cnt)
end

---碰撞检测
function ColliderManager:ColliderDetect()

end
