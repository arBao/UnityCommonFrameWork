LuaComponentTest =
{
	Hp = 100,
	att = 50,
	name = 'LuaComponentTest',
	MonoComponent = nil,
	gameObject = nil,
}

function LuaComponentTest:Awake(monobehaviour)
	Debugger.LogError('Awake = '..self.name..'  monobehaviour  '..monobehaviour.name);
	self.MonoComponent = monobehaviour
	self.gameObject = self.MonoComponent.gameObject
end

function LuaComponentTest:Start()
	Debugger.LogError('Start = '..self.name);
end

function LuaComponentTest:OnEnable()
	Debugger.LogError('OnEnable = '..self.name);
end

function LuaComponentTest:OnDisable()
	Debugger.LogError('OnDisable = '..self.name);
end

function LuaComponentTest:OnDestroy()
	Debugger.LogError('OnDestroy = '..self.name);
end

function LuaComponentTest:New()
	local o = {}
	setmetatable(o,self)
	self.__index = self
	return o
end