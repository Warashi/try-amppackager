# try-amppackager

`/etc/hosts` に下記を加えてGoogle Chrome Canaryで動作確認する

```
127.0.0.1 origin.local
```

Google Chrome Canary 起動コマンド
```
open -a "Google Chrome Canary" --args --ignore-certificate-errors-spki-list=CTKYAj/y1IV6vPiiDpYAx0BF6AAS1lCeQSlZdcqcmHc=
```

https://localhost/priv/doc/https://origin.local/index.html

これを入れて `AMP-Cache-Transform: google` を送ること。
https://chrome.google.com/webstore/detail/modheader/idgpnmonknjnojddfkpgkljpfnnfcklj