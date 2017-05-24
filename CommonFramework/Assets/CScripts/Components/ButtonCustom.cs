using UnityEngine;
using UnityEngine.UI;
using System.Collections;
using System;
using LuaInterface;

public class ButtonCustom : Button 
{
	private LuaTable tableCache;
	private Action<LuaTable,GameObject> actionClick;
	public override void OnPointerClick (UnityEngine.EventSystems.PointerEventData eventData)
	{
		base.OnPointerClick (eventData);
		if(actionClick != null)
		{
			actionClick (tableCache,eventData.selectedObject);
		}
	}

	public void SetClickAction(LuaTable table,Action<LuaTable,GameObject> action)
	{
		tableCache = table;
		actionClick = action;
	}

}
