import UIKit

class newMainViewController: UIViewController{
    
    @IBAction func add(_ sender: Any) {
        guard let tcvc = self.storyboard?.instantiateViewController(withIdentifier: "TCVC") as? TypingCollectionViewController else {
            return
        }
        self.present(tcvc, animated: true)
    }
    
    @IBOutlet var tableview: UITableView!
    
    var dataset = [
        ("신촌", "현대백화점", "7/21", "2PM"),
        ("을지로역", "패런타워", "7/25", "7PM"),
        ("사당역", "11번출구", "7/27", "3PM"),
    ]
    
    lazy var list: [RideInfo] = {
        var datalist = [RideInfo]()
        for (place, detail_place, date, hour) in self.dataset {
            let rio = RideInfo()
            rio.place = place
            rio.detail_place = detail_place
            rio.date = date
            rio.hour = hour
            datalist.append(rio)
        }
        return datalist
    }()
    override func viewWillAppear(_ animated: Bool) {
        self.tableview.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.reloadData()
    }
}
extension newMainViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let row = self.list[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell")!
        
        // let place = cell.viewWithTag(101) as? UILabel
        let detail_place = cell.viewWithTag(102) as? UILabel
        let date = cell.viewWithTag(103) as? UILabel
        let hour = cell.viewWithTag(104) as? UILabel
        
        // place?.text = row.place! + " " + row.detail_place!
        detail_place?.text = row.place! + " " + row.detail_place!
        date?.text = row.date
        hour?.text = row.hour
        
        //cell.layer.borderColor = UIColor.black.cgColor
        //cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 10
        cell.clipsToBounds = true
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(10)
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
}
extension newMainViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("\(indexPath.row)번째 데이터가 클릭됨")
    }
}
