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

	protected override LuaFileUtils InitLoader ()
	{
		Debug.LogError ("LuaManager  InitLoader");

		LuaFileUtilsCustom lfu = new LuaFileUtilsCustom ();
		Debug.LogError ("Application.platform  ---------> " + Application.platform);
		if (Application.platform == RuntimePlatform.Android || Application.platform == RuntimePlatform.IPhonePlayer) 
		{
			lfu.beZip = true;
		}
//		lfu.beZip = true;

		return lfu as LuaFileUtils;	
	}
		
}