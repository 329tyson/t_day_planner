import UIKit

class AddViewController: UIViewController, UITextFieldDelegate{
    var date: String?
    @IBOutlet var place_text: UITextField!
    @IBAction func on_calender_change(_ sender: UIDatePicker) {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM/dd hh:mm"
        self.date = dateformatter.string(from: sender.date)
    }
    @IBAction func on_back(_ sender: Any) {
        let pvc = self.presentingViewController
        guard let vc = pvc as? ListViewController else{
            return
        }
        let rio = RideInfo()
        var place = self.place_text.text?.components(separatedBy: " ")
        var date = self.date?.components(separatedBy: " ")
        rio.place = place?[0]
        rio.detail_place = place?[1]
        rio.date = date?[0]
        rio.hour = date?[1]
        
        vc.list.append(rio)
        self.presentingViewController?.dismiss(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        place_text.delegate = self
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true;
    }
    
}
