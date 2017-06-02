using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class NetworkManager 
{
	private static NetworkManager m_Instance;
	public static NetworkManager Instance
	{
		get
		{
			if(m_Instance == null)
			{
				m_Instance = new NetworkManager();
			}
			return m_Instance;
		}
	}

	public static void SendUDPMsg(byte[] data)
	{
		UDPSender.Instance.SendUDPMsg(data);
	}

	public static void SendTCPMsg(byte[] byteArray)
	{

	}
}
