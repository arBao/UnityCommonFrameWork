ClassFather = class()
function ClassFather:ctor(val)
    print('ClassFather ctor')
    self.count = val
end

function ClassFather:show()
    print('ClassFather show')
end

function ClassFather:showNoOverload()
    print('ClassFather showNoOverload')
end
--########

ClassSon1 = class(ClassFather)
function ClassSon1:ctor(val)
    self.count = val
end

function ClassSon1:show()
    self:super('show')
    self:showNoOverload()
    print('ClassSon1 show')
end

--########
ClassSon2 = class(ClassSon1)
function ClassSon2:bake( ... )
	print('ClassSon2 bake')
end


--########

local o = ClassSon1.new(5)
print(o.count)
o:show()

o = ClassSon2.new()
o:show()


--以上是封装继承多态


InterfaceShow = class()
