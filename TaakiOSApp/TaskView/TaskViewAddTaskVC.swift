import Foundation
import UIKit

class TaskViewAddTaskVC : UIViewController {
    
    @IBOutlet weak var taskNameField: UITextField!
    @IBOutlet weak var estimateDurationView: UIView!
    @IBOutlet weak var durationTextField: UITextField!
    let timePicker = UIDatePicker()
    
    var newTask = [TaskModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskNameField.delegate = self
        createDurationPicker()
        estimateDurationView.layer.cornerRadius = 9.0
    }
    
    @IBAction func addTaskCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addTaskAddButton(_ sender: Any) {
        self.performSegue(withIdentifier: "taskViewSegue", sender: self)
//        dismiss(animated: true, completion: nil)
        addTask()
    }
    
    func addTask() {
        newTask.append(contentsOf: [TaskModel(taskName: taskNameField.text!, estimateDuration: Int(timePicker.countDownDuration)/60 , status: "PENDING")])
        print("\(newTask)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? TaskViewController {
            destinationVC.taskCollectionPending.append(contentsOf: newTask)
        }
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
    
}

extension TaskViewAddTaskVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
