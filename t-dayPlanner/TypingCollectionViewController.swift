import UIKit

class TypingCollectionViewController: UIViewController{
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var submitButton: UIButton!
    @IBOutlet var on_home: UIButton!
    @IBOutlet var on_school: UIButton!
    @IBAction func homeButton(_ sender: UIButton) {
        if(sender.alpha == 1){
            sender.alpha = 0.3
        }
        else {
            sender.alpha = 1
        }
    }
    var time_to_return = ""
    @IBAction func schoolButton(_ sender: UIButton) {
        if(sender.alpha == 1){
            sender.alpha = 0.3
        }
        else {
            sender.alpha = 1
        }
    }
    @IBAction func on_submit(_ sender: UIButton!){
        NSLog("Search \(self.place_to_search)")
        
        guard let smvc = self.storyboard?.instantiateViewController(withIdentifier: "SMVC") as? ShowMapController
        else {
            return
        }
        if self.on_home.alpha > 0.5{
            smvc.from_home = true
        }
        smvc.search_query = self.place_to_search
        smvc.place = ""
        smvc.detail_place = self.place_to_search
        smvc.hour = self.time_to_return
        smvc.date = self.time_to_return
        self.present(smvc, animated: true)
    }
    
    struct Argparse : Codable {
        var place : [String]
        var time : [String]
        var restaurant: [String]
        var intent: String
        
    }
    var info = Argparse(place:[], time:[], restaurant: [], intent:"")
    var place_to_search = ""
    var is_place_more_than_zero: Int?
    
    lazy var list: [String] = {
        var datalist: [String] = []
        for str in self.info.place{
            datalist.append(str)
        }
        for str in self.info.time{
            datalist.append(str)
        }
        for str in self.info.restaurant{
            datalist.append(str)
        }
        
        return datalist
    }()
    
    lazy var place_length = self.info.place.count
    lazy var time_length = self.info.time.count + self.place_length
    lazy var restaurant_length = self.info.restaurant.count + self.time_length
    
    @IBOutlet var plan_string: UITextField!
    
    @IBAction func on_back(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: false)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.sendSubviewToBack(self.collectionView)
        let lineView = UIView(frame: CGRect(x: 0, y: 133, width: 400, height: 1.0))
        lineView.layer.borderWidth = 1.0
        lineView.layer.borderColor = UIColor(red: 194/255, green: 194/255, blue: 194/255, alpha: 0.5).cgColor
        self.view.addSubview(lineView)
        plan_string.delegate = self
        plan_string.layer.borderWidth = 1
        plan_string.layer.borderColor = UIColor.white.cgColor
        on_home.layer.cornerRadius = 15
        on_school.layer.cornerRadius = 15
        
        
        //self.submitButton.backgroundColor = UIColor(red:(142.0/255.0), green:(226.0/255.0), blue:(184.0/255.0), alpha:(1.0))
        self.submitButton.frame = CGRect(x: 305, y: 550, width: 60, height: 60)
        self.submitButton.layer.cornerRadius = 0.5 * self.submitButton.bounds.size.width
        self.submitButton.clipsToBounds = true
        self.submitButton.setTitleColor(UIColor.white, for:.normal)
    }
    
    
}

extension TypingCollectionViewController: UICollectionViewDataSource{
    
    @objc func pressed(sender: UIButton!) {
        if(sender.alpha == 1){
            sender.alpha = 0.3
        }
        else {
            sender.alpha = 1
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        NSLog("self.list : \(self.list)")
        return self.list.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = self.list[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath)
        
        
        NSLog("Rendering row: \(indexPath.row) String: \(row)")
        
        let button = cell.viewWithTag(100) as? UIButton
        button?.setTitle(row, for: .normal)
        button?.layer.cornerRadius = 15
        
        //button?.frame.size.width = CGFloat(Float(row.utf8.count) * 15)
        //let rgbValue = 0x9D0F93
        button?.backgroundColor = UIColor.white
        button?.alpha = 0.3
        button?.addTarget(self, action: #selector(pressed), for: .touchUpInside)
        
        return cell
    }
    
}

extension TypingCollectionViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NSLog("\(indexPath.row)번째 데이터가 클릭됨")
    }
}

extension TypingCollectionViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        
        let search_from = "http://172.20.10.2:5000/predict?input_text="
        //let search_from = "http://10.0.100.56:5000/predict?input_text="
        let query = search_from + textField.text!
        let query_hangeul = query.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        guard let url = URL(string: query_hangeul) else {return false}
        NSLog("query_string : \(String(query))")
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else {
                NSLog("Error getting response")
                return
            }
            NSLog("got data, going String")
            let res = String(data: data, encoding: .utf8)!
            NSLog("got data : \(res)")
            
            let decoder = JSONDecoder()
            let string_data = res.data(using: .utf8)
            
            if let data = string_data, let parsed = try? decoder.decode(Argparse.self, from: data) {
                NSLog("saving --> \(parsed))")
                self.list = []
                self.place_to_search = ""
                self.time_to_return = ""
                
                for str in parsed.place{
                    self.list.append(str)
                }
                for str in parsed.time{
                    self.list.append(str)
                    self.time_to_return += " " + str
                }
                for str in parsed.restaurant{
                    self.list.append(str)
                }
                
                self.place_to_search = parsed.place[0]
                if parsed.restaurant.count > 0 {
                    self.place_to_search += " " + parsed.restaurant[0]
                }
                
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.on_home.isHidden = false
                    self.on_school.isHidden = false
                    self.submitButton.isHidden = false
                }
            }
        }
        task.resume()
        return true;
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
}
