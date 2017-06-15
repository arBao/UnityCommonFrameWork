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

public class TCPSocket 
{
	
	private TcpClient m_tcpClient;

	private bool m_isNoDelay = true;
	private int m_SendTimeout = 10;
	private int m_ReceiveTimeout = 10;
	private int m_connectTimeout = 5;
	private string m_timeoutConnectStr = "连接超时";
	private string m_timeoutConnectFailStr = "网络异常,服务端无响应";

	private Action m_ConnectSuccessCallback;
	private Action<string> m_ConnectFailCallback;
	private int m_connentDelayTimerID = 0;

	private Action m_sendSuccess;
	private Action<string> m_sendFail;

	private const int MAX_READ = 8192;
	private byte[] byteBuffer = new byte[MAX_READ];

	private NetworkStream m_networkStream;

	private static TCPSocket m_Instance;
	public static TCPSocket Instance
	{
		get
		{
			if(m_Instance == null)
			{
				m_Instance = new TCPSocket();
			}
			return m_Instance;
		}
	}

	public void Clear()
	{
		Disconnect();
		m_ConnectSuccessCallback = null;
		m_ConnectFailCallback = null;
		TimerManager.Instance.DeleteTimer(m_connentDelayTimerID);
		m_connentDelayTimerID = 0;
	}

	public void SetTcpParms(bool isNodelay,int sendTimeout,int receiveTimeout,int connectTimeout,
	                        string timeoutConnectStr,string timeoutConnectFailStr)
	{
		m_isNoDelay = isNodelay;
		m_SendTimeout = sendTimeout;
		m_ReceiveTimeout = receiveTimeout;
		m_connectTimeout = connectTimeout;
		m_timeoutConnectStr = timeoutConnectStr;
		m_timeoutConnectFailStr = timeoutConnectFailStr;
	}

	public void Connect(string remoteIP,int port,Action actionSuccess,Action<string> actionFail)
	{
		Clear();

		m_ConnectSuccessCallback = actionSuccess;
		m_ConnectFailCallback = actionFail;
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
		try
		{
			m_tcpClient.BeginConnect(ipAdr, port, new AsyncCallback(ConnectCallback), state);
		}
		catch(Exception e)
		{
			if(m_ConnectFailCallback != null)
				m_ConnectFailCallback(e.Message);
		}

		m_connentDelayTimerID = TimerManager.Instance.CallActionDelay((object data) => {
			if(m_ConnectFailCallback != null)
			{
				m_ConnectFailCallback(m_timeoutConnectStr);
			}
			Clear();
		}, m_connectTimeout, null, 0);
	}

	private void Disconnect()
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
			m_networkStream.Dispose();
			m_networkStream = null;
		}
	}

	public void Send(byte[] data,Action sendSuccess,Action<string> sendFail)
	{
		m_sendSuccess = sendSuccess;
		m_sendFail = sendFail;
		if(m_tcpClient != null && m_tcpClient.Connected && m_networkStream != null)
		{
			try
			{
				m_networkStream.BeginWrite(data,0,data.Length,new AsyncCallback(WriteCallback),null);
			}
			catch(Exception e)
			{
				if (m_sendFail != null)
				{
					m_sendFail(e.Message);
				}
			}
		}
		else
		{
			if(m_sendFail != null)
			{
				m_sendFail("未连接或者连接已断开");
			}
		}
	}

	public void Listen(int msgID,Action<int,byte[]>callBack)
	{
		
	}

	private void WriteCallback(IAsyncResult result)
	{
		Loom.QueueOnMainThread(() => { 
			if (result.IsCompleted)
			{
				if (m_sendSuccess != null)
				{
					m_sendSuccess();
				}
			}
		});
	}

	private void ConnectCallback(IAsyncResult result)
	{
		if(result.IsCompleted)
		{
			Loom.QueueOnMainThread(() => {
				TCPState state = (TCPState)result.AsyncState;
				if(state.tcpClient.Connected)
				{
					m_networkStream = m_tcpClient.GetStream();
					if (m_ConnectSuccessCallback != null)
					{
						m_ConnectSuccessCallback();
					}
				}
				else
				{
					if (m_ConnectFailCallback != null)
					{
						m_ConnectFailCallback(m_timeoutConnectFailStr);
					}
				}
				TimerManager.Instance.DeleteTimer(m_connentDelayTimerID);
				m_connentDelayTimerID = 0;

			});
		}
	}
}
