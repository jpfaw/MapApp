//
//  ViewController.swift
//  MapApp
//
//  Created by Yuta on 2018/06/05.
//  Copyright © 2018年 Yuta. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!

    var locationManager: CLLocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Locarion Manager Settings
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.activityType = .automotiveNavigation
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        // Map View Settings
        mapView.showsUserLocation = true
        mapView.userTrackingMode = MKUserTrackingMode.follow

        // screen Size
        let screenWidth:CGFloat = self.view.frame.width
        let screenHeight:CGFloat = self.view.frame.height

        // User Tracking Button
        let trackingButton = MKUserTrackingButton(mapView: mapView)
        let size:CGFloat = 35
        let margin: CGFloat = 10
        trackingButton.frame = CGRect(x: screenWidth-size-margin, y: screenHeight-size-margin,
                                      width: trackingButton.bounds.width, height: trackingButton.bounds.height)
        view.addSubview(trackingButton)

        // Compass Button
        mapView.showsCompass = false
        let compassButton = MKCompassButton(mapView: mapView)
        compassButton.compassVisibility = .adaptive
        compassButton.frame = CGRect(x: screenWidth-40, y: 30,
                                     width: compassButton.bounds.width, height: compassButton.bounds.height)
        view.addSubview(compassButton)

        // Scale View
        let scale = MKScaleView(mapView: mapView)
        scale.legendAlignment = .leading
        scale.frame = CGRect(x: 10, y: 30, width: scale.bounds.width, height: scale.bounds.height)
        view.addSubview(scale)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: CLLocationManagerDelegate {

    // 権限の状態について確認する
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            // 未選択なので、許可アラートを出す(アラートは別実装）
            locationManager.requestAlwaysAuthorization()
        case .restricted:
            pushAlert(title: "位置情報が利用できません", message: "位置情報を取得できません")
            
        case .denied:
            pushAlert(title: "位置情報利用が「許可しない」設定になっています",
                      message: "設定 > プライバシー > 位置情報サービス > MapApp で、位置情報サービスの利用を許可して下さい")
        case .authorizedAlways:
            print("常に使える")
            locationManager.startUpdatingLocation()
        case .authorizedWhenInUse:
            print("起動時は使える")
            locationManager.startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        for location in locations {
            // 日本時間を表示させる
            let df = DateFormatter()
            df.dateFormat = "yyyy/MM/dd HH:mm:ss.SSS"
            print("緯度:\(location.coordinate.latitude) 経度:\(location.coordinate.longitude) 取得時刻:\(df.string(from: location.timestamp))")
        }
    }
}
