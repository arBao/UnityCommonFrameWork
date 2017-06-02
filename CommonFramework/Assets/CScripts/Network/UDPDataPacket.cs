using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.IO;

public class UDPDataPacket
{
	public UDPDataPacket nextUdpPacket;
	private byte[] m_data;
	public uint seq;//队列
	public uint id;//协议id

	public void PackByteData(byte[] originData)
	{
		using(MemoryStream ms = new MemoryStream())
		{
			using(BinaryWriter bw = new BinaryWriter(ms))
			{
				bw.Write((byte)id);
				bw.Write((byte)(id >> 8));
				bw.Write((byte)originData.Length);
				bw.Write((byte)(originData.Length >> 8));
				bw.Write(originData);
				m_data = ms.ToArray();
			}
		}
	}

	public void UnPackDataPacket(byte[] data)
	{
		id = (uint)(data[0] | data[1] << 8);
		uint length = (uint)(data[2] | data[3] << 8);
		m_data = new byte[length];
		System.Array.Copy(data, 4, m_data, 0, length);
	}

	public byte[] GetData()
	{
		return m_data;
	}
}
