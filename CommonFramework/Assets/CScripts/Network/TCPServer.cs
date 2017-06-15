using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using System.Net.Sockets;
using System.Net;
using LuaInterface;

public class TCPState
{
	public TcpClient tcpClient;
}

public class TCPServer 
{
	private TCPServer m_Instance;
	private TcpClient m_tcpClient;

	private bool m_isNoDelay = true;
	private int m_SendTimeout = 10;
	private int m_ReceiveTimeout = 10;
	private LuaFunction m_ConnectSuccessCallback;
	private LuaFunction m_ConnectFailCallback;

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

	public void Clear()
	{
		Disconnect();
	}

	public void SetTcpParms(bool isNodelay,int sendTimeout,int receiveTimeout)
	{
		m_isNoDelay = isNodelay;
		m_SendTimeout = sendTimeout;
		m_ReceiveTimeout = receiveTimeout;

	}

	public void SetConnectCallback(LuaFunction successCallback, LuaFunction failCallback)
	{
		m_ConnectSuccessCallback = successCallback;
		m_ConnectFailCallback = failCallback;
	}

	public void Connect(string remoteIP,int port,Action actionSuccess,Action actionFail)
	{
		if (m_tcpClient == null)
		{
			m_tcpClient = new TcpClient();
			m_tcpClient.NoDelay = m_isNoDelay;
			m_tcpClient.SendTimeout = m_SendTimeout;
			m_tcpClient.ReceiveTimeout = m_ReceiveTimeout;
		}

		TCPState state = new TCPState();
		state.tcpClient = m_tcpClient;

		IPAddress ipAdr = IPAddress.Parse(remoteIP);
		m_tcpClient.BeginConnect(ipAdr, port, new AsyncCallback(ConnectCallback), state);
	}

	public void Disconnect()
	{
		if (m_tcpClient != null)
		{
			if (m_tcpClient.Connected)
			{
				try
				{
					m_tcpClient.Close();
				}
				catch (Exception e)
				{
					Debug.LogError("Disconnect Error Exception " + e.Message);
				}
			}
			m_tcpClient = null;
		}
	}

	public void Send(int msgID,byte[] data)
	{
		
	}

	public void Listen(int msgID,Action<int,byte[]>callBack)
	{
		
	}

	private void ConnectCallback(IAsyncResult result)
	{
		if(result.IsCompleted)
		{
			
		}
	}
}
