//
//  ViewController.swift
//  seguepractice
//
//  Created by Brett on 1/7/16.
//  Copyright © 2016 Brett. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    let url_to_request:String = "https://loguapp.com/swift.php"
    let url_to_post:String = "https://loguapp.com/swift2.php"
    
    var graphWeek : [String]! = []
    var graphPoundage : [Int]! = []
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var liftTextField: UITextField!
    @IBOutlet weak var setsTextField: UITextField!
    @IBOutlet weak var repsTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!


    @IBOutlet weak var logButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.setsTextField.keyboardType = UIKeyboardType.PhonePad
        self.setsTextField.returnKeyType = UIReturnKeyType.Done
        
        dateTextField.delegate = self
        liftTextField.delegate = self
        setsTextField.delegate = self
        repsTextField.delegate = self
        weightTextField.delegate = self
        
        logButton.enabled = false
        
        addDoneButton()
        
        
        //dataOfJson("https://loguapp.com/swift.php")
    }
    
    func addDoneButton() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace,
            target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .Done,
            target: view, action: Selector("endEditing:"))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        setsTextField.inputAccessoryView = keyboardToolbar
        repsTextField.inputAccessoryView = keyboardToolbar
        weightTextField.inputAccessoryView = keyboardToolbar
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if logButton === sender {
            if (setsTextField.text == "") {
                setsTextField.text = "0"
            }
            if (repsTextField.text == "") {
                repsTextField.text = "0"
            }
            if (weightTextField.text == "") {
                weightTextField.text = "0"
            }
            upload_request()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func upload_request()
    {
        let url:NSURL = NSURL(string: url_to_post)!
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        let query = "name=\(NSUserDefaults.standardUserDefaults().valueForKey("USERNAME")!)&date=\(dateTextField.text!)&lift=\(liftTextField.text!)&sets=\(setsTextField.text!)&reps=\(repsTextField.text!)&weight=\(weightTextField.text!)".dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.uploadTaskWithRequest(request, fromData: query, completionHandler:
            {(data,response,error) in
                
                guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                    print("error")
                    return
                }
                
                let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print(dataString)
            }
        );
        
        task.resume()
        
    }

    func textFieldDidBeginEditing(textField: UITextField) {
        logButton.enabled = false
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        CheckIfEmpty()
    }

    func CheckIfEmpty() {
        
        let dateCheck = dateTextField.text ?? ""
        let liftCheck = liftTextField.text ?? ""
        logButton.enabled = !dateCheck.isEmpty && !liftCheck.isEmpty
    }

}

