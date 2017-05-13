using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System;
using System.Reflection;
public class LuaReflectionTool
{
    private static LuaReflectionTool m_Instance;
    public static LuaReflectionTool Instance
    {
        get
        {
            if (m_Instance == null)
            {
                m_Instance = new LuaReflectionTool();
            }
            return m_Instance;
        }
    }

    #region method
    private FieldInfo GetField(Type type,string fieldName)
    {
        return type.GetField(fieldName, BindingFlags.Static | BindingFlags.Instance | BindingFlags.NonPublic | BindingFlags.Public);
    }
    private PropertyInfo GetProperty(Type type, string propertyName)
    {
        return type.GetProperty(propertyName, BindingFlags.Static | BindingFlags.Instance | BindingFlags.NonPublic | BindingFlags.Public);
    }
    private MethodInfo GetMethodInfo(Type type, string methodName, int methodIndex)
    {
        MethodInfo[] mis = type.GetMethods(BindingFlags.Static | BindingFlags.Instance | BindingFlags.NonPublic | BindingFlags.Public);
        List<MethodInfo> listMethods = new List<MethodInfo>();
        for (int i = 0; i < mis.Length; i++)
        {
            if (mis[i].Name.Equals(methodName))
            {
                listMethods.Add(mis[i]);
            }
        }
        return listMethods[methodIndex];
    }

    /// <summary>
    /// 调用类的静态方法
    /// </summary>
    /// <param name="className">类名</param>
    /// <param name="methodName">方法名</param>
    /// <param name="listParms">参数数组</param>
    /// <param name="listTypes">参数对应的类型</param>
    /// <returns></returns>
    public object CallStaticMethod(string className, string methodName, object[] listParms, string[] listTypes)
    {
        Type type = GetType(className);
        MethodInfo mi = type.GetMethod(methodName, BindingFlags.Static | BindingFlags.NonPublic | BindingFlags.Public);
        object[] objParms = DealWithTypes(listParms, listTypes);
        return mi.Invoke(null, objParms);
    }
    /// <summary>
    /// CallStaticMethod 重载版本
    /// </summary>
    public object CallStaticMethodOverload(string className, string methodName, int methodIndex, object[] listParms, string[] listTypes)
    {
        Type type = GetType(className);
        MethodInfo mi = GetMethodInfo(type, methodName, methodIndex);
        object[] objParms = DealWithTypes(listParms, listTypes);
        return mi.Invoke(null, objParms);
    }
    /// <summary>
    /// 调用单例的方法
    /// </summary>
    /// <param name="className">类名</param>
    /// <param name="instanceName">单例的属性名字如Instance,instance</param>
    /// <param name="methodName">方法名</param>
    /// <param name="isProperty">单例的属性是否为property(get set)</param>
    /// <param name="listParms">参数数组</param>
    /// <param name="listTypes">参数类型数组</param>
    /// <returns></returns>
    public object CallInstanceMethod(string className, string instanceName, string methodName, bool isProperty, object[] listParms, string[] listTypes)
    {
        Type type = GetType(className);
        if (isProperty)
        {
            PropertyInfo pi = GetProperty(type, instanceName);//type.GetProperty(instanceName);
            object obj = pi.GetValue(null, null);
            MethodInfo mi = type.GetMethod(methodName, BindingFlags.Instance | BindingFlags.NonPublic | BindingFlags.Public);
            object[] objParms = DealWithTypes(listParms, listTypes);
            return mi.Invoke(obj, objParms);
        }
        else
        {
            FieldInfo fi = GetField(type, instanceName);//type.GetField(instanceName);
            object obj = fi.GetValue(null);
            MethodInfo mi = type.GetMethod(methodName, BindingFlags.Instance | BindingFlags.NonPublic | BindingFlags.Public);
            object[] objParms = DealWithTypes(listParms, listTypes);
            return mi.Invoke(obj, objParms);
        }
    }
    /// <summary>
    /// CallInstanceMethod重载版
    /// </summary>
    public object CallInstanceMethodOverload(string className, string instanceName, string methodName, int methodIndex, bool isProperty, object[] listParms, string[] listTypes)
    {
        Type type = GetType(className);
        if (isProperty)
        {
            PropertyInfo pi = GetProperty(type, instanceName);//type.GetProperty(instanceName);
            object obj = pi.GetValue(null, null);
            MethodInfo mi = GetMethodInfo(type, methodName, methodIndex);//type.GetMethod(methodName);
            object[] objParms = DealWithTypes(listParms, listTypes);
            return mi.Invoke(obj, objParms);
        }
        else
        {
            FieldInfo fi = GetField(type, instanceName);//type.GetField(instanceName);
            object obj = fi.GetValue(null);
            MethodInfo mi = GetMethodInfo(type, methodName, methodIndex);//type.GetMethod(methodName);
            object[] objParms = DealWithTypes(listParms, listTypes);
            return mi.Invoke(obj, objParms);
        }
    }
    /// <summary>
    /// 调用已实例化对象的方法
    /// </summary>
    /// <param name="obj"></param>
    /// <param name="objClass"></param>
    /// <param name="methodName"></param>
    /// <param name="listParms"></param>
    /// <param name="listTypes"></param>
    /// <returns></returns>
    public object CallObjectMethod(object obj, string objClass, string methodName, object[] listParms, string[] listTypes)
    {
        Type type = GetType(objClass);
        MethodInfo mi = type.GetMethod(methodName, BindingFlags.Instance | BindingFlags.NonPublic | BindingFlags.Public);
        object[] objParms = DealWithTypes(listParms, listTypes);
        return mi.Invoke(obj, objParms);
    }
    /// <summary>
    /// CallObjectMethod的重载版
    /// </summary>
    public object CallObjectMethodOverLoad(object obj, string objClass, string methodName, int methodIndex, object[] listParms, string[] listTypes)
    {
        Type type = GetType(objClass);
        MethodInfo mi = GetMethodInfo(type, methodName, methodIndex);
        object[] objParms = DealWithTypes(listParms, listTypes);
        return mi.Invoke(obj, objParms);
    }

    /// <summary>
    /// 调用已实例化的对象的泛型方法
    /// </summary>
    /// <param name="obj"></param>
    /// <param name="objClass"></param>
    /// <param name="methodName"></param>
    /// <param name="objParms">全体参数，包括泛型参数和非泛型参数</param>
    /// <param name="genericTypes">泛型类型的数组</param>
    /// <param name="objNoneGenericTypes">非泛型类型的数组</param>
    /// <returns></returns>
    public object CallInstanceGenericMethod(object obj, string objClass, string methodName, object[] objParms, string[] genericTypes, string[] objNoneGenericTypes)
    {
        Type type = GetType(objClass);
        MethodInfo mi = type.GetMethod(methodName, BindingFlags.Instance | BindingFlags.NonPublic | BindingFlags.Public);
        Type[] typeGenerics = new Type[genericTypes.Length];
        for (int i = 0; i < genericTypes.Length; i++)
        {
            Type typeGeneric = Type.GetType(genericTypes[i]);
            typeGenerics[i] = typeGeneric;
        }
        mi = mi.MakeGenericMethod(typeGenerics);
        object[] objs = DealWithTypesGenericAndNoneGeneric(objParms, genericTypes, objNoneGenericTypes);
        return mi.Invoke(obj, objs);
    }
    /// <summary>
    /// CallInstanceGenericMethod重载版本
    /// </summary>
    public object CallInstanceGenericMethodOverload(object obj, string objClass, string methodName, int methodIndex, object[] objParms, string[] genericTypes, string[] objNoneGenericTypes)
    {
        Type type = GetType(objClass);
        MethodInfo mi = GetMethodInfo(type, methodName, methodIndex);//type.GetMethod(methodName);
        Type[] typeGenerics = new Type[genericTypes.Length];
        for (int i = 0; i < genericTypes.Length; i++)
        {
            Type typeGeneric = Type.GetType(genericTypes[i]);
            typeGenerics[i] = typeGeneric;
        }
        mi = mi.MakeGenericMethod(typeGenerics);
        object[] objs = DealWithTypesGenericAndNoneGeneric(objParms, genericTypes, objNoneGenericTypes);
        return mi.Invoke(obj, objs);
    }
    /// <summary>
    /// 调用类的静态泛型方法
    /// </summary>
    /// <param name="objClass"></param>
    /// <param name="methodName"></param>
    /// <param name="objParms">全体参数，包括泛型参数和非泛型参数</param>
    /// <param name="genericTypes">泛型类型的数组</param>
    /// <param name="objNoneGenericTypes">非泛型类型的数组</param>
    /// <returns></returns>
    public object CallStaticGenericMethod(string objClass, string methodName, object[] objParms, string[] genericTypes, string[] objNoneGenericTypes)
    {
        Type type = GetType(objClass);
        MethodInfo mi = type.GetMethod(methodName, BindingFlags.Static | BindingFlags.NonPublic | BindingFlags.Public);
        Type[] typeGenerics = new Type[genericTypes.Length];
        for (int i = 0; i < genericTypes.Length; i++)
        {
            Type typeGeneric = Type.GetType(genericTypes[i]);
            typeGenerics[i] = typeGeneric;
        }
        mi = mi.MakeGenericMethod(typeGenerics);
        object[] objs = DealWithTypesGenericAndNoneGeneric(objParms, genericTypes, objNoneGenericTypes);
        return mi.Invoke(null, objs);
    }
    /// <summary>
    /// CallStaticGenericMethod的重载版本
    /// </summary>
    public object CallStaticGenericMethodOverload(string objClass, string methodName, int methodIndex, object[] objParms, string[] genericTypes, string[] objNoneGenericTypes)
    {
        Type type = GetType(objClass);
        MethodInfo mi = GetMethodInfo(type, methodName, methodIndex);//type.GetMethod(methodName);
        Type[] typeGenerics = new Type[genericTypes.Length];
        for (int i = 0; i < genericTypes.Length; i++)
        {
            Type typeGeneric = Type.GetType(genericTypes[i]);
            typeGenerics[i] = typeGeneric;
        }
        mi = mi.MakeGenericMethod(typeGenerics);
        object[] objs = DealWithTypesGenericAndNoneGeneric(objParms, genericTypes, objNoneGenericTypes);
        return mi.Invoke(null, objs);
    }
    public object CallObjectMethodByType(object obj,Type type,string methodName,int methodIndex,object[] objParms, string[] parmTypes)
    {
        MethodInfo mi = GetMethodInfo(type, methodName, methodIndex);
        objParms = DealWithTypes(objParms, parmTypes);
        return mi.Invoke(obj, objParms);
    }
    #endregion

    #region property
    /// <summary>
    /// 拿到单例对象
    /// </summary>
    /// <param name="className"></param>
    /// <param name="instanceName"></param>
    /// <returns></returns>
    public object GetInstance(string className, string instanceName)
    {
        Type type = GetType(className);
        PropertyInfo pi = GetProperty(type, instanceName);//type.GetProperty(instanceName);
        object obj = pi.GetValue(null, null);
        return obj;
    }
    /// <summary>
    /// 拿到类的静态变量
    /// </summary>
    /// <param name="className"></param>
    /// <param name="fieldName"></param>
    /// <param name="isProperty"></param>
    /// <param name="propertyType"></param>
    /// <returns></returns>
    public object GetStaticObject(string className, string fieldName, bool isProperty, string propertyType)
    {
        Type type = GetType(className);
        if (isProperty)
        {
            PropertyInfo pi = GetProperty(type, fieldName);//type.GetProperty(fieldName);
            object value = DealWithType(pi.GetValue(null, null), propertyType);
            return value;
        }
        else
        {
            FieldInfo fi = GetField(type, fieldName);//type.GetField(fieldName);
            object value = DealWithType(fi.GetValue(null), propertyType);
            return value;
        }
    }
    /// <summary>
    /// 拿到已实例化对象的某个变量
    /// </summary>
    /// <param name="obj"></param>
    /// <param name="objClass"></param>
    /// <param name="propertyName"></param>
    /// <param name="isProperty"></param>
    /// <param name="propertyClassName"></param>
    /// <returns></returns>
    public object GetObjectProperty(object obj, string objClass, string propertyName, bool isProperty, string propertyClassName)
    {
        Type type = GetType(objClass);
        if (isProperty)
        {
            PropertyInfo pi = GetProperty(type, propertyName);//type.GetProperty(propertyName);
            object value = pi.GetValue(obj, null);
            DealWithType(value, propertyClassName);
            return value;
        }
        else
        {
            FieldInfo fi = GetField(type, propertyName);//type.GetField(propertyName);
            object value = fi.GetValue(obj);
            DealWithType(value, propertyClassName);
            return value;
        }
    }
    /// <summary>
    /// 通过类名创建对象,仅仅支持自定义类型，parms是构造函数的参数，没有可以传nil
    /// </summary>
    /// <param name="className"></param>
    /// <returns></returns>
    public object CreateObjectWithParm(string className, object[] parms,string[] parmsType)
    {
        Type type = GetType(className);
        object[] objParms = DealWithTypes(parms, parmsType);
        return System.Activator.CreateInstance(type, objParms);
    }
    /// <summary>
    /// 通过类名创建对象
    /// </summary>
    /// <param name="className"></param>
    /// <returns></returns>
    public object CreateObject(string className)
    {
        Type type = GetType(className);
        return System.Activator.CreateInstance(type);
    }
    /// <summary>
    /// 通过Type创建实例，parms是构造函数的参数，没有可以传nil
    /// </summary>
    /// <param name="type"></param>
    /// <returns></returns>
    public object CreateObjectByTypeWithParm(Type type, object[] parms, string[] parmsType)
    {
        object[] objParms = DealWithTypes(parms, parmsType);
        return Activator.CreateInstance(type, objParms);
    }
    /// <summary>
    /// 通过Type创建实例，parms是构造函数的参数，没有可以传nil
    /// </summary>
    /// <param name="type"></param>
    /// <returns></returns>
    public object CreateObjectByType(Type type)
    {
        return Activator.CreateInstance(type);
    }
    /// <summary>
    /// 设置对象的变量值
    /// </summary>
    /// <param name="obj"></param>
    /// <param name="objClass"></param>
    /// <param name="propertyName"></param>
    /// <param name="isProperty"></param>
    /// <param name="value"></param>
    /// <param name="valueType"></param>
    public void SetObjectProperty(object obj, string objClass, string propertyName, bool isProperty, object value, string valueType)
    {
        Type type = GetType(objClass);
        value = DealWithType(value, valueType);
        if (isProperty)
        {
            PropertyInfo pi = GetProperty(type, propertyName);//type.GetProperty(propertyName);
            pi.SetValue(obj, value, null);
        }
        else
        {
            FieldInfo fi = GetField(type, propertyName);//type.GetField(propertyName);
            fi.SetValue(obj, value);
        }
    }
    /// <summary>
    /// 通过整形拿到枚举
    /// </summary>
    /// <param name="enumName"></param>
    /// <param name="enumMember"></param>
    /// <returns></returns>
    public object GetEnumMemberByInt(string enumName, int enumMember)
    {
        Type type = GetType(enumName);
        if (type.IsEnum)
        {
            Array array = Enum.GetValues(type);
            foreach (var value in array)
            {
                int num = Convert.ToInt32(value);
                if (num == enumMember)
                    return value;
            }
        }
        return null;
    }

    public System.Action LuafunctionToAction(LuaInterface.LuaFunction luafunction)
    {
        return () => { luafunction.Call(); luafunction.Dispose(); };
    }
    /// <summary>
    /// 根据某函数参数获取type
    /// </summary>
    /// <param name="className"></param>
    /// <param name="methodName"></param>
    /// <param name="methodIndex"></param>
    /// <param name="parmIndex"></param>
    /// <returns></returns>
    public Type GetTypeByMethodParm(string className, string methodName, int methodIndex, int parmIndex)
    {
        Type typeClass = GetType(className);
        MethodInfo mi = GetMethodInfo(typeClass, methodName, methodIndex);
        ParameterInfo[] parms = mi.GetParameters();
        ParameterInfo parm = parms[parmIndex];
        return parm.ParameterType;
    }
    /// <summary>
    /// 根据某函数返回值获取type
    /// </summary>
    /// <param name="className"></param>
    /// <param name="methodName"></param>
    /// <param name="methodIndex"></param>
    /// <param name="parmIndex"></param>
    /// <returns></returns>
    public Type GetTypeByMethodReturn(string className, string methodName, int methodIndex, int parmIndex)
    {
        Type typeClass = GetType(className);
        MethodInfo mi = GetMethodInfo(typeClass, methodName, methodIndex);
        
        //ParameterInfo[] parms = mi.GetParameters();
        //ParameterInfo parm = parms[parmIndex];
        return mi.ReturnType;
    }
    /// <summary>
    /// 根据某个类的property获取type
    /// </summary>
    /// <param name="className"></param>
    /// <param name="propertyName"></param>
    /// <returns></returns>
    public Type GetTypeByProperty(string className,string propertyName)
    {
        Type typeClass = GetType(className);
        PropertyInfo pi = GetProperty(typeClass, propertyName);
        return pi.PropertyType;
    }
    /// <summary>
    /// 根据某个类的field获取type
    /// </summary>
    /// <param name="className"></param>
    /// <param name="fieldName"></param>
    /// <returns></returns>
    public Type GetTypeByField(string className,string fieldName)
    {
        Type typeClass = GetType(className);
        FieldInfo fi = GetField(typeClass, fieldName);
        return fi.FieldType;
    }
    /// <summary>
    /// 创建一个List<className>
    /// </summary>
    /// <param name="className"></param>
    /// <returns></returns>
    public Type CreateListType(string className)
    {
        Type typeClass = GetType(className);
        Type listType = typeof(List<>).MakeGenericType(typeClass);
        return listType;
    }
    /// <summary>
    /// 创建一个 Dictionary<keyClass,valueClass>
    /// </summary>
    /// <param name="keyClass"></param>
    /// <param name="valueClass"></param>
    /// <returns></returns>
    public Type CreateDictionaryType(string keyClass,string valueClass)
    {
        Type typeKey = GetType(keyClass);
        Type typeValue = GetType(valueClass);
        Type typeDic = typeof(Dictionary<,>).MakeGenericType(typeKey, typeValue);
        return typeDic;
    }
    #endregion
    #region tool

    private object DealWithType(object parm, string typename)
    {
        object obj = null;
        if (typename.Equals("int"))
        {
            obj = Convert.ToInt32(parm);
        }
        else if (typename.Equals("float"))
        {
            obj = Convert.ToSingle(parm);
        }
        else if (typename.Equals("double"))
        {
            obj = Convert.ToDouble(parm);
        }
        else if (typename.Equals("bool"))
        {
            obj = Convert.ToBoolean(parm);
        }
        else if (typename.Equals("byte"))
        {
            obj = Convert.ToByte(parm);
        }
        else if (typename.Equals("char"))
        {
            obj = Convert.ToChar(parm);
        }
        else if (typename.Equals("uint"))
        {
            obj = Convert.ToUInt32(parm);
        }
        else if (typename.Equals("long"))
        {
            obj = Convert.ToInt64(parm);
        }
        else if (typename.Equals("string"))
        {
            obj = Convert.ToString(parm);
        }
		else if (typename.Equals("nil"))
		{
			obj = null;
		}
        else
        {
            obj = parm;
        }
        return obj;
    }

    private object[] DealWithTypes(object[] listParms, string[] listTypes)
    {
        object[] objParms = new object[listTypes.Length];
        for (int i = 0; i < listTypes.Length; i++)
        {
            string typeStr = listTypes[i];
            object obj = DealWithType(listParms[i], typeStr);

            objParms[i] = obj;
        }
        return objParms;
    }

    private object[] DealWithTypesGenericAndNoneGeneric(object[] listParms, string[] listTypesGeneric, string[] listTypesNoneGeneric)
    {
        object[] objParms = new object[listParms.Length];
        for (int i = 0; i < listParms.Length; i++)
        {
            string typeStr = "";
            if (i < listTypesGeneric.Length)
            {
                typeStr = listTypesGeneric[i];
            }
            else
            {
                typeStr = listTypesNoneGeneric[i - listTypesGeneric.Length];
            }
            object obj = DealWithType(listParms[i], typeStr);

            objParms[i] = obj;
        }
        return objParms;
    }
    private Type GetType(string typeName)
    {
        if (typeName.Equals("int"))
        {
            return typeof(int);
        }
        else if (typeName.Equals("float"))
        {
            return typeof(float);
        }
        else if (typeName.Equals("double"))
        {
            return typeof(double);
        }
        else if (typeName.Equals("bool"))
        {
            return typeof(bool);
        }
        else if (typeName.Equals("byte"))
        {
            return typeof(byte);
        }
        else if (typeName.Equals("char"))
        {
            return typeof(char);
        }
        else if (typeName.Equals("uint"))
        {
            return typeof(uint);
        }
        else if (typeName.Equals("long"))
        {
            return typeof(long);
        }
        else if (typeName.Equals("string"))
        {
            return typeof(string);
        }

        Type type = Type.GetType(typeName);
        if (type != null)
            return type;
        Assembly[] assemblys = AppDomain.CurrentDomain.GetAssemblies();
        for (int i = 0; i < assemblys.Length; i++)
        {
            Type temp = assemblys[i].GetType(typeName);
            if (temp != null)
            {
                return temp;
            }
        }
        return null;
    }

    #endregion

    //example
    //LuaReflectionTool.Instance.CallInstanceMethod("ReflectionToolTest1", "instance", "Test", true, new object[] {"sss",new GameObject("dd") }, new string[] {"string","GameObject" });
    //object obj = LuaReflectionTool.Instance.GetInstanceObject("ReflectionToolTest1", "instance");

    //LuaReflectionTool.Instance.CallObjectMethod(obj, "ReflectionToolTest1", "Test", new object[] { "sss", new GameObject("dd") }, new string[] { "string", "GameObject" });

    //obj = LuaReflectionTool.Instance.GetObjectValue(obj,"ReflectionToolTest1", "data", false, "DataTest");
    //obj = LuaReflectionTool.Instance.GetObjectValue(obj, "DataTest", "name", false, "string");

    //obj = LuaReflectionTool.Instance.GetInstanceObject("ReflectionToolTest1", "instance");
    //obj = LuaReflectionTool.Instance.GetObjectValue(obj, "ReflectionToolTest1", "data1", true, "DataTest");
    //obj = LuaReflectionTool.Instance.GetObjectValue(obj, "DataTest", "name", false, "string");
    //Debug.LogError("name  ++ " + obj);

    //obj =  LuaReflectionTool.Instance.GetStaticObject("ReflectionToolTest1", "testStr", "string");

    //obj = LuaReflectionTool.Instance.CreateObject("DataTest");
    //LuaReflectionTool.Instance.SetObjectValue(obj, "DataTest", "name", false, "dddffff");
    //LuaReflectionTool.Instance.SetObjectValue(obj, "DataTest", "name11", true, "ddd222");
    //Debug.LogError("testStr  ++ " + obj);

    //obj = LuaReflectionTool.Instance:GetInstanceObject("ReflectionToolTest1", "instance")
    //enumObj = LuaReflectionTool.Instance:GetStaticObject("eReflectionToolTest1", "AAA", "enum")
    //LuaReflectionTool.Instance:CallObjectMethod(obj, "ReflectionToolTest1", "TestEnum", { enumObj }, { "enum" })

}
