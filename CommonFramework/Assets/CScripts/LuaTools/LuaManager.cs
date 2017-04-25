using UnityEngine;
using System.Collections;
using LuaInterface;
using System;
using System.Reflection;
using System.Text;

public class LuaManager : LuaClient
{
	protected override void OnLuaStateCreate ()
	{
		base.OnLuaStateCreate ();
		#if UNITY_EDITOR
		luaState.AddSearchPath(LuaConst.luaDir);
		luaState.AddSearchPath(LuaConst.toluaDir);
		#else

		#endif
	}
}