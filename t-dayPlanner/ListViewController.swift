import UIKit
class ListViewController: UITableViewController {
    var dataset = [
        ("삼성역", "하이퍼커넥트", "06/20", "11:00"),
        ("신촌역", "현대백화점", "06/23", "13:30"),
        ("사당역", "11번출구", "06/20", "18:00"),
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
    
    override func viewDidLoad() {
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let row = self.list[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell")!
        
        let place = cell.viewWithTag(101) as? UILabel
        let detail_place = cell.viewWithTag(102) as? UILabel
        let date = cell.viewWithTag(103) as? UILabel
        let hour = cell.viewWithTag(104) as? UILabel
        
        place?.text = row.place
        detail_place?.text = row.detail_place
        date?.text = row.date
        hour?.text = row.hour
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let dvc = self.storyboard?.instantiateViewController(withIdentifier: "DVC") as? DetailViewController else {
            return
        }
        NSLog("going in !")
        self.present(dvc, animated: true)
    }
    @IBAction func add(_ sender: Any) {
        guard let avc = self.storyboard?.instantiateViewController(withIdentifier: "AVC") as? AddViewController else {
            return
        }
        self.present(avc, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
}
