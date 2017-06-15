using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

public class TCPServer 
{
	private TCPServer m_Instance;
	public TCPServer Instance
	{
		get
		{
			if(m_Instance == null)
			{
				m_Instance = new TCPServer();
			}
			return m_Instance;
		}
	}

	public void Connect(string remoteIP,int port,Action actionSuccess,Action actionFail)
	{
		
	}

	public void Disconnect()
	{
		
	}

	public void Send(int msgID,byte[] data)
	{
		
	}

	public void Listen(int msgID,Action<int,byte[]>callBack)
	{
		
	}

}
