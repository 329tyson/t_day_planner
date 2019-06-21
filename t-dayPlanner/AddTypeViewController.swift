import UIKit

class AddTypeViewController: UIViewController{
    
    @IBAction func on_push(_ sender: Any) {
        guard let tvc = self.storyboard?.instantiateViewController(withIdentifier: "TVC") as? TypingViewController else {
            return
        }
        self.present(tvc, animated: false)
        
        
    }
    @IBAction func on_back(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: false)
    }
    override func viewDidLoad() {
    }
}
