//
//  TaskAddNewTaskViewController.swift
//  TaakiOSApp
//
//  Created by Apriliani Putri Prasetyo on 11/04/21.
//

import UIKit

protocol TaskAddNewTaskViewControllerDelegate: class { // this blueprint needed as our bridge between this view controller to other view controller who subscribed it
    func updatePendingTask(newData: [TaskModel])
}

class TaskAddNewTaskViewController: UIViewController {

    @IBOutlet weak var taskNameField: UITextField!
    @IBOutlet weak var estimateDurationView: UIView!
    @IBOutlet weak var durationTextField: UITextField!
    let timePicker = UIDatePicker()
    
    var taskCollectionPending: [TaskModel]?
    
    weak var delegate: TaskAddNewTaskViewControllerDelegate? // we need to create an instance for it's delegate so this delegate can be used by other view controller
    
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
//        let storyBoard : UIStoryboard = UIStoryboard(name: "TaskView", bundle:nil)
//        let taskViewController = storyBoard.instantiateViewController(withIdentifier: "listTask") as! TaskViewController
//        taskViewController.statusSegment = "PENDING"
//        taskViewController.taskCollectionPending.append(TaskModel(taskName: taskNameField.text!, estimateDuration: Int(timePicker.countDownDuration)/60, status: "PENDING"))
//
//        taskViewController.modalPresentationStyle = .fullScreen
//        self.present(taskViewController, animated: true, completion: nil)
        
        if taskNameField.text! == "" || Int(timePicker.countDownDuration) == 0 {
            let alert = UIAlertController(title: "Warning", message: "Please complete all the necessary fields", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        } else {
            taskCollectionPending!.append(TaskModel(taskName: taskNameField.text!, estimateDuration: Int(timePicker.countDownDuration)/60, status: "PENDING"))
            self.delegate?.updatePendingTask(newData: taskCollectionPending!) // this will triger the delegate function and pass the data, so other view controller who subscribe the delegate from this view controller will have an update too
            self.dismiss(animated: true, completion: nil)
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

extension TaskAddNewTaskViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
