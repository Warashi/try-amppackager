# try-amppackager

`docker-compose up` で起動する。

`/etc/hosts` に下記を加えてGoogle Chrome 73以降で `chrome://flags` からSigned HTTP Exchangeを有効にして動作確認する

```
127.0.0.1 try-amppackager.local
```

Google Chrome 起動コマンド (macOS用)
```
./scripts/open-chrome.sh
```

起動したら、DevToolsでNetworkを見ながら下記URLにアクセスする。

https://try-amppackager.local/index.html

[ModHeader](https://chrome.google.com/webstore/detail/modheader/idgpnmonknjnojddfkpgkljpfnnfcklj)を入れて `AMP-Cache-Transform: google` を送った場合と送らなかった場合でDevToolsのNetworkに出る情報を見る。送った場合にはsigned-exchangeが返ってきて、送らなかった場合には普通にhtmlが返ってくる。

