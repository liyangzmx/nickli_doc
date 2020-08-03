# 调用Java类的私有函数

## Java反射的实现方式
假设有一个私有类:
```
public class PrivMethodClass {
    final private void privPrint(String msg) {
        Log.d("PrivClass", "msg: " + msg);
    }
}
```

通过反射调用其`final private void privPrint(String msg)`方法的sample:
```
    PrivMethodClass privMethodClass = new PrivMethodClass();
    try {
        Class<?> clazz = Class.forName("com.wyze.jnicallback.PrivMethodClass");
        Method method = clazz.getDeclaredMethod("privPrint", String.class);
        // 如果是私有函数, 这里需要设置为'true'
        method.setAccessible(true);
        method.invoke(privMethodClass, getProperty("ro.build.version.sdk", "NO Value"));
    } catch (Exception e) {
        e.printStackTrace();
    }
```

## Native的实现方式
### PrivMethodClass
```
public class PrivMethodClass {
    final private void privPrint(String msg) {
        Log.d("PrivClass", "msg: " + msg);
    }
}
```

### 例化一个PrivMethodClass
```
PrivMethodClass privMethodClass = new PrivMethodClass();
```

### 实现一个Native
#### Java
```
public native void call_priv(PrivMethodClass privMethodClass, String msg);
```

#### Native
```
extern "C"
JNIEXPORT void JNICALL
Java_com_wyze_jnicallback_MainActivity_call_1priv(JNIEnv *env, jobject thiz,
                                                  jobject priv_method_class, jstring msg) {
    jclass clz = env->GetObjectClass(priv_method_class);
    jmethodID privMethodId = env->GetMethodID(clz, "privPrint", "(Ljava/lang/String;)V");
    env->CallVoidMethod(priv_method_class, privMethodId, msg);
    env->DeleteLocalRef(msg);
}
```

#### Java层直接调用
```
call_priv(privMethodClass, "Hello WYZE!");
```