using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using System.IO;
using System.Diagnostics;

public class LuaPackger 
{
	public enum ECpuType
	{
		Cpu_32,
		Cpu_64,
	};

	private static ECpuType cpuType;
	private static string ProjectDataPath = Application.dataPath + "/";
	private static string ProjectPath = ProjectDataPath.Replace("Assets/", "");
	private static string LuaSourcePath = Application.dataPath + "/Lua";
	private static string LuaLibsPath = LuaSourcePath + "/LuaLibs";
	private static string LuaScriptPath = LuaSourcePath + "/LuaScript";

	[MenuItem("Resource/构建 32位 iOS 素材资源", false, 100)]
	public static void BuildiOS32Resource()
	{
		BuildTarget target;
		#if UNITY_5
		target = BuildTarget.iOS;
		#else
		target = BuildTarget.iPhone;
		#endif
		cpuType = ECpuType.Cpu_32;
		BuildAssetResource(target);
	}

	[MenuItem("Resource/构建 64位 iOS 素材资源", false, 101)]
	public static void BuildiOS64Resource()
	{
		BuildTarget target;
		#if UNITY_5
		target = BuildTarget.iOS;
		#else
		target = BuildTarget.iPhone;
		#endif
		cpuType = ECpuType.Cpu_64;
		BuildAssetResource(target);
	}

	[MenuItem("Resource/构建 Android 素材资源", false, 102)]
	public static void BuildAndroidResource()
	{
		BuildAssetResource(BuildTarget.Android);
	}

	[MenuItem("Resource/构建 Windows 素材资源", false, 103)]
	public static void BuildWindowsResource()
	{
		BuildAssetResource(BuildTarget.StandaloneWindows);
	}

//	[MenuItem("Resource/清空所有构建资源", false, 104)]
//	public static void ClearAllResource()
//	{
//		UnityEngine.Debug.ClearDeveloperConsole();
//		UnityEngine.Debug.Log(string.Format("<color=cyan>===================Start to Clean Resource==================</color>"));
//		if (Directory.Exists(SystemUtil.DataPath))
//		{
//			Directory.Delete(SystemUtil.DataPath, true);
//		}
//
//		string streamingPath = Application.streamingAssetsPath + "/";
//		if (File.Exists(streamingPath + AppConst.LuaMapFile))
//		{
//			File.Delete(streamingPath + AppConst.LuaMapFile);
//		}
//		string luaFolder = streamingPath + AppConst.LuaRootDir;
//		if (Directory.Exists(luaFolder))
//		{
//			Directory.Delete(luaFolder, true);
//		}
//
//
//		string path = Application.persistentDataPath + AppConst.FileSeparator + LuaConst.osDir;
//		clearPathAllFiles(path);
//
//		path = Application.dataPath + AppConst.FileSeparator + AppConst.LuaTempDir;
//		clearPathAllFiles(path);
//		AssetDatabase.Refresh();
//		UnityEngine.Debug.Log(string.Format("<color=cyan>===================Clean Resource Finish==================</color>"));
//	}
//
//	[MenuItem("Resource/加密File(测试)", false, 201)]
//	public static void EncryptFileTxt()
//	{
//		BuildFileIndex();
//		AssetDatabase.Refresh();
//	}
//
//	[MenuItem("Resource/解密File(测试)", false, 202)]
//	public static void DncryptFileTxt()
//	{
//		DecryptFileTxt();
//		AssetDatabase.Refresh();
//	}

	private static void CreateStreamDir(string dir)
	{
		dir = Application.streamingAssetsPath + "/" + dir;

		if (!File.Exists(dir))
		{
			Directory.CreateDirectory(dir);
		}
	}

	/// <summary>
	/// 生成绑定素材
	/// </summary>
	private static void BuildAssetResource(BuildTarget target)
	{
		//ClearAllResource();
		CreateStreamDir("Lua/");
		string[] files = Directory.GetFiles(LuaSourcePath, "*.lua", SearchOption.AllDirectories);
		string luajitDir = GetLuaJitPath (target);
		string exeDir = GetByteCodeExecutorPath (target);

		for (int i = 0; i < files.Length; i++)
		{
			int len = 0;
			string filePath = files [i];
			UnityEngine.Debug.LogError ("files  " + filePath);

			if (filePath.Contains (LuaScriptPath)) 
			{
				len = LuaScriptPath.Length;
			} 
			else 
			{
				len = LuaLibsPath.Length;
			}

			UnityEngine.Debug.LogError ("(files [i].Contains (LuaScriptPath)) ");
			string str = filePath.Remove(0, len);
			string[] strs = str.Split ('/');
			string filename = strs [strs.Length - 1];
			string dir = str.Remove (str.Length - filename.Length);
			UnityEngine.Debug.LogError ("filename  " + filename);
			UnityEngine.Debug.LogError ("dir  " + dir);
			string destDir = luajitDir + dir;
			if (!Directory.Exists (destDir)) 
			{
				Directory.CreateDirectory (destDir);
			}
			string dest = destDir + filename;
			EncodeLuaFile(filePath, dest, exeDir, target);

		}

		AssetDatabase.Refresh();
	}

	private static string GetLuaJitPath(BuildTarget target)
	{
		string exeDir = string.Empty;
		if (Application.platform == RuntimePlatform.WindowsEditor)
		{
			exeDir = ProjectPath + "LuaJitFiles/Windows/";
		}
		else
		{
			switch (target)
			{
			case BuildTarget.Android:
				exeDir = ProjectPath + "LuaJitFiles/Android/";
				break;
			case BuildTarget.iOS:
				if (cpuType == ECpuType.Cpu_32)
					exeDir = ProjectPath + "LuaJitFiles/iOS/x86/";
				else
					exeDir = ProjectPath + "LuaJitFiles/iOS/x86_64/";
				break;
			case BuildTarget.StandaloneWindows:
				exeDir = ProjectPath + "LuaJitFiles/luavm/";
				break;
			}
		}
		UnityEngine.Debug.Log(string.Format("<color=orange>================== Conver bytecode exe path:{0} ===================</color>", exeDir));
		return exeDir;
	}

	private static string GetByteCodeExecutorPath(BuildTarget target)
	{
		string exeDir = string.Empty;
		if (Application.platform == RuntimePlatform.WindowsEditor)
		{
			exeDir = ProjectPath + "LuaEncoder/Windows/";
		}
		else
		{
			switch (target)
			{
			case BuildTarget.Android:
				exeDir = ProjectPath + "LuaEncoder/Android/";
				break;
			case BuildTarget.iOS:
				if (cpuType == ECpuType.Cpu_32)
					exeDir = ProjectPath + "LuaEncoder/iOS/x86/";
				else
					exeDir = ProjectPath + "LuaEncoder/iOS/x86_64/";
				break;
			case BuildTarget.StandaloneWindows:
				exeDir = ProjectPath + "LuaEncoder/luavm/";
				break;
			}
		}
		UnityEngine.Debug.Log(string.Format("<color=orange>================== Conver bytecode exe path:{0} ===================</color>", exeDir));
		return exeDir;
	}

	private static void EncodeLuaFile(string srcFile, string outFile, string exeDir, BuildTarget target)
	{
		if (!srcFile.ToLower().EndsWith(".lua"))
		{
			File.Copy(srcFile, outFile, true);
			return;
		}
		bool isWin = true; 
		string luaexe = string.Empty;
		string args = string.Empty;
		string currDir = Directory.GetCurrentDirectory();
		if (Application.platform == RuntimePlatform.WindowsEditor)
		{
			isWin = true;
			luaexe = "luajit.exe";
			args = "-b " + srcFile + " " + outFile;
			Directory.SetCurrentDirectory(exeDir);
		}
		else
		{
			switch (target)
			{
			case BuildTarget.Android:
				luaexe = "luajit";
				args = "-b " + srcFile + " " + outFile;
				isWin = false;
				Directory.SetCurrentDirectory(exeDir);
				break;
			case BuildTarget.iOS:
				luaexe = "luajit";
				args = "-b " + srcFile + " " + outFile;
				isWin = false;
				Directory.SetCurrentDirectory(exeDir);
				break;
			case BuildTarget.StandaloneWindows:
				isWin = false;
				luaexe = "./luac";
				args = "-o " + outFile + " " + srcFile;
				Directory.SetCurrentDirectory(exeDir);
				break;
			}
		}

		ProcessStartInfo info = new ProcessStartInfo();
		info.FileName = luaexe;
		info.Arguments = args;
		info.WindowStyle = ProcessWindowStyle.Hidden;
		info.UseShellExecute = isWin;
		info.ErrorDialog = true;
//		UnityEngine.Debug.Log(string.Format("<color=lightblue>make lua bytecode: {0} > {1} </color>", srcFile.Remove(0, CustomSettings.ProjectPath.Length), outFile.Remove(0, CustomSettings.ProjectPath.Length)));

		Process pro = Process.Start(info);
		pro.WaitForExit();
		Directory.SetCurrentDirectory(currDir);
		pro.Dispose();
	}

}
