using UnityEngine;
using System.Collections;

public class CSharpTransfer : MonoBehaviour {

	private static CSharpTransfer m_Instance = null;
	public static CSharpTransfer Instance
	{
		get
		{
			if(m_Instance == null)
			{
				m_Instance = new CSharpTransfer();
			}
			return m_Instance;
		}	
	}
	void Awake()
	{
		m_Instance = this;
	}
	public void DontDestroyObj(GameObject obj)
	{
		DontDestroyOnLoad(obj);
	}
}
