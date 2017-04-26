using UnityEngine;
using System.Collections;
using System.IO;
namespace LuaInterface
{
	public class LuaFileUtilsCustom:LuaFileUtils
	{
		public LuaFileUtilsCustom():base()
		{
			
		}

		public override byte[] ReadFile (string fileName)
		{
			if (!beZip)
			{
				string path = FindFile(fileName);
				byte[] str = null;

				if (!string.IsNullOrEmpty(path) && File.Exists(path))
				{
					#if !UNITY_WEBPLAYER
					str = File.ReadAllBytes(path);
					#else
					throw new LuaException("can't run in web platform, please switch to other platform");
					#endif
				}

				return str;
			}
			else
			{
				return ReadZipFile(fileName);
			}
		}

		private byte[] ReadZipFile(string fileName)
		{
			
			return new byte[0];
		}

	}
}

