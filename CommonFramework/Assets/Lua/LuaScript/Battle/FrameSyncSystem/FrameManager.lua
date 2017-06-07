---
--- Created by luzhuqiu.
--- DateTime: 2017/6/6 下午5:23
---帧回合管理器

FrameManager = class()

local framesPerSecond = 20---每秒多少帧回合
local gameTurnPerFrameTurn = 3 ---每帧回合多少游戏帧
local timeSyncFrame = 1 ---强制同步服务端帧数平滑秒数

function FrameManager:GetInstance()
    if self.m_instance == nil then
        self.m_instance = FrameManager.new()
    end
    return self.m_instance
end

function FrameManager:Init(gameLogicUpdateFunc)
    self.currentFrameTurn = 0
    self.currentGameTurn = 0
    self.timeCache = 0
    self.timePerFrame = 1 / framesPerSecond
    self.timePerGameTurn = self.timePerFrame / gameTurnPerFrameTurn
    self.timePerGameTurnConst = self.timePerFrame / gameTurnPerFrameTurn ---不受speed影响
    self.isSpeeding = false
    self.speedEndFrame = -1
    self.gameLogicUpdateFunc = gameLogicUpdateFunc
end

function FrameManager:Pause()

end

---speed:设置帧速度 speedEndFrame:多少帧回复正常
function FrameManager:SetSpeed(speed,speedEndFrame)
    if self.isSpeeding then
        return
    end

    self.timePerFrame = 1 / framesPerSecond
    self.timePerGameTurn = self.timePerFrame / gameTurnPerFrameTurn / speed
end

function FrameManager:RestoreSpeed()
    self.isSpeeding = false

    self.timePerFrame = 1 / framesPerSecond
    self.timePerGameTurn = self.timePerFrame / gameTurnPerFrameTurn
end

function FrameManager:Update(delTime)
    self.timeCache = self.timeCache + delTime
    if self.timeCache > self.timePerGameTurn then
        local timePass = self.timeCache
        local updateTime = timePass / self.timePerGameTurn
        updateTime = math.floor(updateTime)
        for i=1,updateTime,1 do
            --GameTurnManager:GetInstance():Update(self.timePerGameTurnConst)
            self:GameLogicUpdate(self.timePerGameTurnConst)
            self.currentGameTurn = self.currentGameTurn + 1
            --Debugger.LogError('当前游戏帧 --------- ' .. self.currentGameTurn .. ' self.timePerGameTurn ' .. self.timePerGameTurn ..
            --' updateTime ' .. updateTime .. '  self.timeCache ' .. self.timeCache .. '  delTime  ' .. delTime)
            if self.currentGameTurn == gameTurnPerFrameTurn then
                self.currentGameTurn = 0
                self.currentFrameTurn = self.currentFrameTurn + 1
                if self.speedEndFrame ~= -1 and self.speedEndFrame == self.currentFrameTurn then
                    self:RestoreSpeed()
                end
                --Debugger.LogError('回合帧----------- ' .. self.currentFrameTurn)
            end
        end
        self.timeCache = self.timeCache - updateTime * self.timePerGameTurn
    end
end

function FrameManager:GameLogicUpdate(deltaTime)
    self.gameLogicUpdateFunc(deltaTime)
end