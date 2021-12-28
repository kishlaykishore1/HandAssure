//
//  SettingVC.swift
//  HandAssure
//
//  Created by kishlay kishore on 28/10/20.
//

import UIKit

class SettingVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var time1: Date?
    var time2: Date?
    var menuName = ["Profile", "Set Reminder"]
    let userDefault = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        self.title = "SETTINGS"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Poppins-Bold", size: 18) ?? UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor:#colorLiteral(red: 0.2470588235, green: 0.2470588235, blue: 0.2549019608, alpha: 1)]
        guard let t1 = userDefault.object(forKey: "wakeUpTime") as? Date else {
            return
        }
        guard let t2 = userDefault.object(forKey: "sleepingTime") as? Date else {
            return
        }
        time1 = t1
        time2 = t2
    }
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
}
//MARK:- TableView DataSource
extension SettingVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuName.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableCell", for: indexPath) as! SettingTableCell
        cell.lblSettingOption.text = menuName[indexPath.row]
        return cell
    }
}
//MARK:- TableView DataSource
extension SettingVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        userDefault.set(time1, forKey: "wakeUpTime")
        userDefault.set(time2, forKey: "sleepingTime")
        if indexPath.row == 0 {
            let vc = StoryBoard.Main.instantiateViewController(withIdentifier:"WelcomeVC") as! WelcomeVC
            vc.isFromSetting = true
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = StoryBoard.Main.instantiateViewController(withIdentifier:"SetGoalVC") as! SetGoalVC
            vc.isFromSetting = true
           
            vc.param["wakeupTime"] = time1
            vc.param["sleepTime"] = time2
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
//MARK:- TableView cell class
class SettingTableCell: UITableViewCell {
    @IBOutlet weak var lblSettingOption: UILabel!
}
