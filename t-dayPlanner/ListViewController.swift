import UIKit

class ListViewController: UITableViewController {
    
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
    
    override func viewDidLoad() {
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
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
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let dvc = self.storyboard?.instantiateViewController(withIdentifier: "DVC") as? DetailViewController else {
            return
        }
        let row = self.list[indexPath.row]
        dvc.title_place = row.place!
        self.present(dvc, animated: true)
    }
    
    @IBAction func add(_ sender: Any) {
        guard let atvc = self.storyboard?.instantiateViewController(withIdentifier: "ATVC") as? AddTypeViewController else {
            return
        }
        self.present(atvc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
}
