---
--- Created by luzhuqiu.
--- DateTime: 2017/6/16 上午11:11
---
TimerEvent = class()
function TimerEvent:ctor()
    self.id = 0
    self.delay = 0
    self.actionCallback = nil
    self.parm = nil
    self.timeCal = 0
    self.repeatTimes = 0
    self.currentTime = 0
end

TimerManager = class()

function TimerManager:GetInstance()
    if self.m_Instance == nil then
        self.m_Instance = TimerManager.new()
    end
    return self.m_Instance
end

function TimerManager:ctor()
    self.id = 0
    self.dicTimers = {}
    self.listIDWaitToRemove = {}
    FixedUpdateBeat:Add(TimerManager.FixedUpdate,self)
end

---delay:单位是秒
---parm: actionDelay传入参数
---repeatTimes:重复次数，0 为不重复和 1 效果相同，-1为无限重复,大于0为有限次
function TimerManager:CallActionDelay(actionDelay,delay,parm,repeatTimes)
    if delay == 0 then
        delay = 1
    end

    if repeatTimes <= -1 then
        repeatTimes = -1
    end

    local timerEvent = TimerEvent.new()
    timerEvent.id = self.id
    timerEvent.actionCallback = actionDelay
    timerEvent.delay = delay
    timerEvent.parm = parm
    timerEvent.repeatTimes = repeatTimes
    self.dicTimers[timerEvent.id] = timerEvent

    self.id = self.id + 1

    return timerEvent.id
end

function TimerManager:DeleteTimer(id)
    self.dicTimers[id] = nil
end

function TimerManager.FixedUpdate(self)
    for k,timerEvent in pairs(self.dicTimers) do
        timerEvent.timeCal = timerEvent.timeCal + Time.fixedDeltaTime
        if timerEvent.repeatTimes == 0 then
            if timerEvent.timeCal >= timerEvent.delay then
                if timerEvent.actionCallback ~= nil then
                    timerEvent.actionCallback(timerEvent.parm)
                end
                table.insert(self.listIDWaitToRemove,timerEvent.id)
            end
        elseif timerEvent.repeatTimes == -1 then
            if timerEvent.timeCal >= (timerEvent.currentTime + 1) * timerEvent.delay then
                timerEvent.currentTime = timerEvent.currentTime + 1
                if timerEvent.actionCallback ~= nil then
                    timerEvent.actionCallback(timerEvent.parm)
                end
            end
        else
            if timerEvent.timeCal >= (timerEvent.currentTime + 1)* timerEvent.delay then
                timerEvent.currentTime = timerEvent.currentTime + 1
                if timerEvent.actionCallback ~= nil then
                    timerEvent.actionCallback(timerEvent.parm)
                end
                if timerEvent.currentTime >= timerEvent.repeatTimes then
                    table.insert(self.listIDWaitToRemove,timerEvent.id)
                end
            end
        end
    end

    for i = 1,#self.listIDWaitToRemove do
        self.dicTimers[self.listIDWaitToRemove[i]] = nil
    end

end

