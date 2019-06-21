import UIKit

class DetailViewController: UITableViewController{
    var transport_data: [(String, String, String, String)] = [
        ("55번", "소사 SK", "역곡역", "8분"),
        ("용산 급행", "역곡역", "신도림역", "15분"),
        ("외선순환", "신도림역", "삼성역", "37분"),
    ]
    lazy var list: [Transportation] = {
        var datalist = [Transportation]()
        for (name, depart, dest, time) in self.transport_data {
            let tsp = Transportation()
            tsp.name = name
            tsp.depart = depart
            tsp.dest = dest
            tsp.spending_time = time
            datalist.append(tsp)
        }
        return datalist
    }()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let row = self.list[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TSPCell")!
        
        let name = cell.viewWithTag(105) as? UILabel
        let depart = cell.viewWithTag(106) as? UILabel
        let dest = cell.viewWithTag(107) as? UILabel
        let time = cell.viewWithTag(108) as? UILabel
        
        name?.text = row.name
        depart?.text = row.depart
        dest?.text = row.dest
        time?.text = row.spending_time
        
        return cell
    }
    
    override func viewDidLoad() {
    }
    @IBAction func on_back(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
}
