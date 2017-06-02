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

	public static void SendUDPMsg(int seq,byte[] data)
	{
		UDPServer.Instance.SendUDPMsg(data,seq);
	}

	public static void SendTCPMsg(byte[] byteArray)
	{

	}
}
