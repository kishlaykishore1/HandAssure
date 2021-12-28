//
//  FaqVC.swift
//  HandAssure
//
//  Created by kishlay kishore on 28/10/20.
//

import UIKit
import Alamofire
class FaqVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var faqData = [DataIsExpendable(isExpanded: false), DataIsExpendable(isExpanded: false), DataIsExpendable(isExpanded: false), DataIsExpendable(isExpanded: false)]
    var QuestionsArr = ["Q. This is another question", "Q. This is another question", "Q. This is another question", "Q. This is another question"]
    var AnswersArr = ["Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry’s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.", "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry’s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.", "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry’s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.", "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry’s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book."]
    var faqDataApi = [FAQDataModelElement]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        apiFaqData()
        self.title = "FAQs"
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
extension FaqVC:UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return faqDataApi.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"FaqTableCell") as! FaqTableCell
        cell.lblQuestion.text = faqDataApi[indexPath.row].question
        cell.imgDropDownArrow.image = (faqDataApi[indexPath.row].isExpanded ) ? #imageLiteral(resourceName: "ArrowUp") : #imageLiteral(resourceName: "ArrowDown")
        cell.lblAnswers.text = faqDataApi[indexPath.row].answer
        return cell
    }
}
//MARK:-Table View Delegates Methods
extension FaqVC:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        faqDataApi[indexPath.row].isExpanded = !(faqDataApi[indexPath.row].isExpanded )
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (faqDataApi[indexPath.row].isExpanded ) ? UITableView.automaticDimension : 64
    }
}

// MARK: - Table View First Cell Class
class FaqTableCell: UITableViewCell {
    
    @IBOutlet weak var imgDropDownArrow: UIImageView!
    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var lblAnswers: UILabel!
}
// MARK: - Expanded Function Class
class DataIsExpendable {
    var isExpanded: Bool = false
    init(isExpanded: Bool) {
        self.isExpanded = isExpanded
    }
}
// MARK: - Api Implementation For Faq data
extension FaqVC {
    func apiFaqData() {
        Global.showLoadingSpinner()
         AF.request("https://mydevpartner.website/HandAssure/public/get-faqs")
         .validate()
         .responseDecodable(of: [FAQDataModelElement].self) { (response) in
            guard let faqData = response.value else { return }
            self.faqDataApi = faqData
            Global.dismissLoadingSpinner()
            self.tableView.reloadData()
         }
    }
}
