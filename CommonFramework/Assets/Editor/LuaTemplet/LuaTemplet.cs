using UnityEngine;
using System.IO;
using System.Collections;
using UnityEditor;

public class LuaTemplet 
{
	[MenuItem("Assets/Lua模板/创建View类")]
	public static void CreateViewClass()
	{
		string defaultPath = Application.dataPath + "/Lua/LuaScript/Modules/Views";
		string savePath = EditorUtility.SaveFilePanel ("请输入View类名", defaultPath, "View", "lua");
		string templetPath = Application.dataPath.Remove (Application.dataPath.Length - 6, 6) + "LuaTemplet/ViewTemplet.lua";

		CreateFile (savePath, templetPath,"ViewTemplet");
	}

	[MenuItem("Assets/Lua模板/创建Controller类")]
	public static void CreateControllerClass()
	{
		string defaultPath = Application.dataPath + "/Lua/LuaScript/Modules/Controllers";
		string savePath = EditorUtility.SaveFilePanel ("请输入Controller类名", defaultPath, "Controller", "lua");
		string templetPath = Application.dataPath.Remove (Application.dataPath.Length - 6, 6) + "LuaTemplet/ControllerTemplet.lua";

		CreateFile (savePath, templetPath,"ControllerTemplet");
	}

	[MenuItem("Assets/Lua模板/创建Model类")]
	public static void CreateModelClass()
	{
		string defaultPath = Application.dataPath + "/Lua/LuaScript/Modules/Models";
		string savePath = EditorUtility.SaveFilePanel ("请输入Model类名", defaultPath, "Model", "lua");
		string templetPath = Application.dataPath.Remove (Application.dataPath.Length - 6, 6) + "LuaTemplet/ModelTemplet.lua";

		CreateFile (savePath, templetPath,"ModelTemplet");
	}

	private static void CreateFile(string savePath,string templetPath,string relpaceName)
	{
		string[] splits = savePath.Split ('/');
		splits = splits [splits.Length - 1].Split ('.');
		string fileName = splits [0];
		if (File.Exists (savePath))
			File.Delete (savePath);
		string luaTemplet = File.ReadAllText (templetPath);
		luaTemplet = luaTemplet.Replace (relpaceName, fileName);
		System.Text.UTF8Encoding utf8 = new System.Text.UTF8Encoding(false);
		File.WriteAllText (savePath, luaTemplet,utf8);

		AssetDatabase.Refresh();
	}
}
