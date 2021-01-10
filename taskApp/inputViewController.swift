//
//  inputViewController.swift
//  taskApp
//
//  Created by 河崎優人 on 2021/01/07.
//  Copyright © 2021 yuto. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications



class inputViewController: UIViewController {

    let realM = try! Realm()
    var taSk:Task!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissK))
        self.view.addGestureRecognizer(tapGesture)
        
        titleField.text = taSk.title
        categoryField.text = taSk.category
        textView.text = taSk.contents
        datePicker.date = taSk.date
        
    }
    @objc func dismissK(){
        view.endEditing(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        try!realM.write{
            self.taSk.title = self.titleField.text!
            self.taSk.category = self.categoryField.text!
            self.taSk.contents = self.textView.text
            self.taSk.date = self.datePicker.date
            self.realM.add(self.taSk,update:.modified)
        }
        setNotifications(tAsk: taSk)
        super.viewWillDisappear(animated)
    }
   
    
    func setNotifications(tAsk:Task){
        let alertContents = UNMutableNotificationContent()
        if tAsk.title == "" {
            alertContents.title = "（タイトルなし）"
        }else{
            alertContents.title = tAsk.title
        }
        if tAsk.contents == ""{
            alertContents.body = "（内容なし）"
        }else{
            alertContents.body = tAsk.contents
        }
        alertContents.sound = UNNotificationSound.default
        
        let calender = Calendar.current
        let dateComponents = calender.dateComponents([.year,.month,.day,.hour,.minute], from: tAsk.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: String(tAsk.id), content: alertContents, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.add(request){(error) in
            print(error ?? "ローカル通知登録完了")
        }
        
        center.getPendingNotificationRequests{ (request:[UNNotificationRequest]) in
            for request in request {
                print("/---")
                print(request)
                print("----/")
            }
        }
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var categoryField: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
}
