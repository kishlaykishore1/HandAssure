//
//  ExtensionSetGoalVC+PickerFunction.swift
//  HandAssure
//
//  Created by kishlay kishore on 29/11/20.
//

import Foundation
import UIKit

extension SetGoalVC {
    //MARK:-Picker View Setup
    func PickerViewConnection() {
        picker = UIPickerView.init()
        picker.delegate = self
        picker.backgroundColor = UIColor.white
        picker.setValue(UIColor.black, forKey: "textColor")
        picker.autoresizingMask = .flexibleWidth
        picker.contentMode = .center
        picker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.barStyle = UIBarStyle.black
        toolBar.isTranslucent = true
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(onDoneButtonTapped))
        let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(onCancelButtonTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancel, flexibleSpace, done], animated: false)
    }
    //MARK:- The Function For the Picker Done button
    @objc func onDoneButtonTapped() {
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
        selectedTimes = picker.selectedRow(inComponent: 0) + 1
        timeDiff(t1: param["wakeupTime"] as! Date , t2: param["sleepTime"] as! Date , noOfTimesMain: selectedTimes, timeSlotInMinMain: 0, isFromGoal: true)
        print(selectedTimes)
        let vc = StoryBoard.Main.instantiateViewController(withIdentifier:"HomeVC") as! HomeVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK:- The Function For the Picker Cancel button
    @objc func onCancelButtonTapped() {
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
    }
    //MARK:- DatePicker assigning
    func DatePickerViewConnection() {
        datePicker.backgroundColor = UIColor.white
        datePicker.setValue(UIColor.black, forKey: "textColor")
        datePicker.autoresizingMask = .flexibleWidth
        datePicker.contentMode = .center
        datePicker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
        toolBar1 = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar1.barStyle = UIBarStyle.black
        toolBar1.isTranslucent = true
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(onDone1ButtonTapped))
        let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(onCancel1ButtonTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar1.setItems([cancel, flexibleSpace, done], animated: false)
    }
    //MARK:- The Function For the Picker Done button
    @objc func onDone1ButtonTapped() {
        toolBar1.removeFromSuperview()
        datePicker.removeFromSuperview()
        let calendar = Calendar.current
        let comp = calendar.dateComponents([.hour, .minute], from: self.datePicker.date)
        let hour = comp.hour ?? 0
        let minute = comp.minute ?? 0
       // let week = comp.weekday
        timeInterval = (hour * 60) + (minute)
        if timeInterval > 0 {
            timeDiff(t1: param["wakeupTime"] as! Date, t2: param["sleepTime"] as! Date, noOfTimesMain: 0, timeSlotInMinMain: timeInterval, isFromGoal: false)
            if (timeListArr.count - 1) <= 20 {
                let vc = StoryBoard.Main.instantiateViewController(withIdentifier:"HomeVC") as! HomeVC
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                showAlert(title: "Alert", message: "Please Increase Your Time Interval")
            }
        } else {
            showAlert(title: "Alert", message: "Please Decrease Your Time Interval or select other option")
        }
        print(timeInterval)
    }
    //MARK:- The Function For the Picker Cancel button
    @objc func onCancel1ButtonTapped() {
        toolBar1.removeFromSuperview()
        datePicker.removeFromSuperview()
    }
}
