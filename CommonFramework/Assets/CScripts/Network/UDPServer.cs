using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Net.Sockets;
using System.Net;
using LuaInterface;

public class UDPServer 
{
	private bool openReceive;
	private Socket udpSendSocket;
	private Socket udpReceiveSocket;
	private IPEndPoint ipendPoint;

	//private LinkUDPPackets sendLink;
	//private LinkUDPPackets receiveLink;

	//private LuaFunction m_luafunction;

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

	//private UDPServer()
	//{
	//	//udpSendSocket = new Socket(AddressFamily.InterNetwork, SocketType.Dgram, ProtocolType.Udp);
	//	//udpReceiveSocket = new Socket(AddressFamily.InterNetwork, SocketType.Dgram, ProtocolType.Udp);
	//	//ipendPoint = new IPEndPoint(IPAddress.Parse("127.0.0.1"), 1110);
	//	//EndPoint localEP = new IPEndPoint(IPAddress.Parse("127.0.0.1"), 1111);
	//	//udpReceiveSocket.Bind(localEP);
	//}

	//public void ReceiveMsg(LuaFunction luafunction)
	//{
	//	m_luafunction = luafunction;
	//	openReceive = true;
	//	State state = new State(udpReceiveSocket);
	//	udpReceiveSocket.BeginReceiveFrom(state.Buffer, 0, state.Buffer.Length, SocketFlags.None, ref state.RemoteEP, new System.AsyncCallback(ReceiveCallback), state);
	//}

	//public void SendUDPMsg(byte[] data,uint id,uint seq)
	//{
	//	Debug.LogError("System.Threading.Thread.CurrentThread.Name  " + System.Threading.Thread.CurrentThread.Name);
	//	Debug.LogError("System.Threading.Thread.CurrentThread.ManagedThreadId  " + System.Threading.Thread.CurrentThread.ManagedThreadId);
	//	Debug.LogError("data.Length " + data.Length);
	//	UDPDataPacket dataPacket = new UDPDataPacket();
	//	dataPacket.seq = seq;
	//	dataPacket.id = id;
	//	dataPacket.PackByteData(data);

	//	sendLink.Insert(dataPacket);
	//	sendLink.PrintLink();
	//	//for (int i = 0; i < data.Length;i++)
	//	//{
	//	//	Debug.LogError("send data" + data[i]);
	//	//}
	//	byte[] sendData = dataPacket.GetData();
	//	State state = new State(udpSendSocket);
	//	udpSendSocket.BeginSendTo(sendData, 0, sendData.Length, SocketFlags.None, ipendPoint, new System.AsyncCallback(SendCallback), state);
	//}

	//private void ReceiveCallback(System.IAsyncResult result)
	//{
	//	//Debug.LogError("ReceiveCallback result.IsCompleted  " + result.IsCompleted);
	//	if (result.IsCompleted)
	//	{
	//		State state = (State)result.AsyncState;

	//		UDPDataPacket dataPacket = new UDPDataPacket();
	//		dataPacket.UnPackDataPacket(state.Buffer);
	//		receiveLink.Insert(dataPacket);
	//		receiveLink.PrintLink();
	//		byte[] data = dataPacket.GetData();
	//		//for (int i = 0; i < data.Length; i++)
	//		//{
	//		//	Debug.LogError(data[i]);
	//		//}

	//		Debug.LogError("c# print System.Threading.Thread.CurrentThread.Name  " + System.Threading.Thread.CurrentThread.Name);
	//		Debug.LogError("c# print System.Threading.Thread.CurrentThread.ManagedThreadId  " + System.Threading.Thread.CurrentThread.ManagedThreadId);

	//		Loom.QueueOnMainThread(() => {
	//			ByteBuffer bytebuffer = new ByteBuffer();
	//			bytebuffer.WriteBytesWithoutLength(data);
	//			m_luafunction.Call(dataPacket.id, bytebuffer); 
	//		});


	//		Debug.LogError("c# print dataPacket.seq  " + dataPacket.seq + " dataPacket.id " + dataPacket.id);
	//		state.Socket.EndReceiveFrom(result, ref state.RemoteEP);
	//		if(openReceive)
	//		{
	//			ReceiveMsg(m_luafunction);
	//		}
	//	}
	//}

	//private void SendCallback(System.IAsyncResult result)
	//{
	//	if(result.IsCompleted)
	//	{
	//		//Debug.LogError("SendCallback Sucess");
	//		State state = (State)result.AsyncState;
	//		state.Socket.EndSendTo(result);
	//	}
	//}

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

	private string m_remoteIP;
	private int m_remotePort;
	private string m_localIP;
	private int m_localPort;

	private LuaFunction m_sendSucessCallback;
	private LuaFunction m_receiveCallback;

	public void Init()
	{
		//sendLink = new LinkUDPPackets();
		//receiveLink = new LinkUDPPackets();
	}

	public void CloseReceiveSocket()
	{
		openReceive = false;
	}

	public void InitUDPServer(string remoteIP,int remotePort,string localIP,int localPort)
	{
		m_remoteIP = remoteIP;
		m_remotePort = remotePort;
		m_localIP = localIP;
		m_localPort = localPort;

		udpSendSocket = new Socket(AddressFamily.InterNetwork, SocketType.Dgram, ProtocolType.Udp);
		udpReceiveSocket = new Socket(AddressFamily.InterNetwork, SocketType.Dgram, ProtocolType.Udp);
		ipendPoint = new IPEndPoint(IPAddress.Parse(remoteIP), remotePort);
		EndPoint localEP = new IPEndPoint(IPAddress.Parse(localIP), localPort);
		udpReceiveSocket.Bind(localEP);

	}

	public void SetSendSucessCallback(LuaFunction sendSucessCallback)
	{
		m_sendSucessCallback = sendSucessCallback;
	}

	public void SetReceive(LuaFunction receiveCallback)
	{
		m_receiveCallback = receiveCallback;
		openReceive = true;
		State state = new State(udpReceiveSocket);
		udpReceiveSocket.BeginReceiveFrom(state.Buffer, 0, state.Buffer.Length, SocketFlags.None, ref state.RemoteEP, new System.AsyncCallback(ReceiveCallback), state);
	}

	public void SendUDPMsg(byte[] data)
	{
		State state = new State(udpSendSocket);
		udpSendSocket.BeginSendTo(data, 0, data.Length, SocketFlags.None, ipendPoint, new System.AsyncCallback(SendCallback), state);
	}

	private void SendCallback(System.IAsyncResult result)
	{
		if (result.IsCompleted)
		{
			State state = (State)result.AsyncState;
			state.Socket.EndSendTo(result);
			Loom.QueueOnMainThread(() =>
			{
				if (m_sendSucessCallback != null)
				{
					m_sendSucessCallback.BeginPCall();
					m_sendSucessCallback.PCall();
					m_sendSucessCallback.EndPCall();
				}
			});
		}
	}

	private void ReceiveCallback(System.IAsyncResult result)
	{

		if (result.IsCompleted)
		{
			State state = (State)result.AsyncState;
			byte[] data = state.Buffer;

			Loom.QueueOnMainThread(() =>
			{
				ByteBuffer bytebuffer = new ByteBuffer();
				bytebuffer.WriteBytesWithoutLength(data);

				m_receiveCallback.BeginPCall();
				m_receiveCallback.Push(bytebuffer);
				m_receiveCallback.PCall();
				m_receiveCallback.EndPCall();
			});

			state.Socket.EndReceiveFrom(result, ref state.RemoteEP);
			if (openReceive)
			{
				SetReceive(m_receiveCallback);
			}
		}
	}
}
