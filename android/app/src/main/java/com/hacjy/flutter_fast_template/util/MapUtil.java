package com.hacjy.flutter_fast_template.util;


import com.alibaba.fastjson.JSONObject;

import java.lang.reflect.Field;
import java.lang.reflect.Modifier;
import java.util.HashMap;
import java.util.Map;

public class MapUtil {
    public static Object mapToObject(Map<String, Object> map, Class<?> beanClass) throws Exception {
        if (map == null)
            return null;

        Object obj = beanClass.newInstance();

        Field[] fields = obj.getClass().getDeclaredFields();
        for (Field field : fields) {
            int mod = field.getModifiers();
            if(Modifier.isStatic(mod) || Modifier.isFinal(mod)){
                continue;
            }

            field.setAccessible(true);
            field.set(obj, map.get(field.getName()));
        }

        return obj;
    }

    public static Map<String, Object> objectToMap(Object obj) throws Exception {
        if(obj == null){
            return null;
        }

        Map<String, Object> map = new HashMap<String, Object>();

        //继承的Object属性转换不出来，弃用
//        Field[] declaredFields = obj.getClass().getDeclaredFields();
//        for (Field field : declaredFields) {
//            field.setAccessible(true);
//            map.put(field.getName(), field.get(obj));
//        }
        String json = JsonUtil.objectToString(obj);
        //gson转无类型map时，字符串会多出一层双引号 弃用
//        map = JsonUtil.getGson().fromJson(json,HashMap.class);

        //fastjson可以直接转map 因为JSONObject实现了map接口
        map = (Map) JSONObject.parse(json);
        return map;
    }
}
