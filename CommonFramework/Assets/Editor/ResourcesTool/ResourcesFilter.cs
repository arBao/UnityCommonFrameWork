using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.IO;

public class ResourceInfo
{
	public string dir;
	public List<string> suffixs = new List<string> ();
}

public class ResourcesFilter 
{
	
	public static List<string> GetAllPackagerFiles()
	{
		List<ResourceInfo> listRi = new List<ResourceInfo> ();

		ResourceInfo ri = new ResourceInfo ();
		#if UNITY_IPHONE
		ri.dir = Application.dataPath + "/LuaJitFiles/iOS";
		#endif

		#if UNITY_STANDALONE_OSX
		ri.dir = Application.dataPath + "/LuaJitFiles/luavm";
		#endif

		#if UNITY_STANDALONE_WIN
		ri.dir = Application.dataPath + "/LuaJitFiles/luavm";
		#endif

		#if UNITY_ANDROID
		ri.dir = Application.dataPath + "/LuaJitFiles/Android";
		#endif

		ri.suffixs.Add ("*.bytes");

		listRi.Add (ri);


		return GetAllFilesByResourceInfos(listRi);
	}

	private static List<string> GetAllFilesByResourceInfos(List<ResourceInfo> listRi)
	{
		List<string> listFiles = new List<string> ();
		for (int i = 0; i < listRi.Count; i++) 
		{
			ResourceInfo ri = listRi [i];
			if (Directory.Exists (ri.dir)) 
			{
				for (int j = 0; j < ri.suffixs.Count; j++) 
				{
					listFiles.AddRange(Directory.GetFiles (ri.dir, ri.suffixs [j],SearchOption.AllDirectories));
				}

			}
		}

		return listFiles;
	}

}
