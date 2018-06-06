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
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // 消費電力高め
        
        mapView.showsUserLocation = true
        mapView.userTrackingMode = MKUserTrackingMode.follow
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tappedMyLocationButton(_ sender: Any) {
        mapView.userTrackingMode = MKUserTrackingMode.follow
        mapView.setCenter(mapView.userLocation.coordinate, animated: true)
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    
    // 権限の状態について確認する
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            // 未選択なので、許可アラートを出す
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
