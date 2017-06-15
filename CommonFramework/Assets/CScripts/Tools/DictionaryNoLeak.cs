using System.Collections.Generic;
public class DictionaryNoLeak<T, U>
{
    private List<T> keys = new List<T>();
    private Dictionary<T, U> dic = new Dictionary<T, U>();
    public int Count
    {
        get
        {
            return keys.Count;
        }
    }
    public void AddKeyValue(T key, U value)
    {
        if (!dic.ContainsKey(key))
        {
            dic.Add(key, value);
            keys.Add(key);
        }
        else
        {
            dic[key] = value;
        }
    }
    public U GetValueByKey(T key)
    {
        if(dic.ContainsKey(key))
        {
            return dic[key];
        }
        UnityEngine.Debug.LogError("DictionaryNoLeak 不存在 key " + key.ToString());
        return default(U);
    }
    public void SetValue(T key, U value)
    {
        if (dic.ContainsKey(key))
        {
            dic[key] = value;
        }
    }
    public void RemoveKeyValue(T key)
    {
        if (dic.ContainsKey(key))
        {
            keys.Remove(key);
            dic.Remove(key);
        }
    }
    public bool ContainsKey(T key)
    {
        return dic.ContainsKey(key);
    }
    /// <summary>
    /// 不能再遍历的时候做增删操作
    /// </summary>
    /// <param name="action"></param>
    public void Foreach(System.Action<T, U> action)
    {
		int count = keys.Count;
        for (int i = 0; i < count; i++)
        {
            T key = keys[i];
            U value = dic[key];
            action(key, value);
        }
    }
    public void Clear()
    {
        keys.Clear();
        dic.Clear();
    }

    public U GetValueByIndex(int index)
    {
        if(index >= keys.Count)
        {
            return default(U);
        }
        return dic[keys[index]];
    }

}
