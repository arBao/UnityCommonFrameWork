---
--- Created by luzhuqiu.
--- DateTime: 2017/6/16 上午10:56
---
require 'SystemModule/Timer/TimerManager'
require 'SystemModule/Network/TCP/DataPacket'
require 'SystemModule/Network/TCP/TCPSendTaskManager'

TCPNetwork = class()

function TCPNetwork:GetInstance()
    if self.m_Instance == nil then
        self.m_Instance = TCPNetwork.new()
    end
    return self.m_Instance
end

function TCPNetwork:Init()
    TCPSocket.Instance:SetRecvCallback(
    function(bytebuffer)
        local luabuffer = bytebuffer:ToLuaBuffer()
        local data = DataPacket.UnPacket(luabuffer)

        local id = data[1]
        local length = data[2]
        local seq = data[3]
        local dataBytes = data[4]

        if seq ~= 0 then
            local task = TCPSendTaskManager:GetInstance():GetTask(seq)
            if task.successCallback ~= nil then
                task.successCallback(dataBytes)
            end
            TCPSendTaskManager:GetInstance():CancelTask(seq)
        end
    end)

    TCPSocket.Instance:SetSendCallback(
    function()
        --Debugger.LogError('send sucess')
    end,
    function(err)
        ---todo 局域网无法模拟sendfail 以后待开发
        Debugger.LogError('send fail  ' .. err)
    end
    )

    TCPSocket.Instance:SetServerDisconnectCallback(
    function ()
        Debugger.LogError('服务端主动断开连接  ')

    end
    )
end

function TCPNetwork:ReConnect()
    TCPSocket.Instance:Disconnect()
    TCPSocket.Instance:Connect()
end

function TCPNetwork:Connect(ip,prot,funcSuccess,funcFail)
    TCPSocket.Instance:Connect(ip,prot,funcSuccess,funcFail)
end

---往返发送，有返回消息
function TCPNetwork:Send(msgID,data,successCallback,failCallback)
    local seq = TCPSendTaskManager:GetInstance():GetSeq()
    local dataSend = DataPacket.Packet(msgID,seq,data)
    TCPSendTaskManager:GetInstance():AddTask(msgID,seq,dataSend,successCallback,failCallback)
    TCPSocket.Instance:Send(dataSend)
end

---单程发送，无返回消息
function TCPNetwork:SendOneWay(msgID,data)
    --local seq = TCPSendTaskManager:GetInstance():GetSeq()
    local dataSend = DataPacket.Packet(msgID,0,data)
    TCPSocket.Instance:Send(dataSend)
end

