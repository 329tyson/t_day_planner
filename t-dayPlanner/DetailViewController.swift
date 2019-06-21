import UIKit

class DetailViewController: UIViewController{
    var transport_data: [(String, String, String, String)] = [
        ("55번", "소사 SK", "역곡역", "8분"),
        ("용산", "역곡역", "신도림역", "15분"),
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
    var title_place: String = ""
    @IBOutlet var BIG_PLACE_LABEL: UILabel!
    @IBAction func on_back(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
    override func viewDidLoad() {
        self.BIG_PLACE_LABEL.text = title_place
        self.transport_data[2] = ("외선순환", "신도림역", title_place, "37분")
    }
}
extension DetailViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = self.list[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TSPCell")!
        
        let name = cell.viewWithTag(105) as? UILabel
        let depart = cell.viewWithTag(106) as? UILabel
        let dest = cell.viewWithTag(107) as? UILabel
        let spending_time = cell.viewWithTag(108) as? UILabel
        
        name?.text = row.name
        depart?.text = row.depart
        dest?.text = row.dest
        spending_time?.text = row.spending_time
        
        return cell
    }
    
}
extension DetailViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("\(indexPath.row)번째 데이터가 클릭됨")
    }
}
