require 'SystemModule/Network/UdpNetwork'
require 'SystemModule/Network/LinkUDPPackets'
require 'Proto/person_pb'
require 'Proto/UdpPackage_pb'
require 'SystemModule/Network/TCPNetwork'

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

            Debugger.LogError('udppackage.posX  ' .. udppackage.posX)
            Debugger.LogError('udppackage.posY  ' .. udppackage.posY)
        end
        --UdpNetwork:GetInstance():Init()
        --UdpNetwork:GetInstance():ListenTo(1000,ReceiveCallback)

        local kcpNetwork = KCPNetwork.New()
        kcpNetwork:Init('kcp1',1,'127.0.0.1',11110,11111)
        kcpNetwork:SetReceiveAny(function(buffer)
            --local udppackage = UdpPackage_pb.UdpPackage()
            --local luabuffer = buffer:ToLuaBuffer()
            --Debugger.LogError('ReceiveAny string.len(luabuffer)  ' .. string.len(luabuffer))
            --udppackage:ParseFromString(luabuffer)
            --
            --Debugger.LogError('ReceiveAny  udppackage.posX  ' .. udppackage.posX)
            --Debugger.LogError('ReceiveAny  udppackage.posY  ' .. udppackage.posY)
        end)
        kcpNetwork:SetReceive(function(buffer)
            --local udppackage = UdpPackage_pb.UdpPackage()
            local luabuffer = buffer:ToLuaBuffer()
            Debugger.LogError('Receive string.len(luabuffer)  ' .. string.len(luabuffer))
            --udppackage:ParseFromString(luabuffer)

            --Debugger.LogError('Receive  udppackage.posX  ' .. udppackage.posX)
            --Debugger.LogError('Receive  udppackage.posY  ' .. udppackage.posY)
        end)

        UpdateBeat:Add(function (self)
            kcpNetwork:Update()
        end,self)

        self.loginView.OnClickButtonSendCallback = function ()
            self.id = self.id + 1
            self.seq = self.seq + 1
            local udppackage = UdpPackage_pb.UdpPackage()
            udppackage.posX = 100 + self.id
            udppackage.posY = 200 + self.id
            local data = udppackage:SerializeToString()
            local length = string.len(data)
            Debugger.LogError('length  ' .. length)
            local sendData = 'asdfasdfasdfasdjfhajksdhfklasdjglkajsglkjalsgjdflagjldsfjblkjweasdfasdfasdfasdjfhajksdhfklasdjglkajsglkjalsgjdflagjldsfjblkjweasdfasdfasdfasdjfhajksdhfklasdjglkajsglkjalsgjdflagjldsfjblkjweasdfasdfasdfasdjfhajksdhfklasdjglkajsglkjalsgjdflagjldsfjblkjwe'

            Debugger.LogError('sendData  ' .. string.len(sendData))
            --UdpNetwork:GetInstance():Send(1000,data)
            kcpNetwork:Send(data)
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
            local p9 = UDPDataPacket.new()
            p9.seq = 3

            link:Insert(p1,true)
            link:Insert(p2,true)
            link:Insert(p3,true)
            link:Insert(p4,true)
            link:Insert(p5,true)
            link:Insert(p6,true)
            link:Insert(p7,true)
            link:Insert(p8,true)
            link:Insert(p9,true)

            link:PrintLink(false)
            link:PrintLink(true)
        end

        self.loginView.OnClickButtonBattleCallback = function ()
            local funcProgress = function (operation)
                Debugger.LogError(operation.progress)
            end
            local finishCallback = function ()
                self:SendMessage(MessageNames.OpenUIBattle,nil)
            end
            SceneMgr.LoadASync('Battle',funcProgress,finishCallback,false)
        end
        TCPSocket.Instance:SetRecvCallback(
        function(bytebuffer)
            local luabuffer = bytebuffer:ToLuaBuffer()
            Debugger.LogError('Receive string.len(luabuffer)  ' .. string.len(luabuffer))
        end)
        self.loginView.OnClickButtonTcpConnectCallback = function ()
            TCPNetwork:GetInstance():Connect('127.0.0.1',9999,
            function ()
                Debugger.LogError('Success connect')
            end,
            function(err)
                Debugger.LogError('fail ' .. err)
            end)

            TimerManager:GetInstance():CallActionDelay(function(parm)
                Debugger.LogError('calldelay  ' .. parm)
            end,3,'11',3)
        end

        self.loginView.OnClickButtonTcpSendCallback = function ()
            TCPNetwork:GetInstance():Send(1,'11111',
            function()
                Debugger.LogError('Success send')
            end,
            function(err)
                Debugger.LogError('fail send ' .. err)
            end)
        end

    end
    self.loginView:Show()

end

return ControllerLogin