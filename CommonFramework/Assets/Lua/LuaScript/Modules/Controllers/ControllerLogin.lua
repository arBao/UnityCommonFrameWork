require 'SystemModule/Network/UdpNetwork'
require 'SystemModule/Network/LinkUDPPackets'
require 'Proto/person_pb'
require 'Proto/UdpPackage_pb'

local ControllerLogin = class(Controller)
function ControllerLogin:ctor()
	self.loginView = nil
	Debugger.LogError('ControllerLogin:ctor')
end

function ControllerLogin:MessagesListening()
	local messages = 
	{
		MessageNames.OpenUILogin,
	}
	return messages
end

function ControllerLogin:OnReciveMessage(msg,msgBody)
	if msg == MessageNames.OpenUILogin then
		Debugger.LogError('MessageNames.OpenUILogin ' .. msgBody)
		self:ShowUILogin()
	elseif msg == '111' then
		Debugger.LogError('111 ' .. msgBody)
	end
end

function ControllerLogin:ShowUILogin()
    if self.loginView == nil then
        self.loginView = self:GetView('ViewUILogin')
        self.loginView.OnClickButtonLoginCallback = function ( )
            self:SendMessage(MessageNames.OpenUIPopUp1,nil)
        end

        if self.id == nil then
            self.id = 0
        end
        if self.seq == nil then
            self.seq = 0
        end

        local SendSucess = function(pack)

        end

        local ReceiveCallback = function(pack)
            --Debugger.LogError('ReceiveCallback')
            local udppackage = UdpPackage_pb.UdpPackage()
            udppackage:ParseFromString(pack.data)
            Debugger.LogError('udppackage.seqid  ' .. udppackage.seqid)
            Debugger.LogError('udppackage.posX  ' .. udppackage.posX)
            Debugger.LogError('udppackage.posY  ' .. udppackage.posY)
        end
        UdpNetwork:GetInstance():Init(SendSucess,ReceiveCallback)


        self.loginView.OnClickButtonSendCallback = function ()
            self.id = self.id + 1
            self.seq = self.seq + 1
            local udppackage = UdpPackage_pb.UdpPackage()
            udppackage.seqid = 10;
            udppackage.posX = 100
            udppackage.posY = 200
            local data = udppackage:SerializeToString()

            UdpNetwork:GetInstance():Send(254,data)

        end

        self.loginView.OnClickButtonLinkTestCallback = function ()
            local link = LinkUDPPackets.new()
            local p1 = UDPDataPacket.new()
            p1.seq = 2
            local p2 = UDPDataPacket.new()
            p2.seq = 1
            local p3 = UDPDataPacket.new()
            p3.seq = 5
            local p4 = UDPDataPacket.new()
            p4.seq = 3
            local p5 = UDPDataPacket.new()
            p5.seq = 0
            local p6 = UDPDataPacket.new()
            p6.seq = 6
            local p7 = UDPDataPacket.new()
            p7.seq = 7
            local p8 = UDPDataPacket.new()
            p8.seq = 10

            link:Insert(p1)
            link:Insert(p2)
            link:Insert(p3)
            link:Insert(p4)
            link:Insert(p5)
            link:Insert(p6)
            link:Insert(p7)
            link:Insert(p8)

            link:PrintLink(false)
            link:PrintLink(true)
        end
    end
    self.loginView:Show()

end

return ControllerLogin