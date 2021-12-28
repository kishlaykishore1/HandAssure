//
//  SideMenuVC.swift
//  HandAssure
//
//  Created by kishlay kishore on 28/10/20.
//

import UIKit

class SideMenuVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var imgProfilepic: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblVersionNo: UILabel!
    
    private var gradientLayer = CAGradientLayer()
    var menuImage = [ #imageLiteral(resourceName: "HomeIcon"), #imageLiteral(resourceName: "SideMenuHistory"), #imageLiteral(resourceName: "SideMenuReport"), #imageLiteral(resourceName: "SideMenuSetting"),#imageLiteral(resourceName: "SideMenuFaqs"),#imageLiteral(resourceName: "SideMenuPolicy"),#imageLiteral(resourceName: "SideMenuEmail")]
    var menuName = ["Home", "Hand Wash History", "Hand Wash Report", "Settings", "FAQs", "Privacy Policy","Get in Touch"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        headerConfiguration()
    }
    // MARK: - Gradient View
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if gradientLayer.superlayer != nil {
            gradientLayer.removeFromSuperlayer()
        }
//        if let imageData = UserDefaults.standard.object(forKey: "ProfileImage"),
//           let image = UIImage(data: imageData as! Data){
//            imgProfilepic.image = image
//        }
        if let userName = UserDefaults.standard.string(forKey: "userName") {
            lblName.text = userName
        }
        
        let topColor = #colorLiteral(red: 0.1843137255, green: 0.6470588235, blue: 0.9921568627, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.03921568627, green: 0.05490196078, blue: 0.3058823529, alpha: 1)
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.frame = tableView.bounds
        let backgroundView = UIView(frame: tableView.bounds)
        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
        tableView.backgroundView = backgroundView
    }
    
    @IBAction func imgTapAction(_ sender: UIView) {
       // showImagePickerView()
    }
    
}
// MARK: - TableView DataSource
extension SideMenuVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuImage.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell", for: indexPath) as! SideMenuCell
        cell.imgView.image = menuImage[indexPath.row]
        cell.lblName.text = menuName[indexPath.row]
        return cell
    }
}
// MARK: - TableView delegate
extension SideMenuVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // println("Row \(indexPath.row) selected")
        let cell:SideMenuCell = tableView.cellForRow(at: indexPath) as! SideMenuCell
        cell.backgroundColor = #colorLiteral(red: 0.7058823529, green: 0.8509803922, blue: 1, alpha: 1)
        switch indexPath.row {
        case 0:
            self.dismiss(animated: true, completion: nil)
        case 1:
            let vc = StoryBoard.Main.instantiateViewController(withIdentifier:"HistoryVC") as! HistoryVC
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = StoryBoard.Main.instantiateViewController(withIdentifier:"ReportVC") as! ReportVC
            self.navigationController?.pushViewController(vc, animated: true)
        case 3:
            let vc = StoryBoard.Main.instantiateViewController(withIdentifier: "SettingVC") as! SettingVC
            self.navigationController?.pushViewController(vc, animated: true)
        case 4:
            let vc = StoryBoard.Main.instantiateViewController(withIdentifier: "FaqVC") as! FaqVC
            self.navigationController?.pushViewController(vc, animated: true)
        case 5:
            let vc = StoryBoard.Main.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            let vc = StoryBoard.Main.instantiateViewController(withIdentifier:"HelpVC") as! HelpVC
            self.navigationController?.pushViewController(vc, animated: true)
            break
        }
    }
}
// MARK: - TableView Header
extension SideMenuVC {
    func headerConfiguration() {
        headerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: headerView.frame.height)
        tableView.tableHeaderView = headerView
        tableView.tableHeaderView?.frame =  headerView.frame
    }
}
// MARK: - Table View Cell Class
class SideMenuCell: UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
}
//MARK: UIImagePickerController Config
extension SideMenuVC {
    func openCamera() {
        
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            Common.showAlertMessage(message: Messages.cameraNotFound, alertType: .warning)
        }
    }
    
    func openGallary() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    //Open Picker Bottom Sheet
    func showImagePickerView() {
        // self.index = index
        // self.docTitle = title
        let alert = UIAlertController(title: Messages.photoMassage, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: Messages.camera, style: .default, handler: { _ in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: Messages.gallery, style: .default, handler: { _ in
            self.openGallary()
        }))
        alert.addAction(UIAlertAction.init(title: Messages.txtDeleteCancel, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
//MARK: UIImagePickerControllerDelegate
extension SideMenuVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let  pickedImage = info[.editedImage] as? UIImage {
            // imgProfilePic.contentMode = .scaleAspectFill
            UserDefaults.standard.setValue(pickedImage.jpegData(compressionQuality: 200), forKey: "ProfileImage")
            imgProfilepic.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
