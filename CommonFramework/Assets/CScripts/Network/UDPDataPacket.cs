using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UDPDataPacket
{
	public UDPDataPacket nextUdpPacket;
	public byte[] data;
	public int seq;
}
