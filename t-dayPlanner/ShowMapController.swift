import UIKit
import NMapsMap
import MapKit
import CoreLocation
import SwiftyJSON

class ShowMapController: UIViewController, CLLocationManagerDelegate{
    let locationManager = CLLocationManager()
    lazy var coord: NMGLatLng? = {
        guard let locValue = locationManager.location?.coordinate else {return NMGLatLng(lat: 37.506178189485226, lng:127.03080567893957)}
        if from_home == false{
            return NMGLatLng(lat: locValue.latitude, lng: locValue.longitude)
        }
        else{
            return NMGLatLng(lat: 37.4802924, lng: 126.80001700000003)
        }
    }()
    
    
    @IBAction func on_back(_ sender: Any) { self.presentingViewController?.dismiss(animated: false)
    }
    //var search_coord: NMGLatLng?
    var from_home: Bool? = false
    var search_query: String? = "수원터미널"
    var dest_lat: Double? = 37.506178189485226
    var dest_lng: Double? = 127.03080567893957
    var dest_name: String? = ""
    
    var place: String?
    var detail_place: String?
    var date: String?
    var hour: String?
    
    
    @IBOutlet var mapview: NMFMapView!
    @IBAction func ons_submit(_ sender: UIButton!) {
        let tcvc = self.presentingViewController
        let nmvc = tcvc?.presentingViewController
        
        let rio = RideInfo()
        rio.place = self.place
        rio.date = self.date
        rio.hour = ""
        rio.detail_place = self.detail_place
        
        guard let vc = nmvc as? newMainViewController else{
            return
        }
        vc.list.append(rio)
        vc.dismiss(animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dest_lat = 37.506178189485226
        self.dest_lng = 127.03080567893957
        self.dest_name = ""
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        moveCamera(coordinate: self.coord!)
        get_search_locations()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        //print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    func get_search_locations(){
        let search_query_full = "https://naveropenapi.apigw.ntruss.com/map-place/v1/search?query=" + self.search_query! + "&coordinate=127.0,37.5"
        
        let query_hangeul = search_query_full.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        guard let url = URL(string: query_hangeul) else {return}
        NSLog("query_string : \(String(query_hangeul))")
        var url_request = URLRequest(url : url)
        url_request.httpMethod = "get"
        url_request.allHTTPHeaderFields?.updateValue("eqdu8bj65q", forKey: "X-NCP-APIGW-API-KEY-ID")
        url_request.allHTTPHeaderFields?.updateValue("4XHNZylwMB9Xg6yoaVoNU5AFGU4NSnVr9SwBu1Um", forKey: "X-NCP-APIGW-API-KEY")
        
        let task = URLSession.shared.dataTask(with: url_request) {(data, response, error) in
            guard let data = data else { return }
            do{
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    data, options: [])
                
                guard let jsonArray = jsonResponse as? [String: Any] else {
                    return
                }
                guard let places = jsonArray["places"] as? [[String: Any]] else{
                    print("failed")
                    return
                }
                guard let meta = jsonArray["meta"] as? [String: Int] else{
                    print("Error total count")
                    return
                }
                if meta["count"]! != 0 {
                    self.dest_lat = (places[0]["y"] as! NSString).doubleValue
                    self.dest_lng = (places[0]["x"] as! NSString).doubleValue
                    self.dest_name = (places[0]["name"] as! String)
                }
                else{
                    print("error counting")
                    self.presentingViewController?.dismiss(animated: false)
                    return
                }
                
                //self.update_coord = NMGLatLng(lat: _lat, lng: _lng)
                
            } catch let parsingError {
                print("Error", parsingError)
            }
            
            DispatchQueue.main.async {
                
                self.figure_path(lat: self.dest_lat!, lng: self.dest_lng!, name: self.dest_name!)
            }
            
        }
        
        task.resume()
    }
    
    func moveCamera(coordinate: NMGLatLng){
        let cameraUpdate = NMFCameraUpdate(scrollTo: coordinate)
        cameraUpdate.reason = 3
        cameraUpdate.animation = .fly
        cameraUpdate.animationDuration = 0.5
        self.mapview.moveCamera(cameraUpdate, completion: { (isCancelled) in
            if isCancelled {
                print("카메라 이동 취소")
            } else {
                print("카메라 이동 성공")
            }
        })
    }
    
    func popplaces(places: [[String: Any]]){
        for place in places{
            let lat = (place["y"] as! NSString).doubleValue
            let lng = (place["x"] as! NSString).doubleValue
            let _cord = NMGLatLng(lat: lat, lng: lng)
            let marker = NMFMarker(position: _cord)
            marker.captionText = (place["name"] as! String)
            marker.mapView = self.mapview
        }
    }
    
    func figure_path(lat: Double, lng: Double, name: String){
        // from : current loc --> to :dest_coord
        let _cord = NMGLatLng(lat: lat, lng: lng)
        let marker = NMFMarker(position: _cord)
        marker.captionText = name
        marker.mapView = self.mapview
        
        let _start = self.coord!
        let start_marker = NMFMarker(position: _start)
        start_marker.captionHaloColor = UIColor.blue
        start_marker.mapView = self.mapview
        NSLog("Tagging Done")
        
        let apikey = "MYJxBQumpVMU1DtGj4Eksg"
        ODsayService.sharedInst().setApiKey(apikey)
        ODsayService.sharedInst().setTimeout(5000)
        
        guard let locValue = locationManager.location?.coordinate else {return}
        var _sx = Double2String(double: locValue.longitude)
        var _sy = Double2String(double: locValue.latitude)
        
        if self.from_home == true{
            _sx = "126.80001700000003"
            _sy = "37.4802824"
        }
        let _ex = Double2String(double: lng)
        let _ey = Double2String(double: lat)
        
        var path_string : [(String, String)]?
        if self.from_home == false {
            path_string  = [("37.506178189485226", "127.03080567893957")]
        }
        else {
            path_string = [("37.4802924", "126.80001700000003")]
        }
        ODsayService.sharedInst().requestSearchPubTransPath(_sx, sy: _sy, ex: _ex, ey: _ey, opt: 0, searchType: 0, searchPathType: 0) { (retCode:Int32, resultDic:[AnyHashable : Any]?) in
            if retCode == 200 {
                NSLog("got path")
                guard let dictionary = resultDic as! [String: Any]? else {return}
                guard let result_dict = dictionary["result"] as! [String: Any]? else {return}
                guard let path_dict = result_dict["path"] as! NSArray? else {return}
                
                print("path_dict.count : \(path_dict.count)")
                    if(path_dict.count > 0){do{
                        let jsonResponse = try JSONSerialization.data(withJSONObject: path_dict, options: [])
                        let json = try JSON(data: jsonResponse)
                        
                        if let subpathList = json[0]["subPath"].array {
                            for subpath in subpathList {
                                if let stations = subpath["passStopList"]["stations"].array {
                                    for st in stations {
                                        print("adding \(st["x"].string!)")
                                        path_string!.append((st["y"].string!, st["x"].string!))
                                    }
                                }
                            }
                        }
                        /*let stations = json[0]["subPath"][1]["passStopList"]["stations"].array
                        for st in stations! {
                            print("adding \(st["x"].string!)")
                            path_string!.append((st["y"].string!, st["x"].string!))
                        }*/
                        
                    } catch let parsingError {
                        print("Error", parsingError)
                    }}
                
                DispatchQueue.main.async {
                    NSLog("inside Dispatch")
                    var path_list : [NMGLatLng]? = [self.coord!]
                    for (_lat, _lng) in path_string! {
                        let lat = Double(_lat)
                        let lng = Double(_lng)
                        path_list!.append(NMGLatLng(lat: lat!, lng: lng!))
                    }
                    path_list?.append(NMGLatLng(lat: lat, lng: lng))
                    let path = NMFPath(points: path_list!)
                    path!.color = UIColor.blue
                    path!.mapView = self.mapview
                    
                    let bounds = NMGLatLngBounds()
                    bounds.southWest = self.coord!
                    bounds.northEast = NMGLatLng(lat: lat, lng: lng)
                    let cameraUpdate = NMFCameraUpdate(fit: bounds, padding: CGFloat(60.0))
                    cameraUpdate.reason = 3
                    cameraUpdate.animation = .fly
                    cameraUpdate.animationDuration = 0.5
                    self.mapview.moveCamera(cameraUpdate, completion: { (isCancelled) in
                        if isCancelled {
                            print("카메라 이동 취소")
                        } else {
                            print("카메라 이동 성공")
                        }
                    })
                }
                
                }
            else {
                //print(resultDic!.description)
                var path_list : [NMGLatLng]? = [self.coord!]
                path_list?.append(NMGLatLng(lat: lat, lng: lng))
                let path = NMFPath(points: path_list!)
                path!.color = UIColor.blue
                path!.mapView = self.mapview
                
                let bounds = NMGLatLngBounds()
                bounds.southWest = self.coord!
                bounds.northEast = NMGLatLng(lat: lat, lng: lng)
                let cameraUpdate = NMFCameraUpdate(fit: bounds, padding: CGFloat(60.0))
                cameraUpdate.reason = 3
                cameraUpdate.animation = .fly
                cameraUpdate.animationDuration = 0.5
                self.mapview.moveCamera(cameraUpdate, completion: { (isCancelled) in
                    if isCancelled {
                        print("카메라 이동 취소")
                    } else {
                        print("카메라 이동 성공")
                    }
                })
            }
        }
        
    }
    
    func Double2String(double: Double?) -> String{
        return String(format:"%lf", double!)
    }
    
    func mDictToTextJson(rMDic:[AnyHashable : Any]?) -> String {
        if let sText = rMDic?.description {
            if let bytes = sText.cString(using: String.Encoding.ascii) {
                return String(cString: bytes, encoding: String.Encoding.nonLossyASCII)!
            } else {
                return "No Data is Displayed"
            }
        } else {
            return "No Data is Displayed"
        }
    }
}
