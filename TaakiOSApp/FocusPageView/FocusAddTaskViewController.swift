import Foundation
import UIKit

protocol FocusAddTaskViewControllerDelegate: class {
    func updateAgainForLastTime()
}

class FocusAddTaskViewController: UIViewController, FocusCountdownViewControllerDelegate {
    
    
    @IBOutlet weak var taskNameField: UITextField!
    @IBOutlet weak var estimateDurationView: UIView!
    @IBOutlet weak var durationTextField: UITextField!
    let timePicker = UIDatePicker()
    
    weak var delegate: FocusAddTaskViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskNameField.delegate = self
        taskNameField.autocorrectionType = UITextAutocorrectionType.no
        
        createDurationPicker()
        estimateDurationView.layer.cornerRadius = 9.0
    }
    
    @IBAction func addTaskCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addTaskAddButton(_ sender: Any) {
        self.performSegue(withIdentifier: "focusCountdownSegue", sender: self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        taskNameField.resignFirstResponder()
    }
    
    func createToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: true)
        return toolbar
    }
    
    func createDurationPicker() {
        timePicker.preferredDatePickerStyle = .wheels
        timePicker.datePickerMode = .countDownTimer
        durationTextField.inputView = timePicker
        durationTextField.inputAccessoryView = createToolbar()
    }
    
    @objc func donePressed() {
        self.durationTextField.text = "\(Int(timePicker.countDownDuration)/60) min"
        self.view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? FocusCountdownViewController {
            destinationVC.taskName = "\(taskNameField.text ?? "")"
            destinationVC.delegate = self
            destinationVC.duration = Int(timePicker.countDownDuration)/60
        }
    }
    
    func udpateViewBackAgain() {
        self.delegate?.updateAgainForLastTime()
    }
    
}

extension FocusAddTaskViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
