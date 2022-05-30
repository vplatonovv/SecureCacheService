//
//  AddFieldsViewController.swift
//  KeychainDemo
//
//  Created by Слава Платонов on 24.05.2022.
//

import UIKit

class AddFieldsViewController: UIViewController {
    
    let cacheService = CacheUserService()
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passportTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setListeners()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    private func setListeners() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { (nc) in
            self.view.frame.origin.y = -100
        }
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { (nc) in
            self.view.frame.origin.y = 0
        }
    }
    
    private func setupUserFromTextFields() -> User? {
        guard let name = nameTF.text, !name.isEmpty,
              let pass = passwordTF.text, !pass.isEmpty,
              let email = emailTF.text, !email.isEmpty,
              let passport = passportTF.text, !passport.isEmpty,
              let phone = phoneTF.text, !phone.isEmpty else {
            print("fill all fields")
            return nil
        }
        let user = User(name: name, password: pass, email: email, passport: passport, phone: phone)
        return user
    }
    
    private func clearAllFields() {
        nameTF.text = ""
        passwordTF.text = ""
        emailTF.text = ""
        passportTF.text = ""
        phoneTF.text = ""
    }
    
    @IBAction func save(_ sender: Any) {
        guard let user = setupUserFromTextFields() else { return }
        cacheService.addUserToCache(user)
        clearAllFields()
    }
    
    @IBAction func read(_ sender: Any) {
        
    }
}
