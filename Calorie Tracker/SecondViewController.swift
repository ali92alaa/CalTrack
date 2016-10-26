//
//  SecondViewController.swift
//  Calorie Tracker
//
//  Created by Ali Ali on 26/10/16.
//  Copyright © 2016 AliAli. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class SecondViewController: UIViewController {

    @IBOutlet var breakfastTime: UIDatePicker!
    @IBOutlet var lunchTime: UIDatePicker!
    @IBOutlet var dinnerTime: UIDatePicker!
    @IBOutlet var smallCalsInput: UITextField!
    @IBOutlet var largeCalsInput: UITextField!
    
    @IBAction func save(_ sender: AnyObject) {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let bfdate = breakfastTime.date
        let bfcomponents = NSCalendar.current.dateComponents([.hour,.minute], from: bfdate)
        request(name: "Breakfast", time: bfcomponents)
        
        let lunchdate = lunchTime.date
        let lunchcomponents = NSCalendar.current.dateComponents([.hour,.minute], from: lunchdate)
        request(name: "Lunch", time: lunchcomponents)
        
        let dinnerdate = dinnerTime.date
        let dinnercomponents = NSCalendar.current.dateComponents([.hour,.minute], from: dinnerdate)
        request(name: "Dinner", time: dinnercomponents)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "HH:mm"
        
        let summarydate = dateFormatter.date(from: "23:59")
        let summarycomponents = NSCalendar.current.dateComponents([.hour,.minute], from: summarydate!)
        request(name: "Summary", time: summarycomponents)
        
        UserDefaults.standard.set(dateFormatter.string(from: breakfastTime.date), forKey: "bf")
        UserDefaults.standard.set(dateFormatter.string(from: lunchTime.date), forKey: "lunch")
        UserDefaults.standard.set(dateFormatter.string(from: dinnerTime.date), forKey: "dinner")
        
        let test1 = Int(smallCalsInput.text!)
        let test2 = Int(largeCalsInput.text!)
        if (test1 != nil && test2 != nil) {
            smallCals = test1!
            largeCals = test2!
            UserDefaults.standard.set(smallCals, forKey: "smallCals")
            UserDefaults.standard.set(largeCals, forKey: "largeCals")
            toast(title: "Saved Successfully", bgColor: UIColor.black, textColor: UIColor.white)
        }else{
            toast(title: "Error Saving: Please Enter Numbers", bgColor: UIColor.red, textColor: UIColor.white)
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadTimesAndCalories()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func loadTimesAndCalories(){ //Load Custom User Notification Times from Local Storage or Get Defaults if Not Set
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "HH:mm"
        
        if UserDefaults.standard.object(forKey: "bf") != nil{
            var date = dateFormatter.date(from: UserDefaults.standard.object(forKey: "bf") as! String)
            breakfastTime.setDate(date!, animated: true)
            
            date = dateFormatter.date(from: UserDefaults.standard.object(forKey: "lunch") as! String)
            lunchTime.setDate(date!, animated: true)
            
            date = dateFormatter.date(from: UserDefaults.standard.object(forKey: "dinner") as! String)
            dinnerTime.setDate(date!, animated: true)
            
        }else{
            var date = dateFormatter.date(from: "10:00")
            UserDefaults.standard.set("10:00", forKey: "bf")
            breakfastTime.setDate(date!, animated: true)
            
            date = dateFormatter.date(from: "15:00")
            UserDefaults.standard.set("15:00", forKey: "lunch")
            lunchTime.setDate(date!, animated: true)
            
            date = dateFormatter.date(from: "20:00")
            UserDefaults.standard.set("20:00", forKey: "dinner")
            dinnerTime.setDate(date!, animated: true)
        }
        
        smallCalsInput.text = "\(smallCals)"
        largeCalsInput.text = "\(largeCals)"
        
        
    }

    
    
    func request(name: String, time: DateComponents){//Typical Notification Request Function
        
        if (name == "Summary"){//Provision to Add Summary Notification
            let content = UNMutableNotificationContent()
            content.title = NSString.localizedUserNotificationString(forKey: name, arguments: nil)
            content.subtitle = NSString.localizedUserNotificationString(forKey: "Today You Consumed \(calories) KCal", arguments: nil)
            content.body = NSString.localizedUserNotificationString(forKey: "Goal Information Goes Here", arguments: nil)
            content.categoryIdentifier = "meals"
            content.userInfo = ["UID" : "0123469", "meal":"1"]
            //content.badge = NSNumber(integerLiteral: Int(1))
            content.sound = UNNotificationSound.default()
            
            //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let triggerr = UNCalendarNotificationTrigger(dateMatching: time, repeats: true)
            
            let request = UNNotificationRequest(identifier: "\(name)Notification", content: content, trigger: triggerr) // Schedule the notification.
            
            let center = UNUserNotificationCenter.current()
            center.add(request, withCompletionHandler: nil)
            
        }else{
            let content = UNMutableNotificationContent()
            content.title = NSString.localizedUserNotificationString(forKey: name, arguments: nil)
            content.body = NSString.localizedUserNotificationString(forKey: "How Big was \(name)?", arguments: nil)
            content.categoryIdentifier = "meals"
            content.userInfo = ["UID" : "0123469", "meal":"1"]
            //content.badge = NSNumber(integerLiteral: Int(1))
            content.sound = UNNotificationSound.default()
            
            //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let triggerr = UNCalendarNotificationTrigger(dateMatching: time, repeats: true)
            
            let request = UNNotificationRequest(identifier: "\(name)Notification", content: content, trigger: triggerr) // Schedule the notification.
            
            let center = UNUserNotificationCenter.current()
            center.add(request, withCompletionHandler: nil)
        }
        
        
    }
    
    func toast(title: String, bgColor: UIColor, textColor: UIColor){
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 150, y: self.view.frame.size.height-100, width: 300, height: 35))
        
        toastLabel.backgroundColor = bgColor
        toastLabel.textColor = textColor
        toastLabel.textAlignment = NSTextAlignment.center;
        self.view.addSubview(toastLabel)
        toastLabel.text = title
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        UIView.animate(withDuration: 4.0, delay: 1, options: UIViewAnimationOptions.curveEaseOut, animations: {
            
            toastLabel.alpha = 0.0
            
        })
    }

}

