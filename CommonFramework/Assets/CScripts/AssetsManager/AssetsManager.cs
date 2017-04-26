using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class AssetsManager 
{
	private Dictionary<string,AssetBundle> dicBundlesCache = new Dictionary<string, AssetBundle> ();
	private AssetsManager m_Instance = null;
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

		}
		else if (Application.platform == RuntimePlatform.Android)
		{

		}
		else 
		{

		}
	}
}
