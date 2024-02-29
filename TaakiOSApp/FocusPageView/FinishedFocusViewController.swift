//
//  FinishedFocusViewController.swift
//  TaakiOSApp
//
//  Created by Apriliani Putri Prasetyo on 13/04/21.
//

import UIKit

protocol FinishedFocusViewControllerDelegate: class  {
    func updateViewBack()
}

class FinishedFocusViewController: UIViewController {

    var taskName = ""
    var duration = 0
    var status = "DONE"
//    let value = TaskViewController.taskCollectionDone.map(TaskModel)
    
    weak var delegate: FinishedFocusViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.performSegue(withIdentifier: "showListDone", sender: self)
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? TaskViewController {
            destinationVC.statusSegment = "DONE"
            TaskViewController.taskCollectionDone.append(TaskModel(taskName: taskName, estimateDuration: duration, status: status))
        }
    }

    @IBAction func dismissToRoot(_ sender: UIButton) {
        self.delegate?.updateViewBack()
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
}
