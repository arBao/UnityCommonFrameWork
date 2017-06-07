﻿using UnityEngine;
using UnityEngine.EventSystems;
using System;
using LuaInterface;

public class UIEventTransfer:MonoBehaviour,IPointerEnterHandler,IPointerExitHandler,IPointerDownHandler,IPointerUpHandler,IPointerClickHandler,
IInitializePotentialDragHandler,IBeginDragHandler,IDragHandler,IEndDragHandler,IDropHandler,IScrollHandler,IUpdateSelectedHandler,
ISelectHandler,IDeselectHandler,IMoveHandler,ISubmitHandler,ICancelHandler
{
	private LuaTable tableCache;
	private Action<LuaTable, PointerEventData> actionOnPointerClick;
	private Action<LuaTable, PointerEventData> actionOnPointerEnter;
	private Action<LuaTable, PointerEventData> actionOnPointerExit;
	private Action<LuaTable, PointerEventData> actionOnPointerDown;
	private Action<LuaTable, PointerEventData> actionOnPointerUp;
	private Action<LuaTable, PointerEventData> actionOnInitializePotentialDrag;
	private Action<LuaTable, PointerEventData> actionOnBeginDrag;
	private Action<LuaTable, PointerEventData> actionOnDrag;
	private Action<LuaTable, PointerEventData> actionOnEndDrag;
	private Action<LuaTable, PointerEventData> actionOnScroll;
	private Action<LuaTable, BaseEventData> actionOnUpdateSelected;
	private Action<LuaTable, BaseEventData> actionOnSelect;
	private Action<LuaTable, BaseEventData> actionOnDeselect;
	private Action<LuaTable, AxisEventData> actionOnMove;
	private Action<LuaTable, BaseEventData> actionOnSubmit;
	private Action<LuaTable, BaseEventData> actionOnCancel;

	public void SetOnPointerClick(LuaTable table, Action<LuaTable, PointerEventData> action)
	{
		tableCache = table;
		actionOnPointerClick = action;
	}

	public void OnPointerClick(PointerEventData eventData)
	{
		if(actionOnPointerClick != null)
		{
			actionOnPointerClick(tableCache, eventData);
		}
	}

	/// ---------------------------------- /// 

	public void SetOnPointerEnter(LuaTable table, Action<LuaTable, PointerEventData> action)
	{
		tableCache = table;
		actionOnPointerEnter = action;
	}

	public void OnPointerEnter(PointerEventData eventData)
	{
		if(actionOnPointerEnter != null)
		{
			actionOnPointerEnter(tableCache, eventData);
		}
	}

	/// ---------------------------------- /// 

	public void SetOnPointerExit(LuaTable table, Action<LuaTable, PointerEventData> action)
	{
		tableCache = table;
		actionOnPointerExit = action;
	}

	public void OnPointerExit(PointerEventData eventData)
	{
		if(actionOnPointerExit != null)
		{
			actionOnPointerExit(tableCache, eventData);
		}
	}

	/// ---------------------------------- /// 

	public void SetOnPointerDown(LuaTable table, Action<LuaTable, PointerEventData> action)
	{
		tableCache = table;
		actionOnPointerDown = action;
	}

	public void OnPointerDown(PointerEventData eventData)
	{
		if(actionOnPointerDown != null)
		{
			actionOnPointerDown(tableCache, eventData);
		}
	}

	/// ---------------------------------- /// 

	public void SetOnPointerUp(LuaTable table, Action<LuaTable, PointerEventData> action)
	{
		tableCache = table;
		actionOnPointerUp = action;
	}

	public void OnPointerUp(PointerEventData eventData)
	{
		if(actionOnPointerUp != null)
		{
			actionOnPointerUp(tableCache, eventData);
		}	
	}

	/// ---------------------------------- /// 

	public void SetactionOnInitializePotentialDrag(LuaTable table, Action<LuaTable, PointerEventData> action)
	{
		tableCache = table;
		actionOnInitializePotentialDrag = action;
	}

	public void OnInitializePotentialDrag(PointerEventData eventData)
	{
		if(actionOnInitializePotentialDrag != null)
		{
			actionOnInitializePotentialDrag(tableCache, eventData);
		}
	}

	/// ---------------------------------- /// 

	public void SetOnBeginDrag(LuaTable table, Action<LuaTable, PointerEventData> action)
	{
		tableCache = table;
		actionOnBeginDrag = action;
	}

	public void OnBeginDrag(PointerEventData eventData)
	{
		if(actionOnBeginDrag != null)
		{
			actionOnBeginDrag(tableCache, eventData);
		}
	}

	/// ---------------------------------- /// 

	public void SetOnDrag(LuaTable table, Action<LuaTable, PointerEventData> action)
	{
		tableCache = table;
		actionOnDrag = action;
	}

	public void OnDrag(PointerEventData eventData)
	{
		if(actionOnDrag != null)
		{
			actionOnDrag(tableCache, eventData);
		}
	}

	/// ---------------------------------- /// 

	public void SetOnEndDrag(LuaTable table, Action<LuaTable, PointerEventData> action)
	{
		tableCache = table;
		actionOnEndDrag = action;
	}

	public void OnEndDrag(PointerEventData eventData)
	{
		if(actionOnEndDrag != null)
		{
			actionOnEndDrag(tableCache, eventData);
		}
	}

	/// ---------------------------------- /// 

	public void SetOnDrop(LuaTable table, Action<LuaTable, PointerEventData> action)
	{
		tableCache = table;
		actionOnDrag = action;
	}

	public void OnDrop(PointerEventData eventData)
	{
		if (actionOnDrag != null)
		{
			actionOnDrag(tableCache, eventData);
		}
	}

	/// ---------------------------------- /// 

	public void SetOnScroll(LuaTable table, Action<LuaTable, PointerEventData> action)
	{
		tableCache = table;
		actionOnScroll = action;
	}

	public void OnScroll(PointerEventData eventData)
	{
		if (actionOnScroll != null)
		{
			actionOnScroll(tableCache, eventData);
		}
	}

	/// ---------------------------------- /// 

	public void SetOnUpdateSelected(LuaTable table, Action<LuaTable, BaseEventData> action)
	{
		tableCache = table;
		actionOnUpdateSelected = action;
	}

	public void OnUpdateSelected(BaseEventData eventData)
	{
		if (actionOnUpdateSelected != null)
		{
			actionOnUpdateSelected(tableCache, eventData);
		}
	}

	/// ---------------------------------- /// 

	public void SetOnSelect(LuaTable table, Action<LuaTable, BaseEventData> action)
	{
		tableCache = table;
		actionOnSelect = action;
	}

	public void OnSelect(BaseEventData eventData)
	{
		if (actionOnSelect != null)
		{
			actionOnSelect(tableCache, eventData);
		}
	}

	/// ---------------------------------- /// 

	public void SetOnDeselect(LuaTable table, Action<LuaTable, BaseEventData> action)
	{
		tableCache = table;
		actionOnDeselect = action;
	}

	public void OnDeselect(BaseEventData eventData)
	{
		if (actionOnDeselect != null)
		{
			actionOnDeselect(tableCache, eventData);
		}
	}

	/// ---------------------------------- /// 

	public void SetOnMove(LuaTable table, Action<LuaTable, AxisEventData> action)
	{
		tableCache = table;
		actionOnMove = action;
	}

	public void OnMove(AxisEventData eventData)
	{
		if (actionOnMove != null)
		{
			actionOnMove(tableCache, eventData);
		}
	}

	/// ---------------------------------- /// 

	public void SetOnSubmit(LuaTable table, Action<LuaTable, BaseEventData> action)
	{
		tableCache = table;
		actionOnSubmit = action;
	}

	public void OnSubmit(BaseEventData eventData)
	{
		if (actionOnSubmit != null)
		{
			actionOnSubmit(tableCache, eventData);
		}
	}

	/// ---------------------------------- /// 

	public void SetOnCancel(LuaTable table, Action<LuaTable, BaseEventData> action)
	{
		tableCache = table;
		actionOnCancel = action;
	}

	public void OnCancel(BaseEventData eventData)
	{
		if (actionOnCancel != null)
		{
			actionOnCancel(tableCache, eventData);
		}
	}

}
