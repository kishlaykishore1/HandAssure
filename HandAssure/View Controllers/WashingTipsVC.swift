//
//  WashingTipsVC.swift
//  HandAssure
//
//  Created by kishlay kishore on 28/10/20.
//

import UIKit
import Alamofire
class WashingTipsVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var tipsData = [TipsModel(isExpanded: false), TipsModel(isExpanded: false), TipsModel(isExpanded: false), TipsModel(isExpanded: false)]
    var QuestionsArr = ["Q. This is another Tips", "Q. This is another Tips", "Q. This is another Tips", "Q. This is another Tips"]
    var AnswersArr = ["Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry’s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.", "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry’s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.", "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry’s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.", "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry’s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book."]
    var tipsDataApi = [TipsDataModelElement]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        apiTipsData()
        self.title = "HAND WASHING TIPS"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Poppins-Bold", size: 18) ?? UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor:#colorLiteral(red: 0.2470588235, green: 0.2470588235, blue: 0.2549019608, alpha: 1)]
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    @IBAction func btnBackPressed(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
}
//MARK:-Table View DataSource Methods
extension WashingTipsVC:UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tipsDataApi.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"TipsTableCell") as! TipsTableCell
        cell.lblQuestion.text = tipsDataApi[indexPath.row].tip
        cell.imgDropDownArrow.image = (tipsDataApi[indexPath.row].isExpanded ) ? #imageLiteral(resourceName: "ArrowUp") : #imageLiteral(resourceName: "ArrowDown")
        cell.lblAnswers.text = tipsDataApi[indexPath.row].tip
        return cell
        
        
    }
}
//MARK:-Table View Delegates Methods
extension WashingTipsVC:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tipsDataApi[indexPath.row].isExpanded = !(tipsDataApi[indexPath.row].isExpanded )
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return (tipsDataApi[indexPath.row].isExpanded ) ? UITableView.automaticDimension : 64
    }
    
}

// MARK: - Table View First Cell Class
class TipsTableCell: UITableViewCell {
    
    @IBOutlet weak var imgDropDownArrow: UIImageView!
    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var lblAnswers: UILabel!
}
// MARK: - Expanded Function Class
class TipsModel {
    var isExpanded: Bool = false
    init(isExpanded: Bool) {
        self.isExpanded = isExpanded
    }
}
// MARK: - Api Implementation For Faq data
extension WashingTipsVC {
    func apiTipsData() {
         Global.showLoadingSpinner()
         AF.request("https://mydevpartner.website/HandAssure/public/get-tips")
         .validate()
         .responseDecodable(of: [TipsDataModelElement].self) { (response) in
            guard let tipsData = response.value else { return }
            self.tipsDataApi = tipsData
            Global.dismissLoadingSpinner()
            self.tableView.reloadData()
         }
    }
}

