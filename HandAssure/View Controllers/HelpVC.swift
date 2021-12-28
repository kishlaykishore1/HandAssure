//
//  HelpVC.swift
//  HandAssure
//
//  Created by kishlay kishore on 29/10/20.
//

import UIKit
import Alamofire
struct Param: Encodable {
    let name:String
    let email: String
    let message: String
}
class HelpVC: UIViewController {
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmailorNumber: UITextField!
    @IBOutlet weak var txtMessageText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "GET IN TOUCH"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Poppins-Bold", size: 18) ?? UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor:#colorLiteral(red: 0.2470588235, green: 0.2470588235, blue: 0.2549019608, alpha: 1)]
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    @IBAction func BtnSendPressed(_ sender: UIButton) {
        if Validation.isBlank(for: txtName.text ?? "") {
            Common.showAlertMessage(message: Messages.emptyName, alertType: .error)
            return
        } else if Validation.isBlank(for: txtEmailorNumber.text ?? "") {
            Common.showAlertMessage(message: Messages.emptyNumber, alertType: .error)
            return
        } else if Validation.isBlank(for: txtMessageText.text ?? "") {
            Common.showAlertMessage(message: Messages.emptyMessage, alertType: .error)
            return
        }
        apiGetInTouch()
    }
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - Api Implementation For Get In touch Data
extension HelpVC {
    func apiGetInTouch() {
        let help = Param(name: txtName.text ?? "", email: txtEmailorNumber.text ?? "", message: txtMessageText.text.trim())
        Global.showLoadingSpinner()
        AF.request("https://mydevpartner.website/HandAssure/public/getintouch", method: .post,parameters: help,encoder: JSONParameterEncoder.default).response { response in
            Global.dismissLoadingSpinner()
            switch response.result {
            case .success:
                self.txtName.text = ""
                self.txtMessageText.text = ""
                self.txtEmailorNumber.text = ""
                Common.showAlertMessage(message: "Success", alertType: .success)
            case let .failure(error):
                Common.showAlertMessage(message: "\(error)", alertType: .error)
            }
        }
    }
}
