# OkHttp3 笔记

## 官方参考
[OkHttp](https://square.github.io/okhttp/)  
[OkHttp - StackOverflow](https://stackoverflow.com/questions/tagged/okhttp?sort=active)

## Gradle
```
dependencies {
    implementation("com.squareup.okhttp3:okhttp:4.8.1")
}
```

## Get请求(异步方式) - **推荐**
```
public class MainActivity extends AppCompatActivity {
    private final String TAG = "MainActivity";
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        OkHttpClient client = new OkHttpClient();

        Request request = new Request.Builder()
                .url("https://www.baidu.com")
                .build();
        client.newCall(request).enqueue(new Callback() {
            @Override
            public void onFailure(@NotNull Call call, @NotNull IOException e) {

            }

            @Override
            public void onResponse(@NotNull Call call, @NotNull Response response) throws IOException {
                Log.d(TAG, "Response: " + response.body().string());
            }
        });
    }
    ...
}
```

## Get请求(同步方式)
根据官方文档:
```
public class MainActivity extends AppCompatActivity {
    private final String TAG = "MainActivity";
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        // 不能在主线程中直接请求
        new Thread(){
            @Override
            public void run() {
                Request request = new Request.Builder()
                        .url("https://www.baidu.com")
                        .build();
                try{
                    Response response = client.newCall(request).execute();
                    Log.d(TAG, "Response: " + response.body().string());
                } catch (IOException ioe) {
                    ioe.printStackTrace();
                }
            }
        }.start();
    }
    ...
}
```


## Post请求(同步方式)
按照官方[PostExample.java](https://raw.githubusercontent.com/square/okhttp/master/samples/guide/src/main/java/okhttp3/guide/PostExample.java)的做法:
```
public class MainActivity extends AppCompatActivity {
    public static final MediaType JSON = MediaType.parse("application/json; charset=utf-8");
    OkHttpClient client = new OkHttpClient();

    String post(String url, String json) throws IOException {
        RequestBody body = RequestBody.create(JSON, json);
        Request request = new Request.Builder()
                .url(url)
                .post(body)
                .build();
        try (Response response = client.newCall(request).execute()) {
            return response.body().string();
        }
    }

    String bowlingJson(String player1, String player2) {
        return "{'winCondition':'HIGH_SCORE',"
                + "'name':'Bowling',"
                + "'round':4,"
                + "'lastSaved':1367702411696,"
                + "'dateStarted':1367702378785,"
                + "'players':["
                + "{'name':'" + player1 + "','history':[10,8,6,7,8],'color':-13388315,'total':39},"
                + "{'name':'" + player2 + "','history':[6,10,5,10,10],'color':-48060,'total':41}"
                + "]}";
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        new Thread(){
            @Override
            public void run() {
                String json = bowlingJson("Jesse", "Jake");
                try {
                    String response = post("http://www.roundsapp.com/post", json);
                    System.out.println("Response: " + response);
                }catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }.start();
    }
    ...
}
```

但是遇到了
```
java.net.UnknownServiceException: CLEARTEXT communication to www.roundsapp.com not permitted by network security policy
```
异常, 参考[android-8-cleartext-http-traffic-not-permitted](https://stackoverflow.com/questions/45940861/android-8-cleartext-http-traffic-not-permitted)添加了`res/xml/network_security_config.xml`并配置内容如下:
```
<?xml version="1.0" encoding="utf-8"?>
<network-security-config>
    <domain-config cleartextTrafficPermitted="true">
        <domain includeSubdomains="true">www.roundsapp.com</domain>
    </domain-config>
</network-security-config>
```

可解决`java.net.UnknownServiceException`的问题

## Cache
参考官方文档:
```
public class MainActivity extends AppCompatActivity {
    private final String TAG = "MainActivity";
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        // 在构造OkHttpClient时配置
        OkHttpClient client = new OkHttpClient.Builder()
                .cache(new Cache(new File(getApplication().getCacheDir(), "http_cache"),
                        50L * 1024L * 1024L))
                .build();
        ...
    }
    ...
}
```

## EventListener
根据官方的例子, 先构造`PrintingEventListener`, 其扩展自`EventListener`类:
```
public class PrintingEventListener extends EventListener {
    private long callStartNanos;

    private void printEvent(String name) {
        long nowNanos = System.nanoTime();
        if (name.equals("callStart")) {
            callStartNanos = nowNanos;
        }
        long elapsedNanos = nowNanos - callStartNanos;
        System.out.printf("PrintingEventListener: %.3f %s%n", elapsedNanos / 1000000000d, name);
    }

    @Override public void callStart(Call call) {
        printEvent("callStart");
    }

    @Override public void callEnd(Call call) {
        printEvent("callEnd");
    }

    @Override public void dnsStart(Call call, String domainName) {
        printEvent("dnsStart");
    }

    @Override public void dnsEnd(Call call, String domainName, List<InetAddress> inetAddressList) {
        printEvent("dnsEnd");
    }
}
```

然后在创建`OkHttpClient`时:
```
public class MainActivity extends AppCompatActivity {
    private final String TAG = "MainActivity";
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        // 此处通过eventListener()接口添加自定义的EventListener
        OkHttpClient client = new OkHttpClient.Builder()
                .eventListener(new PrintingEventListener())
                .build();
        ...
    }
    ...
}
```

不过官方推荐使用`EventListener.Factory`的方式适应不同连接的事件监听, 对于PrintingEventListener做如下调整:
```
public class PrintingEventListener extends EventListener {
    private long callStartNanos;
    private long callId;

    public static final EventListener.Factory FACTORY = new EventListener.Factory() {
        final AtomicLong nextCallId = new AtomicLong(1L);

        // 该方法会在没给连接创建时调用一次, 负责返回一个与连接关联的EventListener
        @NotNull
        @Override
        public EventListener create(@NotNull Call call) {
            // 记录callId, 用以去人不同的Call
            long callId = nextCallId.getAndIncrement();
            System.out.printf("%04d %s%n", callId, call.request().url());
            return new PrintingEventListener(callId, System.nanoTime());
        }
    };

    public PrintingEventListener(long callId, long callStartNanos) {
        this.callId = callId;
        this.callStartNanos = callStartNanos;
    }

    private void printEvent(String name) {
        long nowNanos = System.nanoTime();
        if (name.equals("callStart")) {
            callStartNanos = nowNanos;
        }
        long elapsedNanos = nowNanos - callStartNanos;
        // 这里可以多增加一个callId的信息
        System.out.printf("PrintingEventListener:%04d %.3f %s%n", callId, elapsedNanos / 1000000000d, name);
    }

    @Override public void callStart(Call call) {
        printEvent("callStart");
    }

    @Override public void callEnd(Call call) {
        printEvent("callEnd");
    }

    @Override public void dnsStart(Call call, String domainName) {
        printEvent("dnsStart");
    }

    @Override public void dnsEnd(Call call, String domainName, List<InetAddress> inetAddressList) {
        printEvent("dnsEnd");
    }
}
```

在注册的时候也有所区别:
```
public class MainActivity extends AppCompatActivity {
    private final String TAG = "MainActivity";
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        OkHttpClient client = new OkHttpClient.Builder()
                // 这里应使用eventListenerFactory()接口, 而不是eventListener()
                .eventListenerFactory(PrintingEventListener.FACTORY)
                .build();
        ...
    }
    ...
}
```

## CertificatePinner(证书锁定)
设置网站证书相关的公钥, 如果设置, 会用公钥验证网站的证书, 合法后才可以继续:
```
public class MainActivity extends AppCompatActivity {
    private final String TAG = "MainActivity";
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        OkHttpClient client = new OkHttpClient.Builder()
        .certificatePinner(
            // 绑定证书, 这个证书是错误的
            new CertificatePinner.Builder()
                    .add("publicobject.com", "sha256/afwiKY3RxoMmLkuRW1l7QsPZTJPwDS2pdDROQjXw8ig=")
                    .build())
        .build();
        Request request = new Request.Builder()
                .url("https://publicobject.com/robots.txt")
                .build();
        client.newCall(request).enqueue(new Callback() {
            @Override
            public void onFailure(@NotNull Call call, @NotNull IOException e) {
                Log.d(TAG, "Error: " + e.getMessage());
            }

            @Override
            public void onResponse(@NotNull Call call, @NotNull Response response) throws IOException {
                Log.d(TAG, "Response: " + response.body().string());
            }
        });
    }
    ...
}
```
有由于故意传错了证书的公钥, 所以验证会失败:
```
D/MainActivity: Error: Certificate pinning failure!
      Peer certificate chain:
        sha256/C4f8sd7pdRY7B87OiUo20x3Dh9WVU0ZgJXX67BOKgWw=: CN=privateobject.com
        sha256/YLh1dUR9y6Kja30RrAn7JKnbQG/uEtLMkBgFF2Fuihg=: CN=Let's Encrypt Authority X3,O=Let's Encrypt,C=US
        sha256/Vjs8r4z+80wjNcr1YKepWQboSIRi63WsWXhIMN+eWys=: CN=DST Root CA X3,O=Digital Signature Trust Co.
      Pinned certificates for publicobject.com:
        sha256/afwiKY3RxoMmLkuRW1l7QsPZTJPwDS2pdDROQjXw8ig=
```

替换正确的证书: `sha256/C4f8sd7pdRY7B87OiUo20x3Dh9WVU0ZgJXX67BOKgWw=`, 可以看到得到了正确的返回:
```
D/MainActivity: Response: User-agent: *
    Disallow: /glazedlists/wiki/
```

## cancel Call
如果取消一个call, 直接调用`Call.cancle()`即可:
```
public class MainActivity extends AppCompatActivity {
    private final String TAG = "MainActivity";
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        OkHttpClient client = new OkHttpClient.Builder()
            ...
            .build();
        ...
        final Handler handler = new Handler();
        final long startNanos = System.nanoTime();
        handler.postDelayed(new Runnable() {
            @Override
            public void run() {
                System.out.printf("%.2f Canceling call.%n", (System.nanoTime() - startNanos) / 1e9f);
                // 此处取消了call
                call.cancel();
                System.out.printf("%.2f Canceled call.%n", (System.nanoTime() - startNanos) / 1e9f);
            }
        }, 1000);
    }
    ...
}
```

可以从log中看到任务的取消:
```
I/System.out: 1.00 Canceling call.
// 取消会触发异步的Socket closed
D/MainActivity: Error: Socket closed
I/System.out: 1.02 Canceled call.
```

## Interceptor(拦截器)
按照官方文档:
```
public class LoggingInterceptor implements Interceptor {
    private final String TAG = "LoggingInterceptor";

    @Override
    public Response intercept(Chain chain) throws IOException {
        // 从Chain中提取请求, 进行请求拦截
        Request request = chain.request();

        long t1 = System.nanoTime();
        Log.d(TAG,String.format("Sending request %s on %s%n%s", request.url(), chain.connection(), request.headers()));

        // 执行请求, 得到respose, 此处为响应拦截
        Response response = chain.proceed(request);

        // 根据需要解析response处理Token过期等拦截的情况

        long t2 = System.nanoTime();
        Log.d(TAG, String.format("Received response for %s in %.1fms%n%s",
                response.request().url(), (t2 - t1) / 1e6d, response.headers()));
        // 根据需要可以进行二次proceed()
        return response;
    }
}
```

拦截器的注册:
```
public class MainActivity extends AppCompatActivity {
    private final String TAG = "MainActivity";
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        OkHttpClient client = new OkHttpClient.Builder()
                .eventListenerFactory(PrintingEventListener.FACTORY)
                // 注意如果需要拦截网络请求, 则需要使用addNetworkInterceptor()接口
                .addInterceptor(new LoggingInterceptor())
                .build();
        ...
    }
    ...
}
```

拦截器log(addInterceptor):
```
...
D/LoggingInterceptor: Sending request https://publicobject.com/robots.txt on null
...
D/LoggingInterceptor: Received response for https://publicobject.com/robots.txt in 1665.7ms
    Server: nginx/1.10.3 (Ubuntu)
    Date: Mon, 07 Sep 2020 10:20:16 GMT
    Content-Type: text/plain
    Content-Length: 43
    Last-Modified: Tue, 09 Jun 2009 00:00:00 GMT
    Connection: keep-alive
    ETag: "4a2da600-2b"
    Accept-Ranges: bytes
...
```

拦截器log(addNetworkInterceptor):
```
...
D/LoggingInterceptor: Sending request https://publicobject.com/robots.txt on Connection{publicobject.com:443, proxy=DIRECT hostAddress=publicobject.com/54.187.32.157:443 cipherSuite=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 protocol=http/1.1}
    Host: publicobject.com
    Connection: Keep-Alive
    Accept-Encoding: gzip
    User-Agent: okhttp/4.8.1
...
D/LoggingInterceptor: Received response for https://publicobject.com/robots.txt in 489.1ms
    Server: nginx/1.10.3 (Ubuntu)
    Date: Mon, 07 Sep 2020 10:22:12 GMT
    Content-Type: text/plain
    Content-Length: 43
    Last-Modified: Tue, 09 Jun 2009 00:00:00 GMT
    Connection: keep-alive
    ETag: "4a2da600-2b"
    Accept-Ranges: bytes
...
```

## Header
```
public class MainActivity extends AppCompatActivity {
    private final String TAG = "MainActivity";
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        ...
        // header在构造Request时添加
        Request request = new Request.Builder()
                .url("https://publicobject.com/robots.txt")
                .header("User-Agent", "OkHttp Headers.java")
                .addHeader("Accept", "application/json; q=0.5")
                .addHeader("Accept", "application/vnd.github.v3+json")
                .build();
        ...
    }
    ...
}
```
执行上述Header的添加后, 可以从拦截器的log中看到添加的Header:
```
D/LoggingInterceptor: Sending request https://publicobject.com/robots.txt on Connection{publicobject.com:443, proxy=DIRECT hostAddress=publicobject.com/54.187.32.157:443 cipherSuite=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 protocol=http/1.1}
    // 以下三行是后添加的Header信息
    User-Agent: OkHttp Headers.java
    Accept: application/json; q=0.5
    Accept: application/vnd.github.v3+json
    Host: publicobject.com
    Connection: Keep-Alive
    Accept-Encoding: gzip
```

## Post
### 发送字符串
```
public class MainActivity extends AppCompatActivity {
    private final String TAG = "MainActivity";

    // 需要提供一个媒体类型, 可以通过MIME字符串解析出:
    private static final MediaType MEDIA_TYPE_MARKDOWN
            = MediaType.parse("text/x-markdown; charset=utf-8");
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        ...
        // 需要Post的字符串
        String postBody = ""
                + "Releases\n"
                + "--------\n"
                + "\n"
                + " * _1.0_ May 6, 2013\n"
                + " * _1.1_ June 15, 2013\n"
                + " * _1.2_ August 11, 2013\n";
        // 构造一个post的请求:
        Request request = new Request.Builder()
                .url("https://api.github.com/markdown/raw")
                // 需要提供数据的MeidaType, 这里是上面解析得到的: MEDIA_TYPE_MARKDOWN
                .post(RequestBody.create(MEDIA_TYPE_MARKDOWN, postBody))
                .build();
        client.newCall(request)
                .enqueue(new Callback() {
                    ...
                });
        ...
    }
    ...
}
```

### 发送自定义RequestBody
也可以通过重写`RequestBody`的`contentType()`和`writeTo()`两个方法实现自定义的请求构造:
```
public class MainActivity extends AppCompatActivity {
    private final String TAG = "MainActivity";

    // 需要提供一个媒体类型, 可以通过MIME字符串解析出:
    private static final MediaType MEDIA_TYPE_MARKDOWN
            = MediaType.parse("text/x-markdown; charset=utf-8");
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        RequestBody requestBody = new RequestBody() {
            @Override
            public MediaType contentType() {
                // 需要明确RequestBody的MediaType
                return MEDIA_TYPE_MARKDOWN;
            }

            // 构造RequestBody的数据, 最终写入到: BufferedSink中
            @Override
            public void writeTo(BufferedSink sink) throws IOException {
                sink.writeUtf8("Nubers\n");
                sink.writeUtf8("-------\n");
                for(int i = 2; i < 97; i++) {
                    sink.writeUtf8(String.format(" * %s = %s\n", i, factor(i)));
                }
            }
        };
        Request request = new Request.Builder()
                .url("https://api.github.com/markdown/raw")
                // 这里直接传RequestBody即可
                .post(requestBody)
                .build();
        ...
    }
    ...
}
```

### 发送一个文件
只需要向`Request.Builder`的`post()`方法传入:`RequestBody.create(MEDIA_TYPE_MARKDOWN, new File("README.md"))`即可;

### POST参数
```
RequestBody formBody = new FormBody.Builder()
    .add("search", "Jurassic Park")
    .build();
Request request = new Request.Builder()
    .url("https://en.wikipedia.org/w/index.php")
    .post(formBody)
    .build();
```