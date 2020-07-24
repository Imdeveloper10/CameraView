//
//  LoginViewController.swift

import UIKit
import SwiftValidator
import Foundation

class LoginViewController: UIViewController , ValidationDelegate, UITextFieldDelegate {

    @IBOutlet weak var txt_password: UITextField!
    @IBOutlet weak var txt_Email: UITextField!
    @IBOutlet weak var roundView: UIView!
    
    let validator = Validator()
    var str_selectedTeam:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.roundView.roundCorners([.topLeft, .topRight], radius: 40)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(LoginViewController.hideKeyboard)))
        validator.registerField(txt_Email, rules: [RequiredRule(message: "Field is empty"), EmailRule(message: "Please enter correct email address")])
        validator.registerField(txt_password, rules: [RequiredRule(), MinLengthRule(length: 4)])
    }
    
    // MARK: ValidationDelegate Methods
    
    func validationSuccessful() {
        print("Validation Success!")
    }
    
    func validationFailed(_ errors:[(Validatable, ValidationError)]) {
            for (field, error) in errors {
                print(error.errorMessage)
                self.showAlert(errorMessage:  error.errorMessage)
            }
    }
    
    @objc func hideKeyboard(){
        self.view.endEditing(true)
    }
    
    // MARK: Validate single field
    // Don't forget to use UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == txt_Email){
            txt_password.becomeFirstResponder()
        }else{
            txt_password.resignFirstResponder()
        }
        return true
    }
   
    func showAlert(errorMessage:String){
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: UIAlertController.Style.alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(defaultAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - API CALL
    func callLoginAPI(){
        // Test Login request
        APIClient.login(email: self.txt_Email.text!, password: self.txt_password.text) { result in
              switch result {
              case .success(let user):
                  print("_____________________________")
                  print(user)
              case .failure(let error):
                self.showAlert(errorMessage:  "Invalid Email or Password")
                print(error.localizedDescription)
              }
          }
    }
    
    // MARK: - IBActions
    @IBAction func gotoDashboard(_ sender: UIButton) {
    }
    
    @IBAction func gotoSignup(_ sender: Any) {
    }
    
}
