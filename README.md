# MapApp

## Overview
MapViewとCoreLocationについての使い方の確認プロジェクト  
MapViewはただの地図で、その上にユーザの位置情報とかを扱いたいんだったらCoreLocationを使えって話。  
ここでは位置情報の利用を「常に許可」にする。  

自分の実行環境

|  Name  |  Version  |  
| :--- | :--- |  
|  Xcode  |  9.4  |  
|  Swift  |  4.1  |  
| iOS | 11.4 |  

## Description
現状は位置情報の利用を認証して現在地を取得して追従させているだけ。  
位置情報の利用権限まわりがややこしかった。  
以下に書くのはただの感想的なメモなので、特に読まなくていいです。  

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
ここでのステータスは5つある -> [CLAuthorizationStatus](https://developer.apple.com/documentation/corelocation/clauthorizationstatus)  
以下の二つは両方位置情報が使えないけど、若干違うっぽい
- restricted  
こっちは多分利用制限で使えない。  
- denied  
こっちはユーザが明示的にこのアプリに対して利用を「許可しない」にしている。  

### allowsBackgroundLocationUpdates
バックグラウンドモードでも位置情報を手に入れたい場合はこいつをtrueにしてやる必要がある。  
あと忘れちゃならないのが「TARGETS -> Capabilities -> Background Modes」をONにして、Location updatesにチェックを入れる必要がある。

### desiredAccuracy
ナビゲーションのタイプを決めて、位置情報の更新頻度を決める -> [CLActivityType](https://developer.apple.com/documentation/corelocation/clactivitytype)


### desiredAccuracy
位置情報の精度を決めるプロパティ  -> [CLLocationAccuracy](https://developer.apple.com/documentation/corelocation/cllocationaccuracy)  
精度がいいほど電池消費量が多いらしい

## MapView
### showsUserLocation
地図上にユーザの位置を表示させたいときはこれをtrueにする。デフォルトはfalseなので注意。  
storyboar上からも設定できる。(Attributes inspector -> Map View -> User Location)  

### userTrackingMode
こいつの設定でmapViewの中心をユーザの場所するか決める -> [MKUserTrackingMode](https://developer.apple.com/documentation/mapkit/mkusertrackingmode)  
followWithHeadingは追跡するし、向いている方向も表示する

### MKUserTrackingButton
ユーザがトラッキングのモードを変更できるボタン   
ただ、これを設置すると最初からトラッキングする設定が効かなくなる気がする。  
自分でボタン追加したほうがいいかも?

### MKCompassButton
コンパスのボタン  
自分でViewを追加することになるので、最初からマップにあるコンパスは見えないようにしよう  
compassVisibilityは表示オプションで、3種類ある -> [MKFeatureVisibility](https://developer.apple.com/documentation/mapkit/mkfeaturevisibility)  
- adaptive  
地図の上が北でないときに表示。タップしたら地図は北を向き、コンパスは非表示になる

### MKScaleView
地図のスケールを表示するView
legendAlignmentは表示オプションで、2種類ある。 -> [MKScaleView.Alignment](https://developer.apple.com/documentation/mapkit/mkscaleview/alignment)  
- leading  
0が左側にある
- trailing  
0が右側にある

## 今後の予定
- mapにピンを立てる(MKMarkerAnnotationView)   
MKMarkerAnnotationViewは様々な機能があるので色々試したい
