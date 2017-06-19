---
--- Created by luzhuqiu.
--- DateTime: 2017/6/19 上午9:54
---
KCPNetwork = class()
function KCPNetwork:GetInstance()
    if self.m_Instance == nil then
        self.m_Instance = KCPNetwork.new()
    end
    return self.m_Instance
end

function KCPNetwork:Dispose()
    self.kcpSocket:Dispose()
    self.kcpSocket = nil
    self.actionReceive = nil
end

function KCPNetwork:Init(kcpid,remoteIP,localPort,remotePort,actionReceive)
    self.kcpSocket = KCPSocket.New()
    local funcRecv = function(byteBuffer)

        local luabuffer = byteBuffer:ToLuaBuffer()
        local data = DataPacket.UnPacket(luabuffer)

        local id = data[1]
        local length = data[2]
        local seq = data[3]
        local dataBytes = data[4]

        if self.actionReceive ~= nil then
            self.actionReceive(dataBytes)
        end
    end
    self.actionReceive = actionReceive
    self.kcpSocket:Init(kcpid, remoteIP, localPort, remotePort,funcRecv);
end

---传入byte字符串
function KCPNetwork:Send(msgID,seq,data)
    local dataSend = DataPacket.Packet(msgID,seq,data)
    self.kcpSocket:Send(dataSend)
end

function KCPNetwork:Update()
    self.kcpSocket:Update()
end
