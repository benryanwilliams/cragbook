//
//  LoginViewController.swift
//  Cragbook
//
//  Created by Ben Williams on 15/11/2020.
//  Copyright © 2020 Ben Williams. All rights reserved.
//

import SafariServices
import UIKit

class LoginViewController: UIViewController {
    
    struct Constants {
        static let cornerRadius: CGFloat = 8.0
    }
    
    // This is an 'anonymous closure'. Create property of type UITextField via closure that executes now (the equals sign and the '()' executes the closure now and stores it within the property, rather than executing it when the property is called)
    private let usernameEmailField: UITextField = {
        let field = UITextField()
        field.placeholder = "Username or email"
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
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Constants.cornerRadius
        button.backgroundColor = .systemBlue
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
    
    private let createAccountButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.setTitle("New user? Create an account", for: .normal)
        return button
    }()
    
    private let headerView: UIView = {
        let header = UIView()
        header.clipsToBounds = true
        let backgroundImageView = UIImageView(image: UIImage(named: "gradient"))
        header.addSubview(backgroundImageView)
        return header
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        createAccountButton.addTarget(self, action: #selector(didTapCreateAccountButton), for: .touchUpInside)
        termsButton.addTarget(self, action: #selector(didTapTermsButton), for: .touchUpInside)
        privacyButton.addTarget(self, action: #selector(didTapPrivacyButton), for: .touchUpInside)
        
        usernameEmailField.delegate = self
        passwordField.delegate = self
        
        addSubviews()
        
        view.backgroundColor = .systemBackground
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Assign frames
        headerView.frame = CGRect(
            x: 0,
            y: 0,
            width: view.width,
            height: view.height/3.0
        )
        
        usernameEmailField.frame = CGRect(
            x: 25,
            y: headerView.bottom + 25,
            width: view.width - 50,
            height: 52
        )
        
        passwordField.frame = CGRect(
            x: 25,
            y: usernameEmailField.bottom + 15,
            width: view.width - 50,
            height: 52
        )
        
        loginButton.frame = CGRect(
            x: 25,
            y: passwordField.bottom + 15,
            width: view.width - 50,
            height: 52
        )
        
        createAccountButton.frame = CGRect(
            x: 25,
            y: loginButton.bottom + 5,
            width: view.width - 50,
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
        
        configureHeaderView()
        
    }
    
    private func configureHeaderView() {
        guard headerView.subviews.count == 1 else {
            return
        }
        
        guard let backgroundView = headerView.subviews.first else {
            return
        }
        backgroundView.frame = headerView.bounds
        
        // Add Instagram logo
        let imageView = UIImageView(image: UIImage(named: "fulltextlogo"))
        headerView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(
            x: headerView.width/6.0,
            y: view.safeAreaInsets.top,
            width: headerView.width/1.5,
            height: headerView.height - view.safeAreaInsets.top
        )
        
    }
    
    private func addSubviews() {
        view.addSubview(usernameEmailField)
        view.addSubview(passwordField)
        view.addSubview(loginButton)
        view.addSubview(termsButton)
        view.addSubview(privacyButton)
        view.addSubview(createAccountButton)
        view.addSubview(headerView)
    }
    
    @objc private func didTapLoginButton() {
        usernameEmailField.resignFirstResponder()
        passwordField.resignFirstResponder()
         
        guard let usernameEmail = usernameEmailField.text, !usernameEmail.isEmpty,
            let password = passwordField.text, !password.isEmpty, password.count >= 8 else {
            return
        }
        
        // Login functionality
        
        
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
    
    @objc private func didTapCreateAccountButton() {
        let vc = RegisterViewController()
        present(vc, animated: true)
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    
    // What should happen if the return button is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameEmailField {
            passwordField.becomeFirstResponder() // Move from username field to password field
        }
        
        if textField == passwordField {
            didTapLoginButton()
        }
        
        return true
    }
}
