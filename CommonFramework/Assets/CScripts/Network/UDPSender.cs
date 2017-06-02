using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Net.Sockets;

public class UDPSender 
{
	private static UDPSender m_Instance;
	public static UDPSender Instance
	{
		get
		{
			if (m_Instance == null)
			{
				m_Instance = new UDPSender();
			}
			return m_Instance;
		}
	}

	public void SendUDPMsg(byte[] data,int seq)
	{
		UDPDataPacket dataPacket = new UDPDataPacket();
		dataPacket.seq = seq;
		dataPacket.data = data;
	}
}
