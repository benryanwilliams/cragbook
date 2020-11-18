//
//  RegisterViewController.swift
//  Cragbook
//
//  Created by Ben Williams on 15/11/2020.
//  Copyright © 2020 Ben Williams. All rights reserved.
//

import SafariServices
import UIKit

class RegisterViewController: UIViewController {
    
    struct Constants {
        static let cornerRadius: CGFloat = 8.0
    }
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "cragbook-logo"))
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = Constants.cornerRadius
        return imageView
    }()
    
    private let usernameField: UITextField = {
        let field = UITextField()
        field.placeholder = "Username"
        field.returnKeyType = .next // Changes 'return' to 'next' on keyboard
        field.leftViewMode = .always // Enables left aligned text mode to allow gap to be added at beginning
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0)) // Adds gap at beginning
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.layer.masksToBounds = true // Clips any sublayers to the boundaries of the layer
        field.layer.cornerRadius = Constants.cornerRadius // Adds corner radius per Constants struct above
        field.backgroundColor = .secondarySystemBackground
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.secondaryLabel.cgColor
        return field
    }()
    
    private let emailField: UITextField = {
        let field = UITextField()
        field.placeholder = "Email"
        field.returnKeyType = .next
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0)) 
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.layer.masksToBounds = true
        field.layer.cornerRadius = Constants.cornerRadius
        field.backgroundColor = .secondarySystemBackground
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.secondaryLabel.cgColor
        return field
    }()
    
    private let passwordField: UITextField = {
        let field = UITextField()
        field.isSecureTextEntry = true
        field.placeholder = "Password"
        field.returnKeyType = .continue
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.layer.masksToBounds = true
        field.layer.cornerRadius = Constants.cornerRadius
        field.backgroundColor = .secondarySystemBackground
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.secondaryLabel.cgColor
        return field
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Constants.cornerRadius
        button.backgroundColor = .systemGreen
        return button
    }()
    
    private let termsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Terms of service", for: .normal)
        button.setTitleColor(.secondaryLabel, for: .normal)
        return button
    }()
    
    private let privacyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Privacy policy", for: .normal)
        button.setTitleColor(.secondaryLabel, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        
        registerButton.addTarget(self, action: #selector(didTapRegisterButton), for: .touchUpInside)
        termsButton.addTarget(self, action: #selector(didTapTermsButton), for: .touchUpInside)
        privacyButton.addTarget(self, action: #selector(didTapPrivacyButton), for: .touchUpInside)
        addSubviews()
        
        view.backgroundColor = .systemBackground
        
    }
    
    override func viewDidLayoutSubviews() {
        
        logoImageView.frame = CGRect(
            x: 130,
            y: view.safeAreaInsets.top + 20,
            width: view.width - 260,
            height: view.width - 260
        )
        
        usernameField.frame = CGRect(
            x: 20,
            y: logoImageView.bottom + 20,
            width: view.width - 40,
            height: 52
        )
        
        emailField.frame = CGRect(
            x: 20,
            y: usernameField.bottom + 10,
            width: view.width - 40,
            height: 52
        )
        
        passwordField.frame = CGRect(
            x: 20,
            y: emailField.bottom + 10,
            width: view.width - 40,
            height: 52
        )
        
        registerButton.frame = CGRect(
            x: 20,
            y: passwordField.bottom + 10,
            width: view.width - 40,
            height: 52
        )
        
        termsButton.frame = CGRect(
            x: 10,
            y: view.height - view.safeAreaInsets.bottom - 100,
            width: view.width - 20,
            height: 30
        )
        
        privacyButton.frame = CGRect(
            x: 10,
            y: view.height - view.safeAreaInsets.bottom - 60,
            width: view.width - 20,
            height: 30
        )
    }
    
    private func addSubviews() {
        view.addSubview(logoImageView)
        view.addSubview(usernameField)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(registerButton)
        view.addSubview(termsButton)
        view.addSubview(privacyButton)
    }
    
    @objc private func didTapRegisterButton() {
        usernameField.resignFirstResponder()
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        guard let username = usernameField.text, !username.isEmpty,
            let email = emailField.text, !email.isEmpty, email.contains("@"), email.contains("."),
            let password = passwordField.text, !password.isEmpty, password.count >= 8 else {
                return
        }
        
        AuthManager.shared.registerNewUser(username: username, email: email, password: password)
        
    }
    
    @objc private func didTapTermsButton() {
        guard let url = URL(string: "https://www.facebook.com/terms.php") else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
        
    }
    
    @objc private func didTapPrivacyButton() {
        guard let url = URL(string: "https://www.facebook.com/policy.php") else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    
    
}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameField {
            emailField.becomeFirstResponder()
        }
        else if textField == emailField {
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField {
            didTapRegisterButton()
        }
        
        return true
    }
}
