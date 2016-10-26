//
//  FirstViewController.swift
//  Calorie Tracker
//
//  Created by Ali Ali on 26/10/16.
//  Copyright © 2016 AliAli. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

var calories = 0
var smallCals = 300
var largeCals = 600

class FirstViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    @IBOutlet var date: UILabel!
    
    @IBOutlet var cal: UILabel!
    
    @IBAction func addModal(_ sender: AnyObject) {
         NotificationCenter.default.addObserver(self, selector: #selector(FirstViewController.loadCaloriesData), name: Notification.Name("load"), object: nil)
        viewModal()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCaloriesData()
        setupNotifications()
        requestNotifications()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    
    func viewModal(){//View Add Meal Modal
        performSegue(withIdentifier: "modalSegue", sender: self)
        
    }
    
    func loadUserDefaults(){//Load Local Storage User Default Options
        
        if UserDefaults.standard.object(forKey: "smallCals") != nil{
            smallCals = UserDefaults.standard.object(forKey: "smallCals") as! Int
            largeCals = UserDefaults.standard.object(forKey: "largeCals") as! Int
            
        }else{
            UserDefaults.standard.set(smallCals, forKey: "smallCals")
            UserDefaults.standard.set(largeCals, forKey: "largeCals")
        }
        
    }
    
    func loadCaloriesData(){//Load Local Storage Calories Data For Today
        let today = NSDate()
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.day,.month,.year], from: today as Date)
        date.text = "\(components.day!)/\(components.month!)/\(components.year!)"
        
        if UserDefaults.standard.object(forKey: "day") != nil{
            let day = UserDefaults.standard.object(forKey: "day") as! Int
            let month = UserDefaults.standard.object(forKey: "month") as! Int
            let year = UserDefaults.standard.object(forKey: "year") as! Int
            if day == components.day! && month == components.month! && year == components.year {
                if UserDefaults.standard.object(forKey: "calories") != nil{
                    calories = UserDefaults.standard.object(forKey: "calories") as! Int
                    
                }else{
                    calories = 0
                    UserDefaults.standard.set(calories, forKey: "calories")
                }
            }else{
                UserDefaults.standard.set(components.day!, forKey: "day")
                UserDefaults.standard.set(components.month!, forKey: "month")
                UserDefaults.standard.set(components.year!, forKey: "year")
                calories = 0
                UserDefaults.standard.set(calories, forKey: "calories")
            }
            
        }else{
            UserDefaults.standard.set(components.day!, forKey: "day")
            UserDefaults.standard.set(components.month!, forKey: "month")
            UserDefaults.standard.set(components.year!, forKey: "year")
            calories = 0
            UserDefaults.standard.set(calories, forKey: "calories")
        }
        
        cal.text = "\(calories)"
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "HH:mm"
        let summarydate = dateFormatter.date(from: "23:59")
        let summarycomponents = NSCalendar.current.dateComponents([.hour,.minute], from: summarydate!)
        request(name: "Summary", time: summarycomponents)
        
    }
    
    func addCalories(cals: Int){//add Calories to Counter
        loadCaloriesData()
        calories += cals
        UserDefaults.standard.set(calories, forKey: "calories")
        cal.text = "\(calories)"
    }
    
    
    
    
    
    
    
    
    
    
    
    func setupNotifications(){//Setup Notification Options ans Actions
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Yay!")
            } else {
                print("D'oh")
            }
        }
        
        let small = UNNotificationAction(identifier: "small", title: "Small", options: [])
        let large = UNNotificationAction(identifier: "large", title: "Large", options: [])
        let custom = UNTextInputNotificationAction(identifier: "custom", title: "Custom...", options: [], textInputButtonTitle: "Log", textInputPlaceholder: "ex. 400")
        let cancel = UNNotificationAction(identifier: "cancel", title: "Cancel", options: UNNotificationActionOptions.destructive)
        let actions = [small,large,custom,cancel]
        
        let meals = UNNotificationCategory(identifier: "meals", actions: actions, intentIdentifiers: [], options: [])
        
        center.setNotificationCategories([meals])
    }
    
    func requestNotifications(){//Request Default Notifications if User Customs not Set
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "HH:mm"
        
        if UserDefaults.standard.object(forKey: "bf") == nil{
            let center = UNUserNotificationCenter.current()
            center.removeAllPendingNotificationRequests()
            
            var date = dateFormatter.date(from: "10:00")
            UserDefaults.standard.set("10:00", forKey: "bf")
            let bfcomponents = NSCalendar.current.dateComponents([.hour,.minute], from: date!)
            request(name: "Breakfast", time: bfcomponents)
            
            date = dateFormatter.date(from: "15:00")
            UserDefaults.standard.set("15:00", forKey: "lunch")
            let lunchcomponents = NSCalendar.current.dateComponents([.hour,.minute], from: date!)
            request(name: "Lunch", time: lunchcomponents)
            
            date = dateFormatter.date(from: "20:00")
            UserDefaults.standard.set("20:00", forKey: "dinner")
            let dinnercomponents = NSCalendar.current.dateComponents([.hour,.minute], from: date!)
            request(name: "Dinner", time: dinnercomponents)
            
        }
        
        
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


    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {//Actions after Notification Response Recieved
        
        let userInfo = response.notification.request.content.userInfo
        loadCaloriesData()
        
        if let UID = userInfo["UID"] as? String {
            print("Custom data received: \(UID)")
            print("Custom data received: \(userInfo["meal"] as! String)")
            
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                // the user swiped to unlock
                print("Default identifier")
                
            case "small":
                print("SMALL!!")
                addCalories(cals: smallCals)
                break
            case "large":
                print("LG!!")
                addCalories(cals: largeCals)
                break
            case "custom":
                print("huh!!")
                if let textResponse = response as? UNTextInputNotificationResponse {
                    print(textResponse.userText)
                    let addition = Int(textResponse.userText)
                    if (addition != nil) {
                        addCalories(cals: addition!)
                    }
                }
                break
            case "cancel":
                print("zero!!")
                break
                
            default:
                break
            }
            loadCaloriesData()
        }
        
        // you must call the completion handler when you're done
        completionHandler()
    }


}

