# flutter_server
サーバーとwindowsアプリケーションの起動
```
flutter run
```

apiにリクエストが来た際に次のページに遷移する
windowsアプリケーションが起動させた状態で下記のリクエストを送信。
```
curl.exe http://127.0.0.1:8080/api/v1/mynumber

curl.exe http://127.0.0.1:8080/api/v1/passport

curl.exe http://127.0.0.1:8080/api/v1/mynumber_pin
```

## 仕様書
[パスポートリーダー](https://gaia-btm.backlog.com/ViewAttachmentPdf.action?attachmentId=49882169)