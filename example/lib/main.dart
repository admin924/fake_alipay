import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fake_alipay/fake_alipay.dart';

void main() {
  runZoned(() {
    runApp(MyApp());
  }, onError: (Object error, StackTrace stack) {
    print(error);
    print(stack);
  });

  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

/// pkcs1 -> '-----BEGIN RSA PRIVATE KEY-----\n${支付宝RSA签名工具生产的私钥}\n-----END RSA PRIVATE KEY-----'
/// pkcs8 -> '-----BEGIN PRIVATE KEY-----\n${支付宝RSA签名工具生产的私钥}\n-----END PRIVATE KEY-----'
class _HomeState extends State<Home> {
  static const String _ALIPAY_APPID = '2021001163661732'; // 支付/登录
  static const String _ALIPAY_PID = '2088731981552656'; // 登录
  static const String _ALIPAY_TARGETID = 'kkkkk091125'; // 登录
  static const String _ALIPAY_PRIVATEKEY = 'MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCtaafca8fGIoZ4JaU3Z4EkIQ85REvxmVeYqPsRbsuR7F4pk94hNZfa8KOUNS39XNxWmSO0STgRM/VtxSapBwa/j8izVd3sntCULZyacfipYA7QDfbTL84nJ6fD1BIl9qIvOaIgu0JIstU21rqCMineuuyO4WmTWHWdNj6QTF+xjEOz4KzuZ0cBavE2A3ZhQbYUFICUL+/ePTZqvuYHS1EL8S8VvmOtsF5Xy9MQXVDiyTz6ONm/AEGBFv1njs19Rc3Z+HsEc+ECQmE2Yy1aVbSjsqlezVz2oAR7GWWjgZJoHnArqZi/+GrqCVt+u6OppbLt3TYadT96jujjwogSHNnPAgMBAAECggEAL9OzCzTirT+6bIqdbZFraaaAh1/Rvjl3klAQprczB/Tz522z1t7sGeNCik68d2NUFcI4ubFz+DKnXvX/+qBIeS7TwLpO8cK/bg7CYUpLtZMbosAnMgm+RshGGdl0g+nowzOXBoX++wPvkCda2yuwppBRS/rZXl0IWyqpyKx3vASou7bIJl0ttZ7016aetSSW9rGNXhbQcNuqaCzEmRBND779SlipCqNWNdPGrji2KO4duEkybrYQYIu9dWW7HZHX85UGf5N5B7h2nzMlXLU89oTIDvDtkjtN7zDhXDfc/UpfxN7wKjXaT1gYKgw2SeEPtL4Jxur+TgS1enJMy5VZMQKBgQD26HV6jlfgG117NuN64fW2poWyuGeZfEld+OKY1TVk5taUeZ70lc1Ln4Hudq7R3bZiB8EIC92Dm8QGy+V1FIFX6B9RQfCM20H6G0JmieE5T9iMb5Ipekj0Io2CB5zSobLCgoFUqBcDacCSy8Zz6SX9VF/CCaQpOf6pgWAavim2mQKBgQCzzF/h3pbxXGtT/wwtWuhJij7EWI7QKZwZxIr6yEYTWRipvt2njsvDO87y+dvBomxJZnrlg+/WhFjQCikBV/+vErUPWeAo86rIA/I21UpSkbwUL4EL+3TnQ/vtKvBU6VeJlWdc0fTbcDeuiZ/KsjenIKc2nLXDT/HL91Py5x4cpwKBgQCtygdOoTxnKLvOy16okr1xt5opprR9C0dU1qcgLgosIHLvBQAGZh6fWQGKiI0aePUz4QNUl41uYkhDBGdY1nsIFgFdH42ih33T/jXpmKknvvTMPIfjnAgXlu6FlLgkZd4+HL/Nh5bTNy9t4/KmiXfM7QONv12GCyUdyEuN50XTGQKBgCT1CnRkC4S7KXiPgVJFUF/lYbd8OIbDNsn5I1QfHIBXnQEvMWKCsJGF1qkNAMXRfA6uWO6aaw8eDx9cJ0eWbgDviHYKVFA2ndEVNpFc0DUerZk8lnr/Ce2LhNogLFxXxl2Kbz+eDIWakGd49HZ2oYfh510LYzUtVpdFVGUmaoMbAoGBALiaS0eyIAlM9wtt4P3ZCVIuS8Dx+7iKjHjnPuTW8TE5GAneZj8n2DlGsCAXO0LKq/kgCT9H5X0lGy3kEro8vKnJAGoGC5Y2tEx1OFOFtd+h0X3pK5J7envNxXcOSkZ4S9SMa0RANrci+U8D9O+UFKG9W3ikJ0dNAxW/C3iDrhEZ'; // 支付/登录

  Alipay _alipay = Alipay();

  StreamSubscription<AlipayResp> _auth;

  @override
  void initState() {
    super.initState();
    _auth = _alipay.authResp().listen(_listenAuth);
  }

  void _listenAuth(AlipayResp resp) {
    print(resp);
    String content = 'pay: ${resp.resultStatus} - ${resp.result}';
    _showTips('授权登录', content);
  }

  @override
  void dispose() {
    if (_auth != null) {
      _auth.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fake Alipay Demo'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('环境检查'),
            onTap: () async {
              String content = 'alipay: ${await _alipay.isAlipayInstalled()}';
              _showTips('环境检查', content);
            },
          ),
          ListTile(
            title: const Text('授权'),
            onTap: () {
              _alipay.auth(
                appId: _ALIPAY_APPID,
                pid: _ALIPAY_PID,
                targetId: _ALIPAY_TARGETID,
                privateKey: _ALIPAY_PRIVATEKEY,
                signType: Alipay.SIGNTYPE_RSA2
              );
            },
          ),
        ],
      ),
    );
  }

  void _showTips(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
        );
      },
    );
  }
}
