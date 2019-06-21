import UIKit

class TypingViewController: UIViewController, UITextFieldDelegate{
    @IBOutlet var type_plan: UITextField!
    
    @IBOutlet var firstButton: UIButton!
    @IBOutlet var secondButton: UIButton!
    @IBOutlet var thirdButton: UIButton!
    @IBOutlet var fourthButton: UIButton!
    @IBOutlet var fifthButton: UIButton!
    @IBOutlet var submitButton: UIButton!
    @IBAction func on_submit(_ sender: UIButton!){
        let rio = RideInfo()
        rio.place = self.fourthButton.title(for: .normal)
        rio.date = self.firstButton.title(for: .normal)
        rio.hour = self.secondButton.title(for: .normal)
        rio.detail_place = self.fifthButton.title(for: .normal)
        let lvc = self.presentingViewController
        let llvc = lvc?.presentingViewController
        guard let vc = llvc as? ListViewController else{
            return
        }
        vc.list.append(rio)
        vc.dismiss(animated: false)
    }
    @IBAction func on_back(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: false)
    }
    @IBAction func on_push(_ sender: UIButton) {
        if(sender.alpha == 1){
            sender.alpha = 0.3
        }
        else{
            sender.alpha = 1
        }
        let val = self.firstButton.alpha + self.secondButton.alpha + self.thirdButton.alpha + self.fourthButton.alpha + self.fifthButton.alpha
        NSLog("val : \(val)")
        if((val >= 4.3 && val < 4.4) || (val >= 3.6 && val < 3.7)){
            self.submitButton.backgroundColor = UIColor(red:(142.0/255.0), green:(226.0/255.0), blue:(184.0/255.0), alpha:(1.0))
            self.submitButton.setTitleColor(UIColor.white, for:.normal)
        }
        else{
            self.submitButton.backgroundColor = UIColor(red:(248.0/255.0), green:(248.0/255.0), blue:(248.0/255.0), alpha:(1.0))
            self.submitButton.setTitleColor(UIColor(red:(194.0/255.0), green:(194.0/255.0), blue:(194.0/255.0), alpha:(1.0)), for:.normal)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let lineView = UIView(frame: CGRect(x: 0, y: 133, width: 400, height: 1.0))
        lineView.layer.borderWidth = 1.0
        lineView.layer.borderColor = UIColor(red: 194/255, green: 194/255, blue: 194/255, alpha: 0.5).cgColor
        self.view.addSubview(lineView)
        type_plan.delegate = self
        type_plan.layer.borderWidth = 1
        type_plan.layer.borderColor = UIColor.white.cgColor
        self.firstButton.layer.cornerRadius = 20
        self.secondButton.layer.cornerRadius = 20
        self.thirdButton.layer.cornerRadius = 20
        self.fourthButton.layer.cornerRadius = 20
        self.fifthButton.layer.cornerRadius = 20
        self.submitButton.layer.cornerRadius = 20
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        sleep(2)
        self.firstButton.isHidden = false
        self.secondButton.isHidden = false
        self.thirdButton.isHidden = false
        self.fourthButton.isHidden = false
        self.fifthButton.isHidden = false
        self.firstButton.alpha = 0.3
        self.secondButton.alpha = 0.3
        self.thirdButton.alpha = 0.3
        self.fourthButton.alpha = 0.3
        self.fifthButton.alpha = 0.3
        return true;
    }
}
