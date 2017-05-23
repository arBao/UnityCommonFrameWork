LuaComponentTest =
{
	Hp = 100,
	att = 50,
	name = 'LuaComponentTest',
	MonoComponent = nil,
}

function LuaComponentTest:Awake(obj)
	Debugger.LogError('Awake = '..self.name..'  obj  '..obj.name);
	self.MonoComponent = obj
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