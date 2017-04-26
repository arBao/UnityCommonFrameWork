using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using System.IO;

public class ResourcesExport  
{
	[MenuItem("Assets/AssetBundle/BuildBundles")]
	public static void BuildBundles()
	{
		List<string> listPackagerFiles = ResourcesFilter.GetAllPackagerFiles ();
		for (int i = 0; i < listPackagerFiles.Count; i++) 
		{
			addAssetBundleName (listPackagerFiles [i]);
		}
		string path = Application.streamingAssetsPath;
		BuildTarget target;
		#if UNITY_IPHONE
		target = BuildTarget.iOS;
		#endif

		#if UNITY_STANDALONE_OSX
		target = BuildTarget.StandaloneOSXIntel64;
		#endif

		#if UNITY_STANDALONE_WIN
		target = BuildTarget.StandaloneWindows;
		#endif

		#if UNITY_ANDROID
		target = BuildTarget.Android;
		#endif
		Debug.LogError ("path  " + path);
		AssetDatabase.Refresh();
		BuildPipeline.BuildAssetBundles(path, BuildAssetBundleOptions.ChunkBasedCompression, target);
		CleanManifestFiles ();
		AssetDatabase.Refresh();
	}

	[MenuItem("Assets/AssetBundle/清理 manifest 文件")]
	public static void CleanManifestFiles()
	{
		string path = Application.streamingAssetsPath;
		string[] dirs = Directory.GetFiles (path, "*.manifest", SearchOption.AllDirectories);

		for (int i = 0; i < dirs.Length; i++) 
		{
			File.Delete(dirs[i]);
		}
	}
		

	private static string getAssetBundleName(string fullName){
		string assetBundleName = fullName.Substring (fullName.IndexOf ("Assets"), fullName.Length - fullName.IndexOf ("Assets")).ToLower();
		assetBundleName = assetBundleName.Replace("\\", "/");
		assetBundleName = assetBundleName.Replace("assets/resources/", "");
		return assetBundleName;
	}

	private static string addAssetBundleName(string fullName){
		string assetBundleName = getAssetBundleName(fullName);
		string metaFullName = fullName + ".meta";
		StreamReader metaFs = new StreamReader(metaFullName);
		List<string> ret = new List<string>();
		string line;
		bool isAdd = false;
		while((line = metaFs.ReadLine()) != null) {
			line = line.Replace("\n", "");
			if (line.IndexOf("assetBundleName:") != -1)
			{
				line = "  assetBundleName: " + assetBundleName;
				isAdd = true;
			}
			ret.Add(line);
		}
		if (!isAdd)
		{
			line = "  assetBundleName: " + assetBundleName;
			ret.Add(line);
		}
		metaFs.Close();
		File.Delete(metaFullName);

		StreamWriter writer = new StreamWriter(metaFullName);
		foreach (var each in ret) {
			writer.WriteLine(each);
		}
		writer.Close();
		return assetBundleName;
	}

	private static string removeAssetBundleName(string fullName)
	{
		string assetBundleFlag = "assetBundleName: ";
		string metaFullName = fullName + ".meta";
		StreamReader metaFs = new StreamReader(metaFullName);
		List<string> ret = new List<string>();
		string line;
		while((line = metaFs.ReadLine()) != null) {
			if (line.IndexOf(assetBundleFlag) != -1)
			{
				ret.Add("  assetBundleName: ");
				continue;
			}
			line = line.Replace("\n", "");
			ret.Add(line);
		}
		metaFs.Close();
		File.Delete(metaFullName);

		StreamWriter writer = new StreamWriter(metaFullName);
		foreach (var each in ret) {
			writer.WriteLine(each);
		}
		writer.Close();

		string assetBundleName = getAssetBundleName(fullName);
		if (AssetDatabase.RemoveAssetBundleName(assetBundleName, true))
		{
			Debug.Log(string.Format("删除一个AB名称，名为：{0}", assetBundleName));
		}
		return assetBundleName;
	}

}
