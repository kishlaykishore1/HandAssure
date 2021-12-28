//
//  PrivacyPolicyVC.swift
//  HandAssure
//
//  Created by kishlay kishore on 09/11/20.
//

import UIKit

class PrivacyPolicyVC: UIViewController {

    @IBOutlet weak var lblPrivacyPolicy: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Privacy Policy"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Poppins-Bold", size: 18) ?? UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor:#colorLiteral(red: 0.2470588235, green: 0.2470588235, blue: 0.2549019608, alpha: 1)]
        lblPrivacyPolicy.text = Messages.txtPPData.htmlToString
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    // MARK: - Back Button Action
    @IBAction func backButtonAction(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
}
