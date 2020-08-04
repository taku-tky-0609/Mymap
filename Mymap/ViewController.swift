//
//  ViewController.swift
//  Mymap
//
//  Created by 大川琢也 on 2020/08/04.
//  Copyright © 2020 大川琢也. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Text Fieldのdelegate通知先を設定
        inputText.delegate = self
    }


    @IBOutlet weak var inputText: UITextField!
    
    
    @IBOutlet weak var dispMap: MKMapView!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //keyboardを閉じる(1)
        textField.resignFirstResponder()
        
        //inpoutされた文字を取り出す(2)
        if let searchKey = textField.text{
            //入力された文字をでバックエリアに表示(3)
            print(searchKey)
            
            // CLGeocoder instanceを取得
            let geocoder = CLGeocoder()
            
            //入力された文字からlocation infoを取得
            geocoder.geocodeAddressString(searchKey, completionHandler: { (placemarks, error) in
                
                //location infoが存在する場合は、unwrapPlacementに取り出す(7)
                if let unwrapPlacemarks = placemarks {
                    
                    //１件目のinfoを取り出す(8)
                    if let firstPlacemark = unwrapPlacemarks.first {
                        
                        //location infoを取り出す(9)
                        if let location = firstPlacemark.location{
                            
                            //location infoから緯度経度をtargetCoordinateに取り出す(10)
                            let targetCoordinate = location.coordinate
                            
                            //緯度経度をでdebugエリアに表示(11)
                            print(targetCoordinate)
                            
                            //MKPointAnnotationインスタすを取得し、ピンを生成(12）
                            let pin = MKPointAnnotation()
                            
                            //ピンの置く場所に緯度経度を設定(13)
                            pin.coordinate = targetCoordinate
                            
                            //ピンのtitleを設定(14)
                            pin.title = searchKey
                            
                            //ピンを地図に置く(15)
                            self.dispMap.addAnnotation(pin)
                            
                            //緯度経度を中心にして半径500mの範囲を表示
                            self.dispMap.region = MKCoordinateRegion(center: targetCoordinate, latitudinalMeters: 500.0, longitudinalMeters: 500.0)
                            
                            
                            
                        }
                        
                    }
                }
            })
        }
        
        //デフォルト動作を行うのでtrueを返す(4)
        return true
    }
    
    @IBAction func changeMapButton(_ sender: Any) {
        //mapTypeプロパティー値をトグル
        //標準→航空写真→航空写真＋標準
        //→3D Flyover →3D Flyover+標準
        //→交通機関
        if dispMap.mapType == .standard {
            dispMap.mapType = .satellite
        } else if dispMap.mapType == .satellite {
            dispMap.mapType = .hybrid
        } else if dispMap.mapType == .hybrid {
            dispMap.mapType = .satelliteFlyover
        } else if dispMap.mapType == .satelliteFlyover {
            dispMap.mapType = .hybridFlyover
        } else if dispMap.mapType == .hybridFlyover {
            dispMap.mapType = .mutedStandard
        } else {
            dispMap.mapType = .standard
        }
    }
    
}

