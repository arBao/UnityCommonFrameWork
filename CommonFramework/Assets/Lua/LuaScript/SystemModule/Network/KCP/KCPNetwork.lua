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
    self.actionReceive = actionReceive
    self.kcpSocket:Init(kcpid, remoteIP, localPort, remotePort,actionReceive);
end

---传入byte字符串
function KCPNetwork:Send(data)
    self.kcpSocket:Send(data)
end

function KCPNetwork:Update()
    self.kcpSocket:Update()
end
