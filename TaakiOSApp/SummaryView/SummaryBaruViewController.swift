import UIKit

class SummaryBaruViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var summaryTableView: UITableView!
    
    let sections = ["Statistik", "Daily Goals", "Badges"]
    let detail = [
        ["Total Minutes", "Daily Streak"],
        ["Set Daily Goals"],
        ["Badges1", "Badges2", "Badges3", "Badges4", "Badges5"]
    ]
    
//    private let summaryTableView: UITableView = {
//        let summaryTable = UITableView()
//        summaryTable.register(SummaryBaruCell.self, forCellReuseIdentifier: SummaryBaruCell.identifier)
//
//        return summaryTable
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        summaryTableView.delegate = self
        summaryTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detail[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
        cell.textLabel?.text = detail[indexPath.section][indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.blue
        
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected detail is \(detail[indexPath.section][indexPath.row])")
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//            return 113
//    }
//
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let badgesCell = tableView.dequeueReusableCell(withIdentifier: "badgesCellIdentifier", for: indexPath) as? BadgesTableViewCell
//
//        badgesCell?.badgesTitleLabel.text = badgesTitle[indexPath.row]
//        badgesCell?.badgesDetailLabel.text = badgesDetail[indexPath.row]
//        badgesCell?.badgesProgressDetail.text = progressDetail[indexPath.row]
//        badgesCell?.badgesProgressView.transform.scaledBy(x: 10, y: 20) //gk berfungsi
//        badgesCell?.layer.borderColor = #colorLiteral(red: 0.9333333333, green: 0.9843137255, blue: 0.9882352941, alpha: 1)
//        badgesCell?.layer.borderWidth = 5
//        badgesCell?.layer.cornerRadius = 10
//        badgesCell?.clipsToBounds = true
////
//        return badgesCell!
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
