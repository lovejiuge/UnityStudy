
MonoBehaviour = UnityEngine.MonoBehaviour
GameObject = UnityEngine.MonoBehaviour

function main()


	local s,c=Custom.staticCustom();
	print("first--------------"+s,c)

	local a,b,x=c:instanceCustom()
	print(a,b,x)

	-- Type parameter can be pass in as string/type table
	print(c:getTypeName("UnityEngine.MonoBehaviour,UnityEngine"))
	print(c:getTypeName(MonoBehaviour))
	print(c:getTypeName(Custom))
	print(c:getTypeName(c:GetType()))

	-- Test getItem setItem
	print("---<"..c:getItem("test"))
	c:setItem("test",10)
	print("-->"..c:getItem("test"))
	c:setItem("test",100)
	print("-->"..c:getItem("test"))

    assert(c:getInterface():getInt()==10)
    c:getInterface():setInt(11)
    print("assert interface ok")
end