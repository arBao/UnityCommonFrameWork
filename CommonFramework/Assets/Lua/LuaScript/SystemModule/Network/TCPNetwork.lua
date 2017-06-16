---
--- Created by luzhuqiu.
--- DateTime: 2017/6/16 上午10:56
---
require 'SystemModule/Timer/TimerManager'
TCPNetwork = class()

function TCPNetwork:GetInstance()
    if self.m_Instance == nil then
        self.m_Instance = TCPNetwork.new()
    end
    return self.m_Instance
end

function TCPNetwork:Connect(ip,prot,funcSuccess,funcFail)
    TCPSocket.Instance:Connect(ip,prot,funcSuccess,funcFail)
end

function TCPNetwork:Send(msgID,data,successCallback,failCallback)
    TCPSocket.Instance:Send(data,
    successCallback,
    failCallback)
end