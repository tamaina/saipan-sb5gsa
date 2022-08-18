# Magisk Module: enable Softbank 5G SA for moto g50 5G (saipan, Android 12)

Softbank 5G SAをmoto g50 5G(saipan, Android 12)で掴めるようにします。  
CellMapperの記録用としてどうぞ。

Softbank 5G SA can be grabbed by moto g50 5G.  
This is for CellMapper's record.

## 注意 / ATTENTION

1. **SIMカードの種類が`5G-USIMnano`である必要があります。**  
   **Make sure the SIM card type is `5G-USIMnano`.**
2. **電波は掴みますが、通信はできません。**  
   **It grabs the signal but cannot communicate.**

## インストール方法 / Installation
1. [リリース一覧](https://github.com/tamaina/saipan-sb5gsa/releases)から最新のリリースの`Source code (zip)`を選択し、zipファイルを端末にダウンロードします。  
   Select the `Source code (zip)` of the latest release from the [Release List](https://github.com/tamaina/saipan-sb5gsa/releases) to download the zip file to your device.
2. Magiskアプリからモジュールのインストール操作を行い、ダウンロードしたzipファイルを選択します。  
   Perform the module installation operation from the Magisk application and select the downloaded zip file.
3. 端末を再起動します。  
   Reboot the device.

# Development

## s44020.pbの作り方 / How to make s44020.pb

1. 作業ディレクトリを用意し、adbと[protoc](https://github.com/protocolbuffers/protobuf/releases)を使えるようにする。  
   Prepare a working directory and make adb and [protoc](https://github.com/protocolbuffers/protobuf/releases) available.
2. https://android.googlesource.com/platform/tools/carrier_settings/+/refs/heads/master/proto からcarrier_settings.protoとcarrier_list.protoを作業ディレクトリにダウンロードする。
   Download carrier_settings.proto and carrier_list.proto from https://android.googlesource.com/platform/tools/carrier_settings/+/refs/heads/master/proto proto from +/refs/heads/master/proto to your working directory.
3. 端末のUSBデバッグを有効にし、PCにUSB接続する。`adb devices`で端末が表示されるか確認してみる。
   Enable USB debugging on your device and connect it to a PC via USB. Check if the terminal is displayed with `adb devices`.
4. `adb pull /product/etc/CarrierSettings/s44020.pb`
5. pbファイルをデコード:
   Decode pb file:  
   `protoc --decode=com.google.carrier.CarrierSettings carrier_settings.proto carrier_list.proto < s44020.pb > s44020.txt`
6. s44020.txtを開いて次のセクションを探す:  
   Open s44020.txt and find following section:

```
  config {
    key: "carrier_nr_availabilities_int_array"
    int_array {
      item: 1
    }
  }
```

これはNSAしか対応していないことを示している。SA対応するには次のよう書き換える。  
[API reference of Android](https://developer.android.com/reference/android/telephony/CarrierConfigManager#KEY_CARRIER_NR_AVAILABILITIES_INT_ARRAY) indicates that the above only supports NSA. The following would make it compatible with 5G SA:

```
  config {
    key: "carrier_nr_availabilities_int_array"
    int_array {
      item: 2
    }
  }
```

s44020.txtをpbにエンコードするには次の通り実行する:  
To encode s44020.txt, execute `protoc --encode=com.google.carrier.CarrierSettings carrier_settings.proto carrier_list.proto < s44020.txt > s44020.pb`
