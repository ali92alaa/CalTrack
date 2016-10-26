//
//  ModalViewController.swift
//  Calorie Tracker
//
//  Created by Ali Ali on 26/10/16.
//  Copyright © 2016 AliAli. All rights reserved.
//

import UIKit

class ModalViewController: UIViewController {

    @IBAction func done(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func small(_ sender: AnyObject) {
        addCalories(cals: smallCals)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func large(_ sender: AnyObject) {
        addCalories(cals: largeCals)
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet var customCal: UITextField!
    
    @IBOutlet var error: UILabel!
    
    @IBAction func log(_ sender: AnyObject) {
        let addition = Int(customCal.text!)
        if (addition != nil) {
            addCalories(cals: addition!)
            dismiss(animated: true, completion: nil)
        }else{
            error.text = "Please Enter A Number in the Field"
        }
        
        
    }
    
    func addCalories(cals: Int){
        calories += cals
        UserDefaults.standard.set(calories, forKey: "calories")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.post(name: Notification.Name("load"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
