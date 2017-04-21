using UnityEngine;
using System.Collections;
using LuaInterface;

public class LuaComponent : MonoBehaviour
{
    public LuaTable table;
    public string luaTableName;
    public static LuaTable Add(GameObject go, LuaTable tableClass)
    {
        LuaFunction fun = tableClass.GetLuaFunction("New");
        if (fun == null)
            return null;
        object[] rets = fun.Call(tableClass);
        if (rets.Length != 1)
            return null;
        LuaComponent cmp = go.AddComponent<LuaComponent>();
        cmp.table = (LuaTable)rets[0];
        cmp.CallAwake(cmp);
        cmp.CallOnEnable();
        string name = tableClass.GetStringField("name");
        cmp.luaTableName = name;
        return cmp.table;
    }
    public static LuaTable Get(GameObject go, LuaTable table)
    {
        LuaComponent[] cmps = go.GetComponents<LuaComponent>();
        string mat1 = table.ToString();
        for (int i = 0; i < cmps.Length; i++)
        {
            string mat2 = cmps[i].table.GetMetaTable().ToString();
            if(mat1.Equals(mat2))
            {
                return cmps[i].table;
            }
        }
        return null;
    }
    public static bool Destroy(GameObject go, LuaTable table)
    {
        LuaComponent[] cmps = go.GetComponents<LuaComponent>();
        string mat1 = table.ToString();
        for (int i = 0; i < cmps.Length; i++)
        {
            string mat2 = cmps[i].table.ToString();
            if (mat1.Equals(mat2))
            {
                GameObject.Destroy(cmps[i]);
                return true;
            }
        }
        return false;
    }
    void CallAwake(MonoBehaviour mono)
    {
        if(table != null)
        {
            LuaFunction fun = table.GetLuaFunction("Awake");
            if (fun != null)
            {
                fun.Call(table, mono);
            }
        }
    }
    void Start()
    {
        if(table != null)
        {
            LuaFunction fun = table.GetLuaFunction("Start");
            if (fun != null)
            {
                fun.Call(table);
            }
        }        
    }
    void OnTriggerEnter()
    {
        if(table != null)
        {
            LuaFunction fun = table.GetLuaFunction("OnTriggerEnter");
            if (fun != null)
            {
                fun.Call(table);
            }
        }
    }
    void OnTriggerExit()
    {
        if(table != null)
        {
            LuaFunction fun = table.GetLuaFunction("OnTriggerExit");
            if (fun != null)
            {
                fun.Call(table);
            }
        }
        
    }
    void OnEnable()
    {
        CallOnEnable();
    }
    void CallOnEnable()
    {
        if (table != null)
        {
            LuaFunction fun = table.GetLuaFunction("OnEnable");
            if (fun != null)
            {
                fun.Call(table);
            }
        }
    }
    void OnDisable()
    {
        if(table != null)
        {
            LuaFunction fun = table.GetLuaFunction("OnDisable");
            if (fun != null)
            {
                fun.Call(table);
            }
        }
    }
    void OnDestroy()
    {
        if(table != null)
        {
            LuaFunction fun = table.GetLuaFunction("OnDestroy");
            if (fun != null)
            {
                fun.Call(table);
            }
            table.Dispose();
            table = null;
        }
        
    }

}
