using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Net.Sockets;
using System.Net;


public class UDPServer 
{
	private bool openReceive;
	private Socket udpSendSocket;
	private Socket udpReceiveSocket;
	private IPEndPoint ipendPoint;

	private LinkUDPPackets sendLink;
	private LinkUDPPackets receiveLink;

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
		openReceive = true;
		State state = new State(udpReceiveSocket);
		udpReceiveSocket.BeginReceiveFrom(state.Buffer, 0, state.Buffer.Length, SocketFlags.None, ref state.RemoteEP, new System.AsyncCallback(ReceiveCallback), state);
	}

	public void SendUDPMsg(byte[] data,uint id,uint seq)
	{
		UDPDataPacket dataPacket = new UDPDataPacket();
		dataPacket.seq = seq;
		dataPacket.id = id;
		dataPacket.PackByteData(data);
		sendLink.Insert(dataPacket);
		sendLink.PrintLink();
		//for (int i = 0; i < data.Length;i++)
		//{
		//	Debug.LogError("send data" + data[i]);
		//}
		byte[] sendData = dataPacket.GetData();
		State state = new State(udpSendSocket);
		udpSendSocket.BeginSendTo(sendData, 0, sendData.Length, SocketFlags.None, ipendPoint, new System.AsyncCallback(SendCallback), state);
	}

	private void ReceiveCallback(System.IAsyncResult result)
	{
		//Debug.LogError("ReceiveCallback result.IsCompleted  " + result.IsCompleted);
		if (result.IsCompleted)
		{
			State state = (State)result.AsyncState;

			UDPDataPacket dataPacket = new UDPDataPacket();
			dataPacket.UnPackDataPacket(state.Buffer);
			receiveLink.Insert(dataPacket);
			receiveLink.PrintLink();
			byte[] data = dataPacket.GetData();
			//for (int i = 0; i < data.Length; i++)
			//{
			//	Debug.LogError(data[i]);
			//}
			Debug.LogError("dataPacket.seq  " + dataPacket.seq + " dataPacket.id " + dataPacket.id);
			state.Socket.EndReceiveFrom(result, ref state.RemoteEP);
			if(openReceive)
			{
				ReceiveMsg();
			}
		}
	}

	private void SendCallback(System.IAsyncResult result)
	{
		if(result.IsCompleted)
		{
			//Debug.LogError("SendCallback Sucess");
			State state = (State)result.AsyncState;
			state.Socket.EndSendTo(result);
		}
	}

	public void CloseReceiveSocket()
	{
		openReceive = false;
	}

	public void Init()
	{
		sendLink = new LinkUDPPackets();
		receiveLink = new LinkUDPPackets();
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
