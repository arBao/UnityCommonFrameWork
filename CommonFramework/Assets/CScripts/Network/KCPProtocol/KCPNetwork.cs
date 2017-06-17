using UnityEngine;
using System.Text;
using System.Net;
using System.Net.Sockets;
public class KCPNetwork
{
	private IPEndPoint m_remoteEndPoint;
	private KCPSocket m_kcpSocket;
	private System.Action<ByteBuffer> m_actionReceive;

	public void SetReceiveAction(System.Action<ByteBuffer> actionReceive)
	{
		m_actionReceive = actionReceive;
	}

	private void ActionReceive(byte[] data)
	{
		ByteBuffer bytebuffer = new ByteBuffer();
		bytebuffer.WriteBytesWithoutLength(data);
		if(m_actionReceive != null)
		{
			m_actionReceive(bytebuffer);
		}
	}

	public void Init(uint kcpid, string remoteIP, int localPort, int remotePort)
	{
		IPAddress ip = IPAddress.Parse(remoteIP);
		m_remoteEndPoint = new IPEndPoint(ip, remotePort);
		m_kcpSocket = new KCPSocket();
		m_kcpSocket.Init(kcpid, remoteIP, localPort, remotePort,ActionReceive);
	}

	public void Send(byte[] data)
	{
		m_kcpSocket.Send(data);
	}

	public void Update()
	{
		m_kcpSocket.Update();
	}

	public void Dispose()
	{
		m_kcpSocket.Dispose();
	}
}
