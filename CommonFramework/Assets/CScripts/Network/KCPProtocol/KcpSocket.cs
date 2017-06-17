//using System;
//using System.Collections.Generic;
//using System.Net;
//using System.Net.Sockets;
//using System.Text;
//using System.Threading;
//using UnityEngine;


//public class KCPSocket
//{
//	#region 工具函数
//	public static IPEndPoint IPEP_Any = new IPEndPoint(IPAddress.Any, 0);
//	public static IPEndPoint IPEP_IPv6Any = new IPEndPoint(IPAddress.IPv6Any, 0);
//	public static IPEndPoint GetIPEndPointAny(AddressFamily family, int port)
//	{
//		if (family == AddressFamily.InterNetwork)
//		{
//			if (port == 0)
//			{
//				return IPEP_Any;
//			}

//			return new IPEndPoint(IPAddress.Any, port);
//		}
//		else if (family == AddressFamily.InterNetworkV6)
//		{
//			if (port == 0)
//			{
//				return IPEP_IPv6Any;
//			}

//			return new IPEndPoint(IPAddress.IPv6Any, port);
//		}
//		return null;
//	}


//	private static readonly DateTime UTCTimeBegin = new DateTime(1970, 1, 1);

//	public static UInt32 GetClockMS()
//	{
//		return (UInt32)(Convert.ToInt64(DateTime.UtcNow.Subtract(UTCTimeBegin).TotalMilliseconds) & 0xffffffff);
//	}

//	public delegate void KCPReceiveListener(byte[] buff, int size, IPEndPoint remotePoint);

//	#endregion


//	public string LOG_TAG = "KCPSocket";

//	private bool m_IsRunning = false;
//	//private Socket m_SystemSocket;
//	private UdpClient m_udpClient;
//	private IPEndPoint m_LocalEndPoint;
//	private AddressFamily m_AddrFamily;
//	private Thread m_ThreadRecv;
//	private byte[] m_RecvBufferTemp = new byte[4096];

//	//KCP参数
//	private List<KCPProxy> m_ListKcp;
//	private uint m_KcpKey = 0;
//	private KCPReceiveListener m_AnyListener;
//	private KCPReceiveListener m_RemoteListener;

//	private EndPoint m_remotePoint;

//	//=================================================================================
//	#region 构造和析构

//	public KCPSocket(string remoteIP,int bindPort, uint kcpKey, AddressFamily family = AddressFamily.InterNetwork)
//	{
//		m_AddrFamily = family;
//		m_KcpKey = kcpKey;
//		m_ListKcp = new List<KCPProxy>();

//		//IPEndPoint ipep = GetIPEndPointAny(m_AddrFamily, bindPort);
//		IPEndPoint ipep = new IPEndPoint(IPAddress.Parse(remoteIP),bindPort);
//		m_udpClient = new UdpClient(ipep);
//		m_udpClient.Connect(ipep);

//		//m_SystemSocket = new Socket(m_AddrFamily, SocketType.Dgram, ProtocolType.Udp);
//		//IPEndPoint ipep = GetIPEndPointAny(m_AddrFamily, bindPort);
//		//m_SystemSocket.Bind(ipep);

//		//bindPort = (m_SystemSocket.LocalEndPoint as IPEndPoint).Port;
//		//LOG_TAG = "KCPSocket[" + bindPort + "-" + kcpKey + "]";

//		m_remotePoint = new IPEndPoint(IPAddress.Any, 0);
//		m_udpClient.BeginReceive(new AsyncCallback(ReceiveResult), m_udpClient);
//		m_IsRunning = true;

//		//m_ThreadRecv = new Thread(Thread_Recv) { IsBackground = true };
//		//m_ThreadRecv.Start();




//#if UNITY_EDITOR_WIN
//            uint IOC_IN = 0x80000000;
//            uint IOC_VENDOR = 0x18000000;
//            uint SIO_UDP_CONNRESET = IOC_IN | IOC_VENDOR | 12;
//            m_SystemSocket.IOControl((int)SIO_UDP_CONNRESET, new byte[] { Convert.ToByte(false) }, null);
//#endif


//#if UNITY_EDITOR
//		UnityEditor.EditorApplication.playmodeStateChanged -= OnEditorPlayModeChanged;
//		UnityEditor.EditorApplication.playmodeStateChanged += OnEditorPlayModeChanged;
//#endif
//	}

//	private void ReceiveResult(IAsyncResult result)
//	{
//		if(result.IsCompleted)
//		{
//			byte[] data = m_udpClient.Receive(m_remotePoint):
//			int cnt = m_SystemSocket.ReceiveFrom(m_RecvBufferTemp, m_RecvBufferTemp.Length,
//			SocketFlags.None, ref m_remotePoint);

//			Debug.LogError("正常接收  cnt " + cnt + "  remotePoint  " + (m_remotePoint as IPEndPoint).ToString());
//			if (cnt > 0)
//			{
//				KCPProxy proxy = GetKcp((IPEndPoint)m_remotePoint);
//				if (proxy != null)
//				{
//					proxy.DoReceiveInThread(m_RecvBufferTemp, cnt);
//				}
//			}
//		}
//	}


//#if UNITY_EDITOR
//	private void OnEditorPlayModeChanged()
//	{
//		if (Application.isPlaying == false)
//		{
//			Debug.Log("OnEditorPlayModeChanged()");
//			UnityEditor.EditorApplication.playmodeStateChanged -= OnEditorPlayModeChanged;
//			Dispose();
//		}
//	}
//#endif

//	public void Dispose()
//	{
//		Debug.LogError("----------Dispose");
//		m_IsRunning = false;
//		m_AnyListener = null;

//		if (m_ThreadRecv != null)
//		{
//			m_ThreadRecv.Interrupt();
//			m_ThreadRecv = null;
//		}

//		int cnt = m_ListKcp.Count;
//		for (int i = 0; i < cnt; i++)
//		{
//			m_ListKcp[i].Dispose();
//		}
//		m_ListKcp.Clear();

//		if(m_udpClient != null)
//		{
//			m_udpClient.Close();
//		}

//		//if (m_SystemSocket != null)
//		//{
//		//	m_SystemSocket.Close();
//		//	m_SystemSocket = null;
//		//}
//	}


//	//public int LocalPort
//	//{
//	//	get { return (m_SystemSocket.LocalEndPoint as IPEndPoint).Port; }
//	//}

//	public string LocalIP
//	{
//		get { return UnityEngine.Network.player.ipAddress; }
//	}

//	//public IPEndPoint LocalEndPoint
//	//{
//	//	get
//	//	{
//	//		if (m_LocalEndPoint == null ||
//	//			m_LocalEndPoint.Address.ToString() != UnityEngine.Network.player.ipAddress)
//	//		{
//	//			IPAddress ip = IPAddress.Parse(LocalIP);
//	//			m_LocalEndPoint = new IPEndPoint(ip, LocalPort);
//	//		}

//	//		return m_LocalEndPoint;
//	//	}
//	//}

//	//public Socket SystemSocket { get { return m_SystemSocket; } }

//	#endregion

//	//=================================================================================

//	//public bool EnableBroadcast
//	//{
//	//	get { return m_SystemSocket.EnableBroadcast; }
//	//	set { m_SystemSocket.EnableBroadcast = value; }
//	//}

//	//=================================================================================
//	#region 管理KCP

//	private KCPProxy GetKcp(IPEndPoint ipep)
//	{
//		if (ipep == null || ipep.Port == 0 ||
//			ipep.Address.Equals(IPAddress.Any) ||
//			ipep.Address.Equals(IPAddress.IPv6Any))
//		{
//			return null;
//		}

//		KCPProxy proxy;
//		int cnt = m_ListKcp.Count;
//		for (int i = 0; i < cnt; i++)
//		{
//			proxy = m_ListKcp[i];
//			if (proxy.RemotePoint.Equals(ipep))
//			{
//				return proxy;
//			}
//		}

//		proxy = new KCPProxy(m_KcpKey, ipep, m_udpClient);
//		proxy.AddReceiveListener(OnReceive);
//		m_ListKcp.Add(proxy);
//		return proxy;
//	}

//	#endregion

//	//=================================================================================
//	#region 发送逻辑
//	private void SendResult(IAsyncResult result)
//	{

//	}

//	public bool SendTo(byte[] buffer, int size, IPEndPoint remotePoint)
//	{
//		//Debug.LogError("IPAddress.Broadcast  " + IPAddress.Broadcast);
//		if (remotePoint.Address == IPAddress.Broadcast)
//		{

//			m_udpClient.BeginSend(buffer, size, new AsyncCallback(SendResult), null);
//			return true;
//		}
//		else
//		{
//			KCPProxy proxy = GetKcp(remotePoint);
//			if (proxy != null)
//			{
//				return proxy.DoSend(buffer, size);
//			}
//		}

//		return false;
//	}

//	public bool SendTo(string message, IPEndPoint remotePoint)
//	{
//		byte[] buffer = Encoding.UTF8.GetBytes(message);
//		Debug.LogError("SendTo buffer.Length  " + buffer.Length);
//		return SendTo(buffer, buffer.Length, remotePoint);
//	}

//	#endregion


//	//=================================================================================
//	#region 主线程驱动

//	public void Update()
//	{
//		if (m_IsRunning)
//		{
//			//获取时钟
//			uint current = GetClockMS();

//			int cnt = m_ListKcp.Count;
//			for (int i = 0; i < cnt; i++)
//			{
//				KCPProxy proxy = m_ListKcp[i];
//				proxy.Update(current);
//			}
//		}
//	}

//	#endregion

//	//=================================================================================
//	#region 接收逻辑

//	public void AddReceiveListener(IPEndPoint remotePoint, KCPReceiveListener listener)
//	{
//		KCPProxy proxy = GetKcp(remotePoint);
//		if (proxy != null)
//		{
//			proxy.AddReceiveListener(listener);
//		}
//		else
//		{
//			m_AnyListener += listener;
//		}
//	}

//	public void RemoveReceiveListener(IPEndPoint remotePoint, KCPReceiveListener listener)
//	{
//		KCPProxy proxy = GetKcp(remotePoint);
//		if (proxy != null)
//		{
//			proxy.RemoveReceiveListener(listener);
//		}
//		else
//		{
//			m_AnyListener -= listener;
//		}
//	}

//	//public void AddReceiveListener(KCPReceiveListener listener)
//	//{
//	//    m_AnyListener += listener;
//	//}

//	//public void RemoveReceiveListener(KCPReceiveListener listener)
//	//{
//	//    m_AnyListener -= listener;
//	//}

//	//接收回调
//	private void OnReceive(byte[] buffer, int size, IPEndPoint remotePoint)
//	{
//		if (m_AnyListener != null)
//		{
//			m_AnyListener(buffer, size, remotePoint);
//		}
//	}

//	#endregion

//	//=================================================================================
//	#region 接收线程

//	private void Thread_Recv()
//	{
//		Debug.Log("Thread_Recv() Begin ......");

//		while (m_IsRunning)
//		{
//			try
//			{
//				DoReceive();
//			}
//			catch (Exception e)
//			{
//				Debug.LogError("Thread_Recv() " + e.Message + "\n" + e.StackTrace);
//				Thread.Sleep(10);
//			}
//		}

//		//Debug.Log("Thread_Recv() End!");
//	}
//	private int count;
//	private void DoReceive()
//	{
//		try
//		{

//			int cnt = m_SystemSocket.ReceiveFrom(m_RecvBufferTemp, m_RecvBufferTemp.Length,
//			SocketFlags.None, ref m_remotePoint);

//			Debug.LogError("正常接收  cnt " + cnt + "  remotePoint  " + (m_remotePoint as IPEndPoint).ToString());
//			if (cnt > 0)
//			{
//				KCPProxy proxy = GetKcp((IPEndPoint)m_remotePoint);
//				if (proxy != null)
//				{
//					proxy.DoReceiveInThread(m_RecvBufferTemp, cnt);
//				}
//			}
//		}
//		catch(Exception e)
//		{
//			Debug.LogError("ReceiveFrom Exception : " + e.Message);
//		}
//	}

//	#endregion
//}




//class KCPProxy
//{

//	private KCP m_Kcp;
//	private bool m_NeedKcpUpdateFlag = false;
//	private uint m_NextKcpUpdateTime = 0;
//	private SwitchQueue<byte[]> m_RecvQueue = new SwitchQueue<byte[]>(128);

//	private IPEndPoint m_RemotePoint;
//	private UdpClient m_Socket;
//	private KCPSocket.KCPReceiveListener m_Listener;

//	public IPEndPoint RemotePoint { get { return m_RemotePoint; } }



//	public KCPProxy(uint key, IPEndPoint remotePoint, UdpClient socket)
//	{
//		m_Socket = socket;
//		m_RemotePoint = remotePoint;

//		m_Kcp = new KCP(key, HandleKcpSend);
//		m_Kcp.NoDelay(1, 10, 2, 1);
//		m_Kcp.WndSize(128, 128);
//		m_Kcp.SetMtu(512);
//	}

//	public void Dispose()
//	{
//		m_Socket = null;

//		if (m_Kcp != null)
//		{
//			m_Kcp.Dispose();
//			m_Kcp = null;
//		}

//		m_Listener = null;
//	}

//	//---------------------------------------------
//	private void HandleKcpSend(byte[] buff, int size)
//	{
//		if (size == 0)
//			return;
//		if (m_Socket != null)
//		{
//			Debug.LogError("HandleKcpSend buffer.Length  " + buff.Length + " send size " + size);
//			//m_Socket.SendTo(buff, 0, size, SocketFlags.None, m_RemotePoint);
//			//m_Socket.BeginSendTo(buff, 0, size, SocketFlags.None, m_RemotePoint, null, null);
//			m_Socket.BeginSend(buff, size, new AsyncCallback(SendResult), null);
//		}
//	}

//	private void SendResult(IAsyncResult result)
//	{
//		//Debug.LogError()
//	}

//	public bool DoSend(byte[] buff, int size)
//	{
//		m_NeedKcpUpdateFlag = true;
//		return m_Kcp.Send(buff, size) >= 0;
//	}

//	//---------------------------------------------

//	public void AddReceiveListener(KCPSocket.KCPReceiveListener listener)
//	{
//		m_Listener += listener;
//	}

//	public void RemoveReceiveListener(KCPSocket.KCPReceiveListener listener)
//	{
//		m_Listener -= listener;
//	}



//	public void DoReceiveInThread(byte[] buffer, int size)
//	{
//		byte[] dst = new byte[size];
//		Buffer.BlockCopy(buffer, 0, dst, 0, size);
//		m_RecvQueue.Push(dst);
//	}

//	private void HandleRecvQueue()
//	{
//		m_RecvQueue.Switch();
//		while (!m_RecvQueue.Empty())
//		{
//			var recvBufferRaw = m_RecvQueue.Pop();
//			int ret = m_Kcp.Input(recvBufferRaw);

//			//收到的不是一个正确的KCP包
//			if (ret < 0)
//			{
//				if (m_Listener != null)
//				{
//					m_Listener(recvBufferRaw, recvBufferRaw.Length, m_RemotePoint);
//				}
//				return;
//			}

//			m_NeedKcpUpdateFlag = true;

//			for (int size = m_Kcp.PeekSize(); size > 0; size = m_Kcp.PeekSize())
//			{
//				var recvBuffer = new byte[size];
//				int revcRet = m_Kcp.Recv(recvBuffer);
//				Debug.LogError("revcRet  " + revcRet);
//				if (revcRet > 0)
//				{
//					if (m_Listener != null)
//					{
//						m_Listener(recvBuffer, size, m_RemotePoint);
//					}
//				}
//			}
//		}
//	}

//	//---------------------------------------------
//	public void Update(uint currentTimeMS)
//	{
//		HandleRecvQueue();

//		if (m_NeedKcpUpdateFlag || currentTimeMS >= m_NextKcpUpdateTime)
//		{
//			m_Kcp.Update(currentTimeMS);
//			m_NextKcpUpdateTime = m_Kcp.Check(currentTimeMS);
//			m_NeedKcpUpdateFlag = false;
//		}
//	}

//	//---------------------------------------------

//}
//using System;
//using System.Net;
//using System.Net.Sockets;

//public class UDPState
//{
//	public UdpClient udpClient;
//	public IPEndPoint remoteEndPoint;
//}

//public class KCPSocket
//{
//	private UdpClient m_udpClient;
//	private KCP m_kcp;
//	private SwitchQueue<byte[]> m_RecvQueue = new SwitchQueue<byte[]>(128);
//	private bool m_NeedUpdateFlag = false;
//	private static readonly DateTime utc_time = new DateTime(1970, 1, 1);
//	private Action<byte[]> m_actionReceive;
//	private UInt32 m_NextUpdateTime;

//	private void UDPSendResult(IAsyncResult result)
//	{
//		if(result.IsCompleted)
//		{
//			//UnityEngine.Debug.LogError("UDPSendResult  ");
//		}
//	}

//	private void HandleUDPSend(byte[] data,int size)
//	{
//		UnityEngine.Debug.LogError("HandleUDPSend  data.Length  " + size);
//		m_udpClient.BeginSend(data, size, new AsyncCallback(UDPSendResult), null);
//	}

//	private void UDPReceiveCallback(IAsyncResult result)
//	{
//		UDPState state = (UDPState)result.AsyncState;
//		UdpClient udpClient = state.udpClient;
//		IPEndPoint endPoint = state.remoteEndPoint;
//		byte[] receiveData = udpClient.Receive(ref endPoint);
//		UnityEngine.Debug.LogError("receiveData  " + receiveData.Length);
//		if (receiveData != null)
//		{
//			m_RecvQueue.Push(receiveData);
//		}
//		if (m_udpClient != null)
//		{
//			m_udpClient.BeginReceive(UDPReceiveCallback, state);
//		}
//		if(result.IsCompleted)
//		{

//		}
//	}

//	public void Init(uint kcpid, string remoteIP, int localPort, int remotePort,Action<byte[]> actionReceive)
//	{
//		IPEndPoint ipep = new IPEndPoint(IPAddress.Parse(remoteIP), remotePort);
//		m_udpClient = new UdpClient(localPort);
//		m_udpClient.Connect(ipep);

//		m_kcp = new KCP(kcpid,HandleUDPSend);
//		m_kcp.NoDelay(1, 10, 2, 1);
//		m_kcp.WndSize(128, 128);
//		m_kcp.SetMtu(512);

//		UDPState state = new UDPState();
//		state.udpClient = m_udpClient;
//		state.remoteEndPoint = ipep;

//		m_udpClient.BeginReceive(UDPReceiveCallback,state);
//	}

//	public void Send(byte[] data)
//	{
//		UnityEngine.Debug.LogError("kcpsocket send  " + data.Length);
//		m_kcp.Send(data, data.Length);
//		m_NeedUpdateFlag = true;
//	}

//	private void ProcessRecvQueue()
//	{
//		m_RecvQueue.Switch();
//		while(!m_RecvQueue.Empty())
//		{
//			var buf = m_RecvQueue.Pop();
//			m_kcp.Input(buf);
//			m_NeedUpdateFlag = true;
//			for (int size = m_kcp.PeekSize(); size > 0;size = m_kcp.PeekSize())
//			{
//				byte[] data = new byte[size];
//				if(m_kcp.Recv(data) > 0 && m_actionReceive!= null)
//				{
//					m_actionReceive(data);
//				}
//			}
//		}
//	}

//	public void Update()
//	{
//		UInt32 current = Iclock();
//		ProcessRecvQueue();
//		if(m_NeedUpdateFlag || current >= m_NextUpdateTime)
//		{
//			m_kcp.Update(current);
//			m_NextUpdateTime = m_kcp.Check(current);
//			m_NeedUpdateFlag = false;
//		}
//	}

//	private static UInt32 Iclock()
//	{
//		return (UInt32)(Convert.ToInt64(DateTime.UtcNow.Subtract(utc_time).TotalMilliseconds) & 0xffffffff);
//	}

//}
using UnityEngine;
using System;
using System.Net;
using System.Net.Sockets;
using System.Threading;

public class UDPState
{
	public UdpClient udpClient;
	public IPEndPoint remoteEndPoint;
}

public class KCPSocket
{
	private Socket m_udpSocket;
	private KCP m_kcp;
	private SwitchQueue<byte[]> m_RecvQueue = new SwitchQueue<byte[]>(128);
	private bool m_NeedUpdateFlag = false;
	private static readonly DateTime utc_time = new DateTime(1970, 1, 1);
	private Action<byte[]> m_actionReceive;
	private UInt32 m_NextUpdateTime;
	private IPEndPoint m_RemoteEndPoint;
	private bool m_isRunning = false;
	private byte[] bufferRecv = new byte[2048];

	private void UDPSendResult(IAsyncResult result)
	{
		if (result.IsCompleted)
		{
			//UnityEngine.Debug.LogError("UDPSendResult  ");
		}
	}

	private void HandleUDPSend(byte[] data, int size)
	{
		UnityEngine.Debug.LogError("HandleUDPSend  data.Length  " + size);
		//m_udpClient.BeginSend(data, size, new AsyncCallback(UDPSendResult), null);
		m_udpSocket.SendTo(data, 0, size, SocketFlags.None, m_RemoteEndPoint);
	}

	//private void UDPReceiveCallback(IAsyncResult result)
	//{
	//	UDPState state = (UDPState)result.AsyncState;
	//	UdpClient udpClient = state.udpClient;
	//	IPEndPoint endPoint = state.remoteEndPoint;
	//	byte[] receiveData = udpClient.Receive(ref endPoint);
	//	UnityEngine.Debug.LogError("receiveData  " + receiveData.Length);
	//	if (receiveData != null)
	//	{
	//		m_RecvQueue.Push(receiveData);
	//	}
	//	if (m_udpClient != null)
	//	{
	//		m_udpClient.BeginReceive(UDPReceiveCallback, state);
	//	}
	//	if (result.IsCompleted)
	//	{

	//	}
	//}

	private void ThreadRecv()
	{
		while(m_isRunning)
		{
			EndPoint remotePoint = new IPEndPoint(IPAddress.Any, 0);
			int size = m_udpSocket.ReceiveFrom(bufferRecv, bufferRecv.Length,
				SocketFlags.None, ref remotePoint);
			if (size >= 0)
			{
				byte[] dst = new byte[size];
				Buffer.BlockCopy(bufferRecv, 0, dst, 0, size);
				m_RecvQueue.Push(dst);
			}
		}
	}

	public void Init(uint kcpid, string remoteIP, int localPort, int remotePort, Action<byte[]> actionReceive)
	{
		m_isRunning = true;

		m_RemoteEndPoint = new IPEndPoint(IPAddress.Parse(remoteIP), remotePort);
		m_udpSocket = new Socket(AddressFamily.InterNetwork,SocketType.Dgram,ProtocolType.Udp);
		IPEndPoint endPointBind = new IPEndPoint(IPAddress.Any, localPort);
		m_udpSocket.Bind(endPointBind);

		Thread thread = new Thread(ThreadRecv);
		thread.IsBackground = true;
		thread.Start();

		//m_udpClient = new UdpClient(localPort);
		//m_udpClient.Connect(ipep);

		m_kcp = new KCP(kcpid, HandleUDPSend);
		m_kcp.NoDelay(1, 10, 2, 1);
		m_kcp.WndSize(128, 128);
		m_kcp.SetMtu(512);

		//UDPState state = new UDPState();
		//state.udpClient = m_udpClient;
		//state.remoteEndPoint = ipep;

		//m_udpClient.BeginReceive(UDPReceiveCallback, state);
	}

	public void Send(byte[] data)
	{
		UnityEngine.Debug.LogError("kcpsocket send  " + data.Length);
		m_kcp.Send(data, data.Length);
		m_NeedUpdateFlag = true;
	}

	private void ProcessRecvQueue()
	{
		m_RecvQueue.Switch();
		while (!m_RecvQueue.Empty())
		{
			var buf = m_RecvQueue.Pop();
			m_kcp.Input(buf);
			m_NeedUpdateFlag = true;
			for (int size = m_kcp.PeekSize(); size > 0; size = m_kcp.PeekSize())
			{
				byte[] data = new byte[size];
				if (m_kcp.Recv(data) > 0 && m_actionReceive != null)
				{
					m_actionReceive(data);
				}
			}
		}
	}

	public void Update()
	{
		UInt32 current = Iclock();
		ProcessRecvQueue();
		if (m_NeedUpdateFlag || current >= m_NextUpdateTime)
		{
			m_kcp.Update(current);
			m_NextUpdateTime = m_kcp.Check(current);
			m_NeedUpdateFlag = false;
		}
	}

	private static UInt32 Iclock()
	{
		return (UInt32)(Convert.ToInt64(DateTime.UtcNow.Subtract(utc_time).TotalMilliseconds) & 0xffffffff);
	}

}

