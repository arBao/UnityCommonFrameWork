using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;


//最小精度是1帧。。
public class TimerManager : MonoBehaviour 
{
	class TimerEvent
	{
		public int id;
		public float delay;
		public Action<object> actionCallback;
		public object parm;
		public float timeCal;
		public int repeatTimes;
		public int currentTime;
	}

	private int m_id = 0;
	DictionaryNoLeak<int, TimerEvent> m_dicTimers = new DictionaryNoLeak<int, TimerEvent>();
	List<int> listIDWaitToRemove = new List<int>();

	private static TimerManager m_Instance;
	public static TimerManager Instance
	{
		get
		{
			return m_Instance;
		}
	}

	static bool initialized;

	public static void Initialize()
	{
		if (!initialized)
		{

			if (!Application.isPlaying)
				return;
			initialized = true;
			var g = new GameObject("TimerManager");
			DontDestroyOnLoad(g);
			m_Instance = g.AddComponent<TimerManager>();
		}

	}

	/// <summary>
	/// Calls the delay.
	/// </summary>
	/// <param name="actionDelay">Action delay.</param>
	/// <param name="delay">单位是秒</param>
	/// <param name="parm">Parm.</param>
	/// <param name="repeatTimes">重复次数，0为不重复，-1为无限重复,大于0为有限次</param>
	public int CallActionDelay(Action<object> actionDelay, float delay, object parm, int repeatTimes = 0)
	{
		if (delay == 0f)
		{
			delay = 1f;
		}
		if(repeatTimes < -1)
		{
			repeatTimes = -1;
		}
		TimerEvent timerEvent = new TimerEvent();
		timerEvent.id = m_id;

		timerEvent.actionCallback = actionDelay;
		timerEvent.delay = delay;
		timerEvent.parm = parm;
		timerEvent.repeatTimes = repeatTimes;
		m_dicTimers.AddKeyValue(m_id, timerEvent);

		m_id++;

		return timerEvent.id;
	}

	void DicTimersForEach(int id,TimerEvent timerEvent)
	{
		timerEvent.timeCal += Time.deltaTime;
		if(timerEvent.repeatTimes == 0)
		{
			if(timerEvent.timeCal >= timerEvent.delay)
			{
				if (timerEvent.actionCallback != null)
				{
					timerEvent.actionCallback(timerEvent.parm);
				}
				listIDWaitToRemove.Add(timerEvent.id);
			}

		}
		else if(timerEvent.repeatTimes == -1)
		{
			if (timerEvent.timeCal >= (timerEvent.currentTime + 1) * timerEvent.delay)
			{
				timerEvent.currentTime++;
				if (timerEvent.actionCallback != null)
				{
					timerEvent.actionCallback(timerEvent.parm);
				}
			}
		}
		else
		{
			if(timerEvent.timeCal >= (timerEvent.currentTime + 1)* timerEvent.delay)
			{
				timerEvent.currentTime++;
				if (timerEvent.actionCallback != null)
				{
					timerEvent.actionCallback(timerEvent.parm);
				}
				if(timerEvent.currentTime >= timerEvent.repeatTimes)
				{
					listIDWaitToRemove.Add(timerEvent.id);
				}
			}
		}
	}

	public void DeleteTimer(int id)
	{
		if(m_dicTimers.ContainsKey(id))
			m_dicTimers.RemoveKeyValue(id);
	}

	// Update is called once per frame
	void Update () 
	{
		if(m_dicTimers.Count > 0)
		{
			m_dicTimers.Foreach(DicTimersForEach);
			if(listIDWaitToRemove.Count > 0)
			{
				for (int i = 0; i < listIDWaitToRemove.Count; i++)
				{
					m_dicTimers.RemoveKeyValue(listIDWaitToRemove[i]);
				}
			}

		}
	}
}
