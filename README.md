# MapApp

## Overview
MapViewとCoreLocationについての使い方の確認プロジェクト  
MapViewはただの地図で、その上にユーザの位置情報とかを扱いたいんだったらCoreLocationを使えって話。  
ここでは位置情報の利用を「常に許可」にする。  
iOSを想定。

## Description
現状は位置情報の利用を認証して現在地を取得して追従させているだけ。  
位置情報の利用権限まわりがややこしかった。  
以下に書くのはただの感想なので、特に読まなくていいです。

## info.plist
info.plistに書く内容でちょっと詰まった。  
iOS11からは位置情報を利用する場合NSLocationWhenInUseUsageDescription(アプリ使用中のみ使える)が必須になった。    
というよりかは、普通はアプリ使ってるときだけでいいよね？ってのが[Appleの主張](https://developer.apple.com/documentation/corelocation/cllocationmanager/1620551-requestalwaysauthorization)っぽい。  
本当に使用ユーザに利益がある場合のみAlwaysにしようってこと。
>Requesting “Always” authorization is discouraged because of the potential negative impacts to user privacy. You should request this level of authorization only when doing so offers a genuine benefit to the user.  

というわけで常に許可が欲しい場合はNSLocationAlwaysAndWhenInUseUsageDescriptionを指定すると、「常に許可」か「使用中のみ許可」かを選択できる認証ダイアログが出現する。  
常に位置情報が欲しくて、iOS11以下も対応させるためには
1. NSLocationAlwaysAndWhenInUseUsageDescription
1. NSLocationWhenInUseUsageDescription
1. NSLocationAlwaysUsageDescription

以上3つをセットすること。  

## CoreLocation
### didChangeAuthorization
CLLocationManagerDelegateの1つ。アプリケーションが利用できる位置情報の権限が変更されると呼ばれる。  
現状ここでのCLAuthorizationStatusは5つある。
1. notDetermined  
まだ認証の確認をしていない。requestAlwaysAuthorizationでユーザに権限を求めるといい。
1. restricted  
利用が許可されていないので位置情報は使えません。  
こっちは多分利用制限で使えない。  
1. denied  
利用が許可されていないので位置情報は使えません。  
こっちはユーザが明示的にこのアプリに対して利用を「許可しない」にしている。  
1. authorizedAlways  
いつでも位置情報が使える。
1. authorizedWhenInUse  
アプリが動いているときに使える（while running in the foreground）

### allowsBackgroundLocationUpdates
バックグラウンドモードでも位置情報を手に入れたい場合はこいつをtrueにしてやる必要がある。  
あと忘れちゃならないのが「TARGETS -> Capabilities -> Background Modes」をONにして、Location updatesにチェックを入れる必要がある。


## MapView
### showsUserLocation
MKMapViewのプロパティの一つ  
地図上にユーザの位置を表示させたいときはこれをtrueにする。デフォルトはfalseなので注意。  
storyboar上からも設定できる。(Attributes inspector -> Map View -> User Location)  

### userTrackingMode
MKMapViewのプロパティの一つ  
こいつの設定次第ではmap viewで地図の中心をユーザの場所にして、更新する。  
その設定はMKUserTrackingModeの中から選ぶ(こいつがenum)
1. none  : 追跡しない
1. follow  : 追跡する
1. followWithHeading  : 追跡するし、向いている方向も表示する

## 今後の予定
以下の項目はiOS11でアップデートされた機能を使う予定  
- コンパスを追加する(MKCompassButton)  
- スケールビューを追加する(MKScaleView)  
- ユーザトラッキングをMKUserTrackingButtonにする  
- mapにピンを立てる(MKMarkerAnnotationView)   

MKMarkerAnnotationViewに関しては様々な機能があるので色々試したい
