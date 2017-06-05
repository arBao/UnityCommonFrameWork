using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Main : MonoBehaviour {

	[RuntimeInitializeOnLoadMethod]
	static void Initialize()
	{
		Application.runInBackground = true;
		Loom.Initialize();
		GameObject obj = new GameObject("Main");
		DontDestroyOnLoad(obj);
		obj.AddComponent<LuaManager>();
	}
}
