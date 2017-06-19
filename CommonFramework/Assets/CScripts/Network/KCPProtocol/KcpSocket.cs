using UnityEngine;
using System;
using System.Net;
using System.Net.Sockets;
using System.Threading;

public class KCPSocket
{
	private Socket m_udpSocket;
	private KCP m_kcp;
	private SwitchQueue<byte[]> m_RecvQueue = new SwitchQueue<byte[]>(128);
	private bool m_NeedUpdateFlag = false;
	private static readonly DateTime utc_time = new DateTime(1970, 1, 1);
	private Action<ByteBuffer> m_actionReceive;
	private UInt32 m_NextUpdateTime;
	private IPEndPoint m_RemoteEndPoint;
	private bool m_isRunning = false;
	private byte[] m_bufferRecv = new byte[2048];
	private Thread m_threadRecv;


	private void HandleUDPSend(byte[] data, int size)
	{
		UnityEngine.Debug.LogError("HandleUDPSend  data.Length  " + size);
		m_udpSocket.SendTo(data, 0, size, SocketFlags.None, m_RemoteEndPoint);
	}

	private void ThreadRecv()
	{
		while(m_isRunning)
		{
			EndPoint remotePoint = new IPEndPoint(IPAddress.Any, 0);
			int size = m_udpSocket.ReceiveFrom(m_bufferRecv, m_bufferRecv.Length,
				SocketFlags.None, ref remotePoint);
			if (size >= 0)
			{
				byte[] dst = new byte[size];
				Buffer.BlockCopy(m_bufferRecv, 0, dst, 0, size);
				m_RecvQueue.Push(dst);
			}
		}
	}

	public void Init(uint kcpid, string remoteIP, int localPort, int remotePort, Action<ByteBuffer> actionReceive)
	{
		m_actionReceive = actionReceive;

		m_isRunning = true;
		m_RemoteEndPoint = new IPEndPoint(IPAddress.Parse(remoteIP), remotePort);
		m_udpSocket = new Socket(AddressFamily.InterNetwork,SocketType.Dgram,ProtocolType.Udp);
		IPEndPoint endPointBind = new IPEndPoint(IPAddress.Any, localPort);
		m_udpSocket.Bind(endPointBind);

		m_threadRecv = new Thread(ThreadRecv);
		m_threadRecv.IsBackground = true;
		m_threadRecv.Start();

		m_kcp = new KCP(kcpid, HandleUDPSend);
		m_kcp.NoDelay(1, 40, 2, 1);
		m_kcp.WndSize(128, 128);
		m_kcp.SetMtu(512);
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
					ByteBuffer bytebuffer = new ByteBuffer();
					bytebuffer.WriteBytesWithoutLength(data);
					m_actionReceive(bytebuffer);
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

	public void Dispose()
	{
		m_isRunning = false;
		m_kcp.Dispose();
		m_threadRecv.Interrupt();
		m_threadRecv = null;
	}

}

