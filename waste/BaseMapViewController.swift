//
//  ViewControllerMap.swift
//  waste
//
//  Created by Николай Мартынов on 23.05.2023.
//

import UIKit
import YandexMapsMobile

class BaseMapViewController: UIViewController {

    
    @IBOutlet weak var baseMapView: BaseMapView!
    
    var mapView: YMKMapView! {
        get {
            return baseMapView.mapView
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
//        mapView.mapWindow.map.move(
//            with: YMKCameraPosition.init(target: YMKPoint(latitude: 55.751574, longitude: 37.573856), zoom: 15, azimuth: 0, tilt: 0),
//            animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 5),
//            cameraCallback: nil)
    
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
