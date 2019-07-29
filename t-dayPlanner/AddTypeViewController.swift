import UIKit
import NMapsMap

class AddTypeViewController: UIViewController{
    
    @IBAction func on_push(_ sender: Any) {
        guard let tcvc = self.storyboard?.instantiateViewController(withIdentifier: "TCVC") as? TypingCollectionViewController else {
            return
        }
        self.present(tcvc, animated: true)
        
    }
    @IBAction func on_back(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: false)
    }
    override func viewDidLoad() {
    }
}
