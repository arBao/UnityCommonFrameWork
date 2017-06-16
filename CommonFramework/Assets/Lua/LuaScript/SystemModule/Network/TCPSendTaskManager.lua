---
--- Created by luzhuqiu.
--- DateTime: 2017/6/16 下午5:45
---
require 'SystemModule/Network/TCPSendTask'

TCPSendTaskManager = class()
function TCPSendTaskManager:GetInstance()
    if self.m_Instance == nil then
        self.m_Instance = TCPSendTaskManager.new()
    end
    return self.m_Instance
end

function TCPSendTaskManager:ctor()
    self.seq = 1
    self.taskCache = {}
end

function TCPSendTaskManager:GetSeq()
    return self.seq
end

function TCPSendTaskManager:AddTask(msgID,seq,dataSend,successCallback,failCallback)
    local task = TCPSendTask.new()
    task:Set(msgID,seq,dataSend,successCallback,failCallback)
    self.taskCache[seq] = task
    self.seq = self.seq + 1
end

function TCPSendTaskManager:GetTask(seq)
    return self.taskCache[seq]
end

function TCPSendTaskManager:CancelTask(seq)
    local task = self.taskCache[seq]
    if task ~= nil then
        task:CancelTimer()
    end
end