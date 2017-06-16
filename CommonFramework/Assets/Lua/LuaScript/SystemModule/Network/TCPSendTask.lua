---
--- Created by luzhuqiu.
--- DateTime: 2017/6/16 下午5:45
---
TCPSendTask = class()

local timeOut = 5

function TCPSendTask:ctor()

end

function TCPSendTask:Set(msgID,seq,dataSend,successCallback,failCallback)
    self.msgID = msgID
    self.seq = seq
    self.dataSend = dataSend
    self.successCallback = successCallback
    self.failCallback = failCallback

    local timeOutFunc = function()
        if failCallback == nil then
            failCallback('发送信息超时')
        end
    end

    self.timerID = TimerManager:GetInstance():CallActionDelay(timeOutFunc,timeOut,dataSend,0)
end

function TCPSendTask:CancelTimer()
    TimerManager:GetInstance():DeleteTimer(self.timerID)
end
