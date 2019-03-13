# try-amppackager

`/etc/hosts` に下記を加えてGoogle Chrome Canaryで動作確認する

```
127.0.0.1 origin.local
```

Google Chrome Canary 起動コマンド
```
open -a "Google Chrome Canary" --args --ignore-certificate-errors-spki-list=$(cat cert/fingerprints.txt)
google-chrome-unsgtable --args --ignore-certificate-errors-spki-list=$(cat cert/fingerprints.txt)
```

起動したら、DevToolsでNetworkを見ながら下記URLにアクセスする。

https://origin.local/index.html

[ModHeader](https://chrome.google.com/webstore/detail/modheader/idgpnmonknjnojddfkpgkljpfnnfcklj)を入れて `AMP-Cache-Transform: google` を送った場合と送らなかった場合でDevToolsのNetworkに出る情報を見る。送った場合にはsigned-exchangeが返ってきて、送らなかった場合には普通にhtmlが返ってくる。

