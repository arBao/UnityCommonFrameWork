using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Net.Sockets;
using System.Net;


public class UDPServer 
{
	private Socket udpSendSocket;
	private Socket udpReceiveSocket;
	private IPEndPoint ipendPoint;

	private static UDPServer m_Instance;
	public static UDPServer Instance
	{
		get
		{
			if (m_Instance == null)
			{
				m_Instance = new UDPServer();
			}
			return m_Instance;
		}
	}

	private UDPServer()
	{
		udpSendSocket = new Socket(AddressFamily.InterNetwork, SocketType.Dgram, ProtocolType.Udp);
		udpReceiveSocket = new Socket(AddressFamily.InterNetwork, SocketType.Dgram, ProtocolType.Udp);
		ipendPoint = new IPEndPoint(IPAddress.Parse("127.0.0.1"), 1110);
		EndPoint localEP = new IPEndPoint(IPAddress.Parse("127.0.0.1"), 1111);
		udpReceiveSocket.Bind(localEP);
	}

	public void ReceiveMsg()
	{
		State state = new State(udpReceiveSocket);
		udpReceiveSocket.BeginReceiveFrom(state.Buffer, 0, state.Buffer.Length, SocketFlags.None, ref state.RemoteEP, new System.AsyncCallback(ReceiveCallback), state);
	}

	public void SendUDPMsg(byte[] data,int seq)
	{
		//UDPDataPacket dataPacket = new UDPDataPacket();
		//dataPacket.seq = seq;
		//dataPacket.data = data;
		for (int i = 0; i < data.Length;i++)
		{
			Debug.LogError(data[i]);
		}
		State state = new State(udpSendSocket);
		udpSendSocket.BeginSendTo(data, 0, data.Length, SocketFlags.None, ipendPoint, new System.AsyncCallback(SendCallback), state);
	}

	private void ReceiveCallback(System.IAsyncResult result)
	{
		Debug.LogError("ReceiveCallback result.IsCompleted  " + result.IsCompleted);
		if (result.IsCompleted)
		{
			State state = (State)result.AsyncState;
			for (int i = 0; i < state.Buffer.Length; i++)
			{
				Debug.LogError(state.Buffer[i]);
			}
			state.Socket.EndReceiveFrom(result, ref state.RemoteEP);
			ReceiveMsg();
		}
	}

	private void SendCallback(System.IAsyncResult result)
	{
		if(result.IsCompleted)
		{
			State state = (State)result.AsyncState;
			state.Socket.EndSendTo(result);
		}
	}

	/// <summary>
	/// 用于异步接收处理的辅助类
	/// </summary>
	class State
	{
		public State(Socket socket)
		{
			this.Buffer = new byte[512];
			this.Socket = socket;
			this.RemoteEP = new IPEndPoint(IPAddress.Any, 0);
		}
		/// <summary>
		/// 获取本机Socket
		/// </summary>
		public Socket Socket { get; private set; }
		/// <summary>
		/// 获取接收缓冲区
		/// </summary>
		public byte[] Buffer { get; private set; }
		/// <summary>
		/// 获取/设置客户端终结点
		/// </summary>
		public EndPoint RemoteEP;
	}

}
