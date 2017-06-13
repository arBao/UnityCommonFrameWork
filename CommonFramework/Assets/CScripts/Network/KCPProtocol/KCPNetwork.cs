using UnityEngine;
using System.Text;
using System.Net;
using System.Net.Sockets;
using LuaInterface;

public class KCPNetwork
{
	private IPEndPoint m_remoteEndPoint;
	private KCPSocket m_kcpSocket;
	private LuaFunction m_luaFunctionRecvAny;
	private LuaFunction m_luaFunctionRecv;
	public void Init(string name, uint id,string remoteIP,int localPort, int remotePort)
	{
		IPAddress ip = IPAddress.Parse(remoteIP);
		m_remoteEndPoint = new IPEndPoint(ip, remotePort);
		m_kcpSocket = new KCPSocket(localPort, id, AddressFamily.InterNetwork);
		m_kcpSocket.AddReceiveListener(m_remoteEndPoint, OnReceive);
		m_kcpSocket.AddReceiveListener(KCPSocket.IPEP_Any,OnReceiveAny);
	}

	public void SetReceiveAny(LuaFunction luafunction)
	{
		m_luaFunctionRecvAny = luafunction;
	}

	public void SetReceive(LuaFunction luafunction)
	{
		m_luaFunctionRecv = luafunction;
	}

	private void OnReceiveAny(byte[] buffer, int size, IPEndPoint remotePoint)
	{
		//string str = Encoding.UTF8.GetString(buffer, 0, size);
		Debug.LogError("OnReceiveAny() buffer.Length  " + buffer.Length + "  size: " + size);
		Loom.QueueOnMainThread(() => {
			if (m_luaFunctionRecvAny != null)
			{
				ByteBuffer bytebuffer = new ByteBuffer();
				bytebuffer.WriteBytesWithoutLength(buffer);
				m_luaFunctionRecvAny.BeginPCall();
				m_luaFunctionRecvAny.Push(bytebuffer);
				m_luaFunctionRecvAny.PCall();
				m_luaFunctionRecvAny.EndPCall();
			} });

	}

	private void OnReceive(byte[] buffer, int size, IPEndPoint remotePoint)
	{
		//string str = Encoding.UTF8.GetString(buffer, 0, size);
		Debug.LogError("OnReceive() buffer.Length  " + buffer.Length + " size: " + size);
		Loom.QueueOnMainThread(() => { 
			if (m_luaFunctionRecv != null)
			{
				ByteBuffer bytebuffer = new ByteBuffer();
				bytebuffer.WriteBytesWithoutLength(buffer);

				m_luaFunctionRecv.BeginPCall();
				m_luaFunctionRecv.Push(bytebuffer);
				m_luaFunctionRecv.PCall();
				m_luaFunctionRecv.EndPCall();
			}
		});

	}

	public void Update()
	{
		if(m_kcpSocket != null)
			m_kcpSocket.Update();
	}

	public void Send(byte[] data)
	{
		Debug.LogError("Send data.Length  " + data.Length);
		m_kcpSocket.SendTo(data, data.Length, m_remoteEndPoint);
	}
}
