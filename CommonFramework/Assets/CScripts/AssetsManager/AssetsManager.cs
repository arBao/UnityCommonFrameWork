using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public enum ECpuType
{
	Cpu_32,
	Cpu_64,
};

public class AssetsManager 
{
	private Dictionary<string,AssetBundle> dicBundlesCache = new Dictionary<string, AssetBundle> ();
	private static AssetsManager m_Instance = null;
	public static AssetsManager Instance
	{
		get 
		{
			if (m_Instance == null) 
			{
				m_Instance = new AssetsManager ();
			}
			return m_Instance;
		}
	}
	#region lua相关

	public AssetBundle GetLuaBundle(string fileName)
	{
		if (dicBundlesCache.ContainsKey (fileName)) 
		{
			return dicBundlesCache [fileName];
		}
		string path = GetLuaABPath (fileName);
		dicBundlesCache [fileName] = AssetBundle.LoadFromFile (path);

		return dicBundlesCache [fileName];
	}

	private string GetLuaABPath(string fileName)
	{
		fileName = fileName.ToLower ();
		string abPath = "";

		if (Application.platform == RuntimePlatform.IPhonePlayer)
		{
			ECpuType cpuType = ECpuType.Cpu_64;
			if (cpuType == ECpuType.Cpu_32)
				abPath = Application.streamingAssetsPath + "/luajitfiles/ios/cpu_32/" + fileName + ".bytes";
			else
				abPath = Application.streamingAssetsPath + "/luajitfiles/ios/cpu_64/"+ fileName+ ".bytes";
		}
		else if (Application.platform == RuntimePlatform.Android)
		{
			abPath = Application.streamingAssetsPath + "/luajitfiles/android/"+ fileName + ".bytes";
		}
		else 
		{

		}

		return abPath;
	}

	#endregion

	#region 资源相关
	public object GetAsset (string path, System.Type type, bool isGetAsset)
	{
		#if UNITY_EDITOR
		 UnityEditor.AssetDatabase.LoadAssetAtPath(path,type);
		#else
				
		#endif
		
	}
	#endregion
	
}
