//
//  ViewController.swift
//  Subway_Air_Project
//
//  Created by 한연규 on 2017. 11. 4..
//
//

import UIKit
import MapKit
var item:[String:String] = [:]
var items:[[String:String]] = []
var inFo = ""
class ViewController: UIViewController, MKMapViewDelegate {
    
    
    @IBOutlet weak var segControl: UISegmentedControl!
    
    @IBOutlet weak var mapVIew: MKMapView!
    let listEndPoint = "http://opendata.busan.go.kr/openapi/service/IndoorAirQuality/getIndoorAirQualityByItem"
    let detailEndPoint = "http://opendata.busan.go.kr/openapi/service/IndoorAirQuality/getIndoorAirQualityByStation"
    let serviceKey = "tbkRHovJzFjj5nnamShOHKHBHo7AQ%2FzPRqfK0FEAttBG1Ky17MM90gULHixVa3bQTdkrVZJj6hBInHlOozfVxg%3D%3D"
    
//    if(segControl.selectedSegmentIndex == 0){
//    getList()
//    inFo = "미세먼지"
//    }else{
//    getNo2List()
//    inFo = "이산화질소"
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapVIew.delegate = self
        // pList data 가져오기
        let path = Bundle.main.path(forResource: "ViewPoint", ofType: "plist")
        print("path = \(String(describing: path))")
        let contents = NSArray(contentsOfFile: path!)
        print("contents = \(String(describing: contents))")
        var annotations = [MKPointAnnotation]()
        if(segControl.selectedSegmentIndex == 0){
            getList()
            inFo = "미세먼지"
        }else{
            getNo2List()
            inFo = "이산화질소"
        }
        if let myItems = contents {
            for i in myItems {
                //점 찍어서 나오려면 as anyobject 해줘야함
                let lat = (i as AnyObject).value(forKey: "lat")
                let long = (i as AnyObject).value(forKey: "long")
                let title = (i as AnyObject).value(forKey: "title")
                var subTitle = ""
                
                print("lat = \(String(describing: lat))")
                
                let annotation = MKPointAnnotation()
                //변환
                let myLat = (lat as! NSString).doubleValue
                let myLong = (long as! NSString).doubleValue
                //?는 닐이면 안하고 닐아니면 바로하고 컨디셔널 바인딩
                let myTitle = title as? String
                if myTitle == "서면역1호선대합실"{
                    subTitle = "현재\(inFo)수치: " + item["서면역1호선대합실"]!
                }else if myTitle == "남포역대합실"{
                    subTitle = "현재\(inFo)수치: " + item["남포역대합실"]!
                }else if myTitle == "사상역대합실"{
                    subTitle = "현재\(inFo)수치: " + item["사상역대합실"]!
                }else if myTitle == "수영역대합실"{
                    subTitle = "현재\(inFo)수치: " + item["수영역대합실"]!
                }else if myTitle == "동래역4호선대합실"{
                    subTitle = "현재\(inFo)수치: " + item["동래역4호선대합실"]!
                }else if myTitle == "덕천역대합실"{
                    subTitle = "현재\(inFo)수치: " + item["덕천역대합실"]!
                }else if myTitle == "미남역대합실"{
                    subTitle = "현재\(inFo)수치: " + item["미남역대합실"]!
                }else {
                    subTitle = "현재\(inFo)수치: " + item["연산역대합실"]!
                }
                annotation.coordinate.latitude = myLat
                annotation.coordinate.longitude = myLong
                annotation.title = myTitle
                annotation.subtitle = subTitle
                annotations.append(annotation)
                //핀마다 딜리게이트 다해줘야한다 포문
                mapVIew.delegate = self
                
            }
        }else{
            print("contents 는 nil!")
        }
        //보여주기전에 모든 핀의 틀을 다 나오게함
        mapVIew.showAnnotations(annotations, animated: true)
        mapVIew.addAnnotations(annotations)
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "MyPin"
        var  annotationView = mapVIew.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
//        if(segControl.selectedSegmentIndex == 0){
//            getList()
//        }else{
//            getNo2List()
//        }
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            //seg조건 시작
            if(segControl.selectedSegmentIndex == 0){
                
            
                if Int(item[annotation.title!!]!)!  > 50 && Int(item[annotation.title!!]!)! < 101{
                    annotationView?.pinTintColor = UIColor.orange
                    let leftIconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 53, height: 53))
                    leftIconView.image = UIImage(named: "image/bad.png")
                    annotationView?.leftCalloutAccessoryView = leftIconView
                
                }else if Int(item[annotation.title!!]!)! > 100{
                    annotationView?.pinTintColor = UIColor.red
                    let leftIconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 53, height: 53))
                    leftIconView.image = UIImage(named: "image/veryBad.png")
                    annotationView?.leftCalloutAccessoryView = leftIconView
                
                }else if Int(item[annotation.title!!]!)! > 30 && Int(item[annotation.title!!]!)! < 51{
                    annotationView?.pinTintColor = UIColor.green
                    let leftIconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 53, height: 53))
                    leftIconView.image = UIImage(named: "image/good.png")
                    annotationView?.leftCalloutAccessoryView = leftIconView
                }else{
                    annotationView?.pinTintColor = UIColor.blue
                    let leftIconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 53, height: 53))
                    leftIconView.image = UIImage(named: "image/veryGood.png")
                    annotationView?.leftCalloutAccessoryView = leftIconView
                }
                
            }else{//seg 조건
                if Double(item[annotation.title!!]!)!  > 0.059 && Double(item[annotation.title!!]!)! < 0.19{
                    annotationView?.pinTintColor = UIColor.orange
                    let leftIconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 53, height: 53))
                    leftIconView.image = UIImage(named: "image/bad.png")
                    annotationView?.leftCalloutAccessoryView = leftIconView
                    
                }else if Double(item[annotation.title!!]!)! > 0.2{
                    annotationView?.pinTintColor = UIColor.red
                    let leftIconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 53, height: 53))
                    leftIconView.image = UIImage(named: "image/veryBad.png")
                    annotationView?.leftCalloutAccessoryView = leftIconView
                    
                }else if Double(item[annotation.title!!]!)! > 0.029 && Double(item[annotation.title!!]!)! < 0.06{
                    annotationView?.pinTintColor = UIColor.green
                    let leftIconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 53, height: 53))
                    leftIconView.image = UIImage(named: "image/good.png")
                    annotationView?.leftCalloutAccessoryView = leftIconView
                }else{
                    annotationView?.pinTintColor = UIColor.blue
                    let leftIconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 53, height: 53))
                    leftIconView.image = UIImage(named: "image/veryGood.png")
                    annotationView?.leftCalloutAccessoryView = leftIconView
                }
            }//seg 조건
        }
        
        return annotationView
    }
    
    func getList(){
        
        let str = listEndPoint + "?serviceKey=\(serviceKey)&numOfRows=1&item=pm10"
        let parse = Parser()
        if let url = URL(string: str){
            if let parser = XMLParser(contentsOf: url){
                
                parser.delegate = parse
                
                let success = parser.parse()
                if success {
                    print("파싱성공")
                    print(items)
                }else{
                    print("파싱실패")
                }
            }
            
        }
    }
    func getNo2List(){
        
        let str = listEndPoint + "?serviceKey=\(serviceKey)&numOfRows=1&item=no2"
        let parse = Parser()
        if let url = URL(string: str){
            if let parser = XMLParser(contentsOf: url){
                
                parser.delegate = parse
                
                let success = parser.parse()
                if success {
                    print("파싱성공")
                    print(items)
                }else{
                    print("파싱실패")
                }
            }
            
        }
    }
    
    @IBAction func segPressed(_ sender: AnyObject) {
//        if(segControl.selectedSegmentIndex == 0){
//            viewDidLoad()
//        }else{
//            viewDidLoad()
//        }
    }
    @IBAction func segC(_ sender: Any) {
        viewDidLoad()
    }

    


}

