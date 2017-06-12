using System;
using System.Net;
using System.Net.Sockets;

public class KCPProxy
{
	private KCP m_KCP;
	private bool m_NeedKCPUpdate = false;
	private uint m_NextKCPUpdateTime = 0;
	private SwitchQueue<byte[]> m_RecvQueue = new SwitchQueue<byte[]>(128);

	private IPEndPoint m_RemotePoint;
	private Socket m_Socket;
	private KCPReceiveListener m_Listener;

	public IPEndPoint RemotePoint { get { return m_RemotePoint; } }

	public KCPProxy(uint key, IPEndPoint remotePoint, Socket socket)
	{
		m_Socket = socket;
		m_RemotePoint = remotePoint;

		m_KCP = new KCP(key, HandleKCPSend);
		m_KCP.NoDelay(1, 10, 2, 1);
		m_KCP.WndSize(128, 128);
		m_KCP.SetMtu(512);
	}

	private void HandleKCPSend(byte[] buff, int size)
	{
		if (m_Socket != null)
			m_Socket.SendTo(buff, 0, size, SocketFlags.None, m_RemotePoint);
	}

	public void Dispose()
	{
		m_Socket = null;
		if (m_KCP != null)
		{
			m_KCP.Dispose();
			m_KCP = null;
		}
		m_Listener = null;
	}

	public bool DoSend(byte[] buff)
	{
		m_NeedKCPUpdate = true;
		return m_KCP.Send(buff) > 0;
	}

	public void AddReceiveListener(KCPReceiveListener listener)
	{
		m_Listener += listener;
	}

	public void RemoveReceiveListener(KCPReceiveListener listener)
	{
		m_Listener -= listener;
	}

	public void DoReceiveInThread(byte[] buff, int size)
	{
		byte[] dst = new byte[size];
		Buffer.BlockCopy(buff, 0, dst, 0, size);
		m_RecvQueue.Push(dst);
	}

	private void HandleRecvQueue()
	{
		m_RecvQueue.Switch();
		while (!m_RecvQueue.Empty())
		{
			var recvBuffRaw = m_RecvQueue.Pop();
			int ret = m_KCP.Input(recvBuffRaw);

			if (ret < 0)
			{
				if (m_Listener != null)
				{
					m_Listener(recvBuffRaw, recvBuffRaw.Length, m_RemotePoint);
				}
				return;
			}

			m_NeedKCPUpdate = true;
			for (int size = m_KCP.PeekSize(); size > 0; size = m_KCP.PeekSize())
			{
				var recvBuffer = new byte[size];
				if (m_KCP.Recv(recvBuffer) > 0)
				{
					if (m_Listener != null)
					{
						m_Listener(recvBuffer, recvBuffer.Length, m_RemotePoint);
					}
				}
			}
		}
	}

	public void Update(uint currentTimeMS)
	{
		HandleRecvQueue();
		if (m_NeedKCPUpdate || currentTimeMS >= m_NextKCPUpdateTime)
		{
			m_KCP.Update(currentTimeMS);
			m_NextKCPUpdateTime = m_KCP.Check(currentTimeMS);
			m_NeedKCPUpdate = false;
		}
	}


}

