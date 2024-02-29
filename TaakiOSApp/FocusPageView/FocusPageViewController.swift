import Foundation
import UIKit

class FocusPageViewController : UIViewController, FocusAddTaskViewControllerDelegate, FocusCountdownViewControllerDelegate {
    func udpateViewBackAgain() {
        print("udpateViewBackAgain being called")
    }
    
    func updateAgainForLastTime() {
        self.tabBarController?.selectedIndex = 1
        print("updateAgainForLastTime being called")
    }
    
    @IBOutlet weak var dailyGoalDetailLabel: UILabel!
    
//    let passValue = SummaryViewController.valueDailyGoal
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func toAddAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toAddTask", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segueDest = segue.destination as? FocusAddTaskViewController {
            segueDest.delegate = self
        }
    }
}
