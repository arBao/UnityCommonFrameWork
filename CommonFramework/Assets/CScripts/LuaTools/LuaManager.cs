using UnityEngine;
using System.Collections;
using LuaInterface;
using System;
using System.Reflection;
using System.Text;

public class LuaManager : LuaClient
{

	protected override LuaFileUtils InitLoader()
	{
		return new LuaResLoader();
	}

	protected override void OnLoadFinished()
	{
		base.OnLoadFinished();

	}
}