---
--- Created by luzhuqiu.
--- DateTime: 2017/6/5 下午2:22
---
require 'SystemModule/Network/UDPDataPacket'
UdpNetwork = class()

function UdpNetwork.Reset()

end

function UdpNetwork.Send(id,data)
    local packet = UDPDataPacket.new()
    packet:Pack(id,256,data)

end