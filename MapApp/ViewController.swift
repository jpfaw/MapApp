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
    var count: Int = 0
    var userLocation: CLLocation!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Locarion Manager Settings
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.activityType = .automotiveNavigation
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        // Map View Settings
        mapView.delegate = self
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
        let scaleView = MKScaleView(mapView: mapView)
        scaleView.legendAlignment = .leading
        scaleView.frame = CGRect(x: 10, y: 30, width: scaleView.bounds.width, height: scaleView.bounds.height)
        view.addSubview(scaleView)
        
        // Annotation Settings
        let annotation = MKPointAnnotation()
        annotation.coordinate = userLocation.coordinate
        annotation.title = "title"
        annotation.subtitle = "subtitle"
        mapView.addAnnotation(annotation)
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
            userLocation = location
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("位置情報の取得に失敗")
    }

}

extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { // 自分の位置もピンになることを避ける
            return nil
        }
        let reuseIdentifier = "marker"
        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier){
            return annotationView
        } else {
            let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView.glyphText = nil // これで普通のピン
            annotationView.markerTintColor = UIColor.blue
            return annotationView
        }
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        // Annotationを追加するときに呼ばれる
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        // Annotationを選択すると呼ばれる
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        // Annotationの選択を解除すると呼ばれる
        // 他のAnnotationを選ぶときも呼ばれる その場合viewの中身は事前に選んでたMKAnnotationView
    }
}
