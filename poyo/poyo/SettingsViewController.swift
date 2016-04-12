//
//  SettingsViewController.swift
//  poyo
//
//  Created by Kevin Asistores on 4/12/16.
//  Copyright © 2016 Takashi Wickes. All rights reserved.
//

import UIKit

protocol SettingsViewDelegate {
    func didPrivate(flag: Bool, password: String!)
    func didDate(flag: Bool, date: Int!, dater: NSDate)
}


class SettingsViewController: UIViewController{

    var passedPrivate: Bool?
    var passedDate: Bool?
    var passedPassword: String?
    var passerDate: NSDate?
    
    var isPrivate: Bool?
    var isDate: Bool?
    
    var delegate : SettingsViewDelegate! = nil
    
    @IBOutlet weak var privateSet: UISwitch!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordtitle: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateSet: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
        passwordtitle.hidden = true
        passwordTextField.hidden = true
        datePicker.hidden = true
        
        dateSet.on = false
        isDate = false;
        privateSet.on = false
        isPrivate = false;
        
        self.navigationController?.navigationItem.backBarButtonItem?.title = ""
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(animated: Bool) {
        if passedPrivate == true{
            privateSet.on = true
            passwordtitle.hidden = false
            passwordTextField.hidden = false
            passwordTextField.text = passedPassword
        }
        else{
            privateSet.on = false
        }
        
        if passedDate == true{
            dateSet.on = true
            datePicker.hidden = false
            datePicker.date = passerDate!
        }
        else{
            datePicker.hidden = true
            dateSet.on = false
        }
    }

    
    @IBAction func switchPrivate(sender: AnyObject) {
        if privateSet.on == true {
            isPrivate = true
            passwordtitle.hidden = false
            passwordTextField.hidden = false
        }
        else{
            isPrivate = false
            passwordtitle.hidden = true
            passwordTextField.hidden = true
        }
    }
    
    @IBAction func switchDate(sender: AnyObject) {
        if dateSet.on == true {
            isDate = true
            datePicker.hidden = false
        }
        else{
            isDate = false
            datePicker.hidden = true
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
    override func willMoveToParentViewController(parent: UIViewController?) {
        if parent == nil {
            print("hahahaha")
            delegate.didPrivate(isPrivate!, password: passwordTextField.text!)
            delegate.didDate(isDate!, date: Int(datePicker.date.timeIntervalSinceNow), dater: datePicker.date)
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "backSegue"){
            print("What")
            let settingPrivate = segue.destinationViewController as! ComposeViewController
        
            if isPrivate == true {
                settingPrivate.setPrivate = true
                settingPrivate.privatePassword = passwordTextField.text
                print(settingPrivate.privatePassword)
            }
            else{
                settingPrivate.setPrivate = false
                print("HAHHAAHA")
            }
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 

}
