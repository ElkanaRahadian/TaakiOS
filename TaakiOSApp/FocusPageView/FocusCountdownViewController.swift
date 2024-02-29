import Foundation
import UIKit

protocol FocusCountdownViewControllerDelegate: class {
    func udpateViewBackAgain()
}

class FocusCountdownViewController : UIViewController, FinishedFocusViewControllerDelegate {
   

    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var startFinishButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    let timePicker = UIDatePicker()
    
    var timer : Timer = Timer()
    var count = 0
    var timerCounting = false
    var taskName = ""
    //
    var duration: Int!
    
    weak var delegate: FocusCountdownViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskNameLabel.text = taskName
        count = duration*60
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Would you like to end this focus session?", message: "All progress in this session will be lost", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Keep Focus", style: .cancel, handler: { (_) in }))
        alert.addAction(UIAlertAction(title: "End Focus", style: .destructive, handler: { (_) in
            self.count = 0
            self.timer.invalidate()
            self.countdownLabel.text = self.makeTimeString(hours: 0, minutes: 0, seconds: 0)
            self.startFinishButton.setTitle("Start", for: .normal)
            self.startFinishButton.setTitleColor(UIColor.green, for: .normal)
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func startFinishButton(_ sender: Any) {
        if startFinishButton.currentTitle == "Finish" {
            
            let alert = UIAlertController(title: "Finish focus session?", message: "You still have \(count/60) minute left", preferredStyle: .alert)
            timer.invalidate()
            alert.addAction(UIAlertAction(title: "Not Yet", style: .cancel, handler: { [self] (_) in
                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
            }))
            alert.addAction(UIAlertAction(title: "Finish Focus", style: .default, handler: { (_) in
                self.timer.invalidate()
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "FinishedFocus", bundle:nil)
                let congratulationController = storyBoard.instantiateViewController(withIdentifier: "congratulation") as! FinishedFocusViewController
                congratulationController.taskName = self.taskName
                congratulationController.delegate = self
                congratulationController.duration = self.duration
                congratulationController.modalPresentationStyle = .fullScreen
                
                self.present(congratulationController, animated:true, completion:nil)
            }))
                self.present(alert, animated: true, completion: nil)
        } else {
            
            guidedAccess()
            
            startFinishButton.setTitle("Finish", for: .normal)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
        }
    }

    @objc func timerCounter() {
        count -= 1
        let time = secondsToHoursMinutesSecond(seconds: count)
        let timeString = makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
        countdownLabel.text = timeString
        
        if count == 0 {
            guidedAccess()
            
            timer.invalidate()
            let alert = UIAlertController(title: "Time's up!", message: "You've finished your focus session", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Next", style: .default, handler: { (_) in
                let storyBoard : UIStoryboard = UIStoryboard(name: "FinishedFocus", bundle:nil)
                let congratulationController = storyBoard.instantiateViewController(withIdentifier: "congratulation") as! FinishedFocusViewController
                congratulationController.taskName = self.taskName
                congratulationController.duration = self.duration
                congratulationController.modalPresentationStyle = .fullScreen
                
                self.present(congratulationController, animated:true, completion:nil)
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    func guidedAccess() {
        if !UIAccessibility.isGuidedAccessEnabled {
            
            UIAccessibility.requestGuidedAccessSession(enabled: true) {
            success in
            print("Request guided access success \(success)")
            }
            
                
        } else {
            UIAccessibility.requestGuidedAccessSession(enabled: false) {
            success in
            print("Request guided access success \(success)")
            }
        }
        
        self.updateViewForGuidedAccess()
        let selector = #selector(updateViewForGuidedAccess)
    
        let names: [Notification.Name] = [
    //  UIAccessibility.guidedAccessStatusDidChangeNotification,
        UIAccessibility.guidedAccessDidAllowRestrictionNotification,
        UIAccessibility.guidedAccessDidDenyRestrictionNotification
        ]
    
        for name in names {
            NotificationCenter.default.addObserver(self, selector: selector, name: name, object: nil)
        }
    }
    
    func updateViewBack() {
        print("updateViewBack called")
        self.delegate?.udpateViewBackAgain()
    }
    
    // MARK: -

    @objc private func updateViewForGuidedAccess() {
        guard UIAccessibility.isGuidedAccessEnabled else { return }

        switch UIAccessibility.guidedAccessRestrictionState(forIdentifier: Restriction.focus.rawValue) {
        case .allow:
//        registerObeserver()
            startFinishButton.isEnabled = false
            startFinishButton.isHidden = true

            startFinishButton.isEnabled = false
            startFinishButton.isHidden = true
        case .deny:
            startFinishButton.isEnabled = true
            startFinishButton.isHidden = false

            cancelButton.isEnabled = true
            cancelButton.isHidden = false
        @unknown default:
            break
        }
    }

    func secondsToHoursMinutesSecond(seconds : Int) -> (Int,Int, Int) {
        return (seconds / 3600, ((seconds % 3600) / 60), ((seconds % 3600) % 60))
    }

    func makeTimeString(hours: Int, minutes: Int, seconds: Int) -> String {
        var timeString = ""
        timeString += String(format: "%02d", hours)
        timeString += ":"
        timeString += String(format: "%02d", minutes)
        timeString += ":"
        timeString += String(format: "%02d", seconds)
        return timeString
    }
}

enum Restriction: String, CaseIterable {
    case focus = "Focus"
}

extension Restriction {
    var text: String {
        switch self {
        case .focus:
            return NSLocalizedString("Focus", comment: "Focus")
        }
    }
}

// MARK: - UIGuidedAccessRestrictionDelegate

extension FocusCountdownViewController: UIGuidedAccessRestrictionDelegate {
    var guidedAccessRestrictionIdentifiers: [String]? {
        return Restriction.allCases.map { $0.rawValue }
    }

    func textForGuidedAccessRestriction(withIdentifier restrictionIdentifier: String) -> String? {
        return Restriction(rawValue: restrictionIdentifier)?.text
    }

    func guidedAccessRestriction(withIdentifier restrictionIdentifier: String, didChange newRestrictionState: UIAccessibility.GuidedAccessRestrictionState) {
            let notification: Notification

            switch newRestrictionState {
            case .allow:
                notification = Notification(name: UIAccessibility.guidedAccessDidAllowRestrictionNotification, object: restrictionIdentifier)
            case .deny:
                notification = Notification(name: UIAccessibility.guidedAccessDidDenyRestrictionNotification, object: restrictionIdentifier)
            @unknown default:
                // Switch covers known cases,
                // but 'UIAccessibility.GuidedAccessRestrictionState'
                // may have additional unknown values,
                // possibly added in future versions
                return
            }

            NotificationCenter.default.post(notification)
        }
}

extension UIAccessibility {
    static let guidedAccessDidAllowRestrictionNotification = NSNotification.Name("allow-restriction")

    static let guidedAccessDidDenyRestrictionNotification = NSNotification.Name("deny-restriction")
}


