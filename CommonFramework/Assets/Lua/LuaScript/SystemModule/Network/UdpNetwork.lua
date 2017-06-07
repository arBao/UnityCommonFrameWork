---
--- Created by luzhuqiu.
--- DateTime: 2017/6/5 下午2:22
---
---
---协议号
----0,99 tcp系统相关
----100,199 udp系统相关
----    100 udp请求重发
----    177 udp心跳
----200,1000 tcp功能相关
----1000,~ udp功能相关
----    1000 udp测试 UdpPackage
----    1001 客户端准备完成
----    1002 服务端通知客户端开战


require 'SystemModule/Network/UDPDataPacket'
require 'SystemModule/Network/LinkUDPPackets'
require 'Proto/UdpLostPackage_pb'

UdpNetwork = class()

local timeSendAgainDelta = 0.1
local timeHeartbeatDelta = 5
local reSendTimeMax = 100 ---重发次数最大限制

function UdpNetwork:GetInstance()
    if self.m_instance == nil then
        self.m_instance = UdpNetwork.new()
    end
    return self.m_instance
end

local function SendRequestSendAgainUpdate(self)
    if Time.time - self.timeSendAgainCache > timeSendAgainDelta then
        self:SendRequestSendAgain()
        self.timeSendAgainCache = Time.time
    end
end

local function SendHeartbeatUpdate(self)
    if Time.time - self.timeHeartbeatCache > timeHeartbeatDelta then
        self:SendHeartbeat()
        self.timeHeartbeatCache = Time.time
    end
end

function UdpNetwork:ListenTo(id,callback)
    if self.listListening[id] == nil then
        self.listListening[id] = {}
    end

    table.insert(self.listListening[id],callback)
end

function UdpNetwork:UnListen(id,callback)
    if self.listListening[id] == nil then
        return
    end

    for k,v in pairs(self.listListening[id]) do
        if v == callback then
            self.listListening[id][k] = nil
            return
        end
    end
end

function UdpNetwork:Init()

    self.timeSendAgainCache = 0
    self.timeHeartbeatCache = 0
    self.sendSeq = 0
    self.resendTimeCal = 0
    self.sendLink = LinkUDPPackets.new()
    self.receiveLink = LinkUDPPackets.new()
    self.listListening = {}

    UDPServer.Instance:InitUDPServer('127.0.0.1',1111,'127.0.0.1',1110)
    local funcSendSucess = function()
        --sendSucess()
    end
    local funcReceiveCallback = function(data)
        local pack = UDPDataPacket.new()
        pack:UnPack(data)

        if pack.id == 100 then
            local lostPackage = UdpLostPackage_pb.UdpLostPackage()
            lostPackage:ParseFromString(pack.data)
            for i=1,#lostPackage.listSeqID do
                Debugger.LogError('收到重发包请求 seqid : ' .. lostPackage.listSeqID[i])
                self:ReSend(lostPackage.listSeqID[i])
            end
        elseif pack.id == 177 then
            Debugger.LogError('心跳')
        elseif pack.id > 200 then
            self.receiveLink:Insert(pack)
            self.receiveLink:CheckLost(pack)

            if self.listListening[pack.id] == nil then
                Debugger.LogError('没有监听方法 id为 : ' .. pack.id)
                return
            end
            for k,v in pairs(self.listListening[pack.id]) do
                v(pack)
            end

            --if receiveCallback == nil then
            --    Debugger.LogError('receiveCallback == nil')
            --else
            --    receiveCallback(pack)
            --end
        end

    end
    UDPServer.Instance:SetSendSucessCallback(funcSendSucess)
    UDPServer.Instance:SetReceive(funcReceiveCallback)

    FixedUpdateBeat:Add(SendRequestSendAgainUpdate, self)
    FixedUpdateBeat:Add(SendHeartbeatUpdate, self)
end

function UdpNetwork:Stop()
    FixedUpdateBeat:Remove(SendRequestSendAgainUpdate,self)
end

--心跳
function UdpNetwork:SendHeartbeat()
    local packet = UDPDataPacket.new()
    packet:Pack(177,0,'')
    UDPServer.Instance:SendUDPMsg(packet.data)
end

--请求服务端重发包
function UdpNetwork:SendRequestSendAgain()

    if next(self.receiveLink.lostSeq) ~= nil then

        local packet = UDPDataPacket.new()
        local lostPackage = UdpLostPackage_pb.UdpLostPackage()
        for k,v in pairs(self.receiveLink.lostSeq) do
            table.insert(lostPackage.listSeqID,k)
            Debugger.LogError('--请求服务端重发包 ' .. k)
        end

        local data = lostPackage:SerializeToString()
        packet:Pack(100,0,data)
        UDPServer.Instance:SendUDPMsg(packet.data)
    end

end

--重发队列里面的包
function UdpNetwork:ReSend(seq)
    self.resendTimeCal = self.resendTimeCal + 1
    if self.resendTimeCal > reSendTimeMax then
        ---大于最大请求次数  判断为掉线
        return
    end
    local packet = self.sendLink:GetPacketBySeq(seq,true)
    if packet ~= nil then
        UDPServer.Instance:SendUDPMsg(packet.data)
    end
end

--发送一个新包
function UdpNetwork:Send(id,data)
    local packet = UDPDataPacket.new()

    packet:Pack(id,self.sendSeq,data)
    self.sendLink:Insert(packet)

    self.sendSeq = self.sendSeq + 1

    UDPServer.Instance:SendUDPMsg(packet.data)
end