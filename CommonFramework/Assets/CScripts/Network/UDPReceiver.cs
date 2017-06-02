using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UDPReceiver 
{
	private static UDPReceiver m_Instance;
	public static UDPReceiver Instance
	{
		get
		{
			if (m_Instance == null)
			{
				m_Instance = new UDPReceiver();
			}
			return m_Instance;
		}
	}

}
