import UIKit
import CoreData

class TaskViewController: UIViewController {
    
    @IBOutlet weak var taskSearchBar: UISearchBar!
    @IBOutlet weak var taskTableView: UITableView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBAction func statusSegmentedControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1:
            statusSegment = "DONE"
        default:
            statusSegment = "PENDING"
        }
        taskTableView.reloadData()
    }
    
    var duration = 0
    var image: UIImage?
    var filteredData = [TaskModel]()
    var searching = false
    var selectedIndex = 0
    var statusSegment: String = "PENDING"
    var taskCollectionPending: [TaskModel] = [TaskModel(taskName: "Hi-Fi Prototype", estimateDuration: 120, status: "PENDING"), TaskModel(taskName: "Final Project", estimateDuration: 150, status: "PENDING"), TaskModel(taskName: "Self Learning", estimateDuration: 60, status: "DONE")]
    static var taskCollectionDone: [TaskModel] = [TaskModel(taskName: "Lo-Fi Prototype", estimateDuration: 60, status: "DONE"), TaskModel(taskName: "Keynote Presentation", estimateDuration: 30, status: "DONE")]
    var taskName = ""
    static var instance = TaskViewController()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        configuration()
//        segmentedControl.selectedSegmentIndex = 1
    }
    
    func configuration() {

        taskTableView.delegate = self
        taskTableView.dataSource = self
        
        taskTableView.backgroundColor = #colorLiteral(red: 0.9359967113, green: 0.9867416024, blue: 0.9907793403, alpha: 1)
        taskTableView.backgroundView?.layer.cornerRadius = 10
        taskTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        taskSearchBar.delegate = self
        taskSearchBar.backgroundImage = UIImage()
    }
}

extension TaskViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if searching {

            return filteredData.count
        } else {
             if statusSegment == "DONE"{
                
                return TaskViewController.taskCollectionDone.count
             } else {
                
                return taskCollectionPending.count
             }
        }
        
    }

    // function show list task
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let taskCell = tableView.dequeueReusableCell(withIdentifier: "taskCellIdentifier", for: indexPath) as! TaskCell
        
        taskCell.layer.cornerRadius = 10
        taskCell.layer.borderWidth = 5
        taskCell.layer.borderColor = #colorLiteral(red: 0.9359967113, green: 0.9867416024, blue: 0.9907793403, alpha: 1)
        taskCell.backgroundColor = #colorLiteral(red: 0.737254902, green: 0.9254901961, blue: 0.9411764706, alpha: 1)
        taskCell.contentView.layer.cornerRadius = 10
        
        if searching {

            taskCell.taskTitleLabel.text = filteredData[indexPath.row].taskName
            taskCell.taskDurationLabel.text = "\(filteredData[indexPath.row].estimateDuration) min"
            searching = false
        } else {
            
            if statusSegment == "DONE"{
                
                taskCell.taskTitleLabel.text = TaskViewController.taskCollectionDone[indexPath.row].taskName
                taskCell.taskDurationLabel.text = "\(TaskViewController.taskCollectionDone[indexPath.row].estimateDuration) min"
            } else {
                
                if (taskCollectionPending[indexPath.row].pin) {
                    
                    let fullString = NSMutableAttributedString(string: "")
                    let image = NSTextAttachment()
                    image.image = UIImage(named: "pin-dark")
                    let imageString = NSAttributedString(attachment: image)

                    fullString.append(imageString)
                    fullString.append(NSAttributedString(string: "   \(taskCollectionPending[indexPath.row].estimateDuration) min"))
                    taskCell.taskDurationLabel.attributedText = fullString
                    taskCell.taskDurationLabel.textAlignment = .right
                } else {
                    
                    taskCell.taskDurationLabel.text = "\(taskCollectionPending[indexPath.row].estimateDuration) min"
                }
                
                taskCell.taskTitleLabel.text = taskCollectionPending[indexPath.row].taskName
            }

        }
        return taskCell
    }

    // function delete task
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    
        // Component Delete action
        let delete = UIContextualAction(style: .destructive, title: "", handler: { (action, view, onComplete) in
            
            print("Delete task: \(self.taskCollectionPending[indexPath.row].taskName)")
            self.taskCollectionPending.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        })
        
        delete.image = UIImage.init(named: "trash")
    
        if statusSegment == "PENDING" {
            
            let configuration = UISwipeActionsConfiguration(actions: [delete])
            return configuration
        } else {
            
            let configuration = UISwipeActionsConfiguration(actions: [])
            return configuration
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        // function pin task
        let pin = UIContextualAction(style: .normal, title: "", handler: { [self] (action, view, onComplete) in

            taskCollectionPending[indexPath.row].pin = true
            print("Pin task: \(self.taskCollectionPending[indexPath.row].taskName)")
            let element = self.taskCollectionPending.remove(at: indexPath.row)
            self.taskCollectionPending.insert(element, at: 0)
            taskTableView.reloadData()
        })
        
        // function unpin task
        let unpin = UIContextualAction(style: .normal, title: "", handler: { [self] (action, view, onComplete) in

            taskCollectionPending[indexPath.row].pin = false
            print("Unpin task: \(self.taskCollectionPending[indexPath.row].taskName)")
            let element = self.taskCollectionPending.remove(at: indexPath.row)
            self.taskCollectionPending.insert(element, at: taskCollectionPending.endIndex)
            taskTableView.reloadData()
        })
        
        pin.backgroundColor = #colorLiteral(red: 1, green: 0.8, blue: 0, alpha: 1)
        pin.image = UIImage.init(named: "pin")
        unpin.backgroundColor = #colorLiteral(red: 1, green: 0.8, blue: 0, alpha: 1)
        unpin.image = UIImage.init(named: "unpin")

        if statusSegment == "PENDING" {
            
            if taskCollectionPending[indexPath.row].pin {
                
                let configuration = UISwipeActionsConfiguration(actions: [unpin])
                return configuration
            } else {
                
                let configuration = UISwipeActionsConfiguration(actions: [pin])
                return configuration
            }
        } else {
            
            let configuration = UISwipeActionsConfiguration(actions: [])
            return configuration
        }
    }
    
    // function select task
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if statusSegment == "PENDING" {
            
            selectedIndex = indexPath.row
            taskName = taskCollectionPending[indexPath.row].taskName
            duration = taskCollectionPending[indexPath.row].estimateDuration
            
            print("Select task: \(taskCollectionPending[indexPath.row].taskName)")
            self.performSegue(withIdentifier: "focusCountdownSegue", sender: self)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? FocusCountdownViewController {
            destinationVC.taskName = "\(taskName)"
            destinationVC.duration = duration
        }
        if let addVC = segue.destination as? TaskAddNewTaskViewController {
            addVC.taskCollectionPending = self.taskCollectionPending
            addVC.delegate = self // subscribe TaskAddNewTaskViewController delegate, so by subscribing his delegate, we can sync the data changes from there within this TaskViewController.
        }
    }
    
}

extension TaskViewController: TaskAddNewTaskViewControllerDelegate { // Once we subscribe the delegate, we need to conform the protocol to sync the the data through the function provided
    func updatePendingTask(newData: [TaskModel]) {
        self.taskCollectionPending = newData
        taskTableView.reloadData()
    }
}

extension TaskViewController: UISearchBarDelegate {

    // MARK: SEARCH BAR CONFIG
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        filteredData = []
        
        if statusSegment == "DONE" {
            
            let taskNameArr = TaskViewController.taskCollectionDone.map{ $0.taskName }
            
            let taskArray = TaskViewController.taskCollectionDone
            if searchText == "" {

                filteredData = TaskViewController.taskCollectionDone
            } else {

                searching = true
                for taskName in 0..<taskNameArr.count {

                    if taskNameArr[taskName].lowercased().contains(searchText.lowercased()) {
                        filteredData.append(TaskModel(taskName: taskNameArr[taskName], estimateDuration: taskArray[taskName].estimateDuration, status: ""))
                    }
                }
            }
        } else {
            
            let taskNameArr = taskCollectionPending.map{ $0.taskName }
            
            let taskArray = taskCollectionPending
            if searchText == "" {

                filteredData = taskCollectionPending
            } else {

                searching = true
                for taskName in 0..<taskNameArr.count {

                    if taskNameArr[taskName].lowercased().contains(searchText.lowercased()) {
                        filteredData.append(TaskModel(taskName: taskNameArr[taskName], estimateDuration: taskArray[taskName].estimateDuration, status: ""))
                    }
                }
            }
        }

        taskTableView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searching = false
    }
}
