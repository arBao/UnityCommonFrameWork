using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LinkUDPPackets  
{
	private UDPDataPacket head;

	public void Init()
	{
		head = null;

	}

	public void PrintLink()
	{
		UDPDataPacket p = head;
		if(head == null)
		{
			Debug.LogError("empty LinkUDPPackets");
		}
		while(p != null)
		{
			Debug.LogError("p.seq  " + p.seq);
			p = p.nextUdpPacket;
		}

	}

	public void Insert(UDPDataPacket pInsert)
	{
		UDPDataPacket p = head;
		UDPDataPacket lastP = null;
		if(p == null)
		{
			head = pInsert;
			return;
		}

		while(p != null)
		{
			if(p.seq == pInsert.seq)
			{
				return;
			}
			if(pInsert.seq > p.seq)
			{
				p.nextUdpPacket = pInsert;
				return;
			}
			lastP = p;
			p = p.nextUdpPacket;
		}
		lastP.nextUdpPacket = pInsert;
	}
	public UDPDataPacket GetPacketBySeq(int seq)
	{
		UDPDataPacket p = head;
		while(p != null)
		{
			if(p.seq == seq)
			{
				return p;
			}
			p = p.nextUdpPacket;
		}
		return null;
	}

}
