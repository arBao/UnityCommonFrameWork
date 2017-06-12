using System;
using System.Collections.Generic;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Threading;
using UnityEngine;



public delegate void KCPReceiveListener(byte[] buff, int size, IPEndPoint remotePoint);

public class KCPSocket
{
	#region 工具函数
	public static IPEndPoint IPEndPoint_Any = new IPEndPoint(IPAddress.Any, 0);
	public static IPEndPoint IPEndPoint_IPV6_Any = new IPEndPoint(IPAddress.IPv6Any, 0);
	public static IPEndPoint GetIpEndPointAny(AddressFamily family,int port)
	{
		if (family == AddressFamily.InterNetwork)
		{
			if(port == 0)
			{
				return IPEndPoint_Any;
			}

			return new IPEndPoint(IPAddress.Any, port);
		}
		else if (family == AddressFamily.InterNetworkV6)
		{
			if (port == 0)
			{
				return IPEndPoint_IPV6_Any;
			}
			return new IPEndPoint(IPAddress.IPv6Any, port);
		}
		return null;
	}

	private static readonly DateTime UTCTimeBegin = new DateTime(1970, 1, 1);

	public static UInt32 GetClockMS()
	{
		return (UInt32)(Convert.ToInt64(DateTime.UtcNow.Subtract(UTCTimeBegin).TotalMilliseconds) & 0xffffffff);
	}
	#endregion

	public string LogTag = "KcpSocket";
	private bool m_IsRunning = false;
	private Socket m_SystemSocket = null;
	private IPEndPoint m_localEndPoint;
	private AddressFamily m_AddrFamily;
	private Thread m_ThreadRecv;
	private byte[] m_RecvBuff = new byte[4096];

	private List<KCPProxy> m_ListKcp = new List<KCPProxy>();
	private uint m_Kcpkey = 0;
	private KCPReceiveListener m_AnyEPListener;

	public KCPSocket(int bindPort, uint kcpKey, AddressFamily family = AddressFamily.InterNetwork)
	{
		m_AddrFamily = family;
		m_Kcpkey = kcpKey;
		m_ListKcp = new List<KCPProxy>();

		m_SystemSocket = new Socket(m_AddrFamily, SocketType.Dgram, ProtocolType.Udp);
		IPEndPoint endPoint = GetIpEndPointAny(m_AddrFamily, bindPort);
		m_SystemSocket.Bind(endPoint);

		bindPort = (m_SystemSocket.LocalEndPoint as IPEndPoint).Port;
		LogTag = "KcpSocket bindPort " + bindPort + " kcpKey " + kcpKey;

		m_IsRunning = true;
		m_ThreadRecv = new Thread(Thread_Recv) { IsBackground = true };
		m_ThreadRecv.Start();

		#if UNITY_EDITOR_WIN
            uint IOC_IN = 0x80000000;
            uint IOC_VENDOR = 0x18000000;
            uint SIO_UDP_CONNRESET = IOC_IN | IOC_VENDOR | 12;
            m_SystemSocket.IOControl((int)SIO_UDP_CONNRESET, new byte[] { Convert.ToByte(false) }, null);
		#endif


		#if UNITY_EDITOR
            UnityEditor.EditorApplication.playmodeStateChanged -= OnEditorPlayModeChanged;
			UnityEditor.EditorApplication.playmodeStateChanged += OnEditorPlayModeChanged;
		#endif
	}

	#if UNITY_EDITOR
    private void OnEditorPlayModeChanged()
	{
		if (Application.isPlaying == false)
		{
			Debug.Log("OnEditorPlayModeChanged()");
			UnityEditor.EditorApplication.playmodeStateChanged -= OnEditorPlayModeChanged;
			Dispose();
		}
	}
	#endif

	public void Dispose()
	{
		m_IsRunning = false;
		m_AnyEPListener = null;
		if(m_ThreadRecv != null)
		{
			m_ThreadRecv.Interrupt();
			m_ThreadRecv = null;
		}

		int cnt = m_ListKcp.Count;
		for (int i = 0; i < cnt;i++)
		{
			m_ListKcp[i].Dispose();
		}
		m_ListKcp.Clear();

		if(m_SystemSocket != null)
		{
			try
			{
				m_SystemSocket.Shutdown(SocketShutdown.Both);
			}
			catch(Exception e)
			{
				Debug.LogWarning("Close() " + e.Message + e.StackTrace);
			}

			m_SystemSocket.Close();
			m_SystemSocket = null;
		}
	}

	public int LocalPort
	{
		get
		{
			return (m_SystemSocket.LocalEndPoint as IPEndPoint).Port;
		}
	}

	public string LocalIP
	{
		get
		{
			return UnityEngine.Network.player.ipAddress;
		}
	}

	public IPEndPoint LocalEndPoint
	{
		get
		{
			if(m_localEndPoint == null || m_localEndPoint.Address.ToString() != UnityEngine.Network.player.ipAddress)
			{
				IPAddress ip = IPAddress.Parse(LocalIP);
				m_localEndPoint = new IPEndPoint(ip,LocalPort);
			}
			return m_localEndPoint;
		}
	}

	public Socket SystemSocket
	{
		get
		{
			return m_SystemSocket;
		}
	}

	public bool EnableBrocast
	{
		get
		{
			return m_SystemSocket.EnableBroadcast;
		}
		set
		{
			m_SystemSocket.EnableBroadcast = value;
		}
	}

	private KCPProxy GetKCPProxy(IPEndPoint endPoint)
	{
		if(endPoint == null || endPoint.Port == 0 || 
		   endPoint.Address.Equals(IPAddress.Any) || 
		   endPoint.Address.Equals(IPAddress.IPv6Any))
		{
			return null;
		}

		KCPProxy proxy = null;
		int cnt = m_ListKcp.Count;
		for (int i = 0; i < cnt;i++)
		{
			proxy = m_ListKcp[i];
			if(proxy.RemotePoint.Equals(endPoint))
			{
				return proxy;
			}
		}

		proxy = new KCPProxy(m_Kcpkey, endPoint, m_SystemSocket);
		proxy.AddReceiveListener(OnRecvAny);

		m_ListKcp.Add(proxy);
		return proxy;
	}

	#region 发送逻辑

	public bool SendTo(byte[] buffer,int size,IPEndPoint remotePoint)
	{
		if(remotePoint.Address == IPAddress.Broadcast)
		{
			int cnt = m_SystemSocket.SendTo(buffer, size, SocketFlags.None, remotePoint);
			return cnt > 0;
		}
		else
		{
			KCPProxy kcp = GetKCPProxy(remotePoint);
			if(kcp != null)
			{
				return kcp.DoSend(buffer);
			}
		}

		return false;
	}

	public bool SendToString(string msg,IPEndPoint remotePoint)
	{
		byte[] buffer = Encoding.UTF8.GetBytes(msg);
		return SendTo(buffer, buffer.Length, remotePoint);
	}

	#endregion

	#region update

	public void Update()
	{
		if(m_IsRunning)
		{
			uint current = GetClockMS();
			int cnt = m_ListKcp.Count;
			for (int i = 0; i < cnt;i++)
			{
				KCPProxy kcp = m_ListKcp[i];
				kcp.Update(current);
			}
		}
	}

	#endregion

	#region 接收逻辑

	public void AddReveiveListener(IPEndPoint remoteEndpoint,KCPReceiveListener listener)
	{
		KCPProxy kcp = GetKCPProxy(remoteEndpoint);
		if(kcp != null)
		{
			kcp.AddReceiveListener(listener);
		}
		else
		{
			m_AnyEPListener += listener;
		}
	}

	public void RemoveReceiveListener(IPEndPoint remoteEndpoint, KCPReceiveListener listener)
	{
		KCPProxy kcp = GetKCPProxy(remoteEndpoint);
		if (kcp != null)
		{
			kcp.RemoveReceiveListener(listener);
		}
		else
		{
			m_AnyEPListener -= listener;
		}
	}

	public void AddReceiveListener(KCPReceiveListener listener)
	{
		m_AnyEPListener += listener;
	}

	public void RemoveReceiveListener(KCPReceiveListener listener)
	{
		m_AnyEPListener -= listener;
	}

	private void OnRecvAny(byte[] buffer, int size, IPEndPoint remotePoint)
	{
		if (m_AnyEPListener != null)
		{
			m_AnyEPListener(buffer, size, remotePoint);
		}
	}

	#endregion

	#region 线程接收

	private void Thread_Recv()
	{
		Debug.Log("Thread_Recv() Begin ......");
		while (m_IsRunning)
		{
			try
			{
				DoReceive();
			}
			catch (Exception e)
			{
				Debug.LogWarning("Thread_Recv exception :" + e.Message);
			}
		}
		Debug.Log("Thread_Recv() End ......");
	}
	private void DoReceive()
	{
		if (m_SystemSocket.Available <= 0)
		{
			return;
		}
		EndPoint remoteEndPoint = new IPEndPoint(IPAddress.Any, 0);
		int cnt = m_SystemSocket.ReceiveFrom(m_RecvBuff, m_RecvBuff.Length, SocketFlags.None, ref remoteEndPoint);
		if (cnt > 0)
		{
			KCPProxy kcp = GetKCPProxy((IPEndPoint)remoteEndPoint);
			if (kcp != null)
			{
				kcp.DoReceiveInThread(m_RecvBuff, cnt);
			}
		}
	}

 	#endregion


}


