//
//  Login.swift
//  Hermitage
//
//  Created by yogesh on 11/05/19.
//  Copyright © 2019 yogesh. All rights reserved.
//

import UIKit
import FirebaseAuth

class Login: UIViewController {
    
    let emailInput = UITextField()
    let passInput = UITextField()
    let loginButton = UIButton()
    let signupButton = UIButton()
    let logo = UIImageView()
    let loadingIndicator = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "loginback"))
//        view.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
        
        navigationItem.title = "Login"
        setupLogo()
        setupEmailInput()
        setupPassword()
        setupLoginButton()
        setpSignupButton()
        loginButton.addTarget(self, action: #selector(onLogin), for: .touchUpInside)
        signupButton.addTarget(self, action: #selector(onSignup), for: .touchUpInside)
    }
    
    @objc func onSignup(){
         self.navigationController?.pushViewController(Signup(), animated: true)
    }
    
    // uncomment next to enable auto login
    
    override func viewWillAppear(_ animated: Bool) {
        setGradientBackground()
        super.viewWillAppear(animated)
        if Auth.auth().currentUser != nil {
               self.navigationController?.setViewControllers([HomeVC()], animated: true)
        }
    }
    
    func setGradientBackground() {
        let colorTop =  UIColor(red:0.25, green:0.36, blue:0.90, alpha:1.0).cgColor
        let colorMed = UIColor(red:0.51, green:0.23, blue:0.71, alpha:1.0).cgColor
        let colorBottom = UIColor(red:0.88, green:0.19, blue:0.42, alpha:1.0).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop,colorMed, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        
        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
    
    @objc func onLogin(){
        let email = emailInput.text!
        let password = passInput.text!
        if (email.count) <= 0 {
            showAlert(message: "Email must not be empty")
        }else if (password.count) <= 8 {
              showAlert(message: "Password must not be empty or greater than 8 Characters")
        }else {
            startLoading()
            Auth.auth().signIn(withEmail: email, password: password) { (user, err) in
                self.stopLoading()
                if err != nil{
                    self.showAlert(message: (err?.localizedDescription)!)
                }
                
                self.navigationController?.setViewControllers([HomeVC()], animated: true)
                
            }
        }
       
    }
    
    func startLoading(){
          loginButton.setTitle("", for: .normal)
          loadingIndicator.isHidden = false
          loadingIndicator.startAnimating()
    }
    
    func stopLoading(){
        loginButton.setTitle("Login", for: .normal)
        loadingIndicator.isHidden = true
        loadingIndicator.stopAnimating()
    }
    
    func showAlert(message: String){
        let alert = UIAlertController(title: "oops", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func setupLogo(){
        logo.sd_setImage(with: URL(string: "https://burner.bonanza.com/background_masks/119707684.png?1557843179"), completed: nil)
        view.addSubview(logo)
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.heightAnchor.constraint(equalToConstant: 100).isActive = true
        logo.widthAnchor.constraint(equalToConstant: 100).isActive = true
        logo.topAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive = true
        logo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func setupEmailInput(){
        emailInput.placeholder = "Enter Email"
        let indentView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 50))
        emailInput.leftView = indentView
        emailInput.leftViewMode = .always
        emailInput.clearButtonMode = .whileEditing
        emailInput.keyboardType = .emailAddress
        emailInput.backgroundColor = .white
        
          view.addSubview(emailInput)
        emailInput.translatesAutoresizingMaskIntoConstraints = false
        emailInput.heightAnchor.constraint(equalToConstant: 50).isActive = true
        emailInput.topAnchor.constraint(equalTo: view.topAnchor, constant: 300).isActive = true
        emailInput.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        emailInput.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true

        emailInput.layer.cornerRadius = 25
    }
    
    func setupPassword(){
        passInput.placeholder = "Enter Password"
        let indentView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 50))
        passInput.leftView = indentView
        passInput.leftViewMode = .always
        passInput.backgroundColor = .white
        passInput.isSecureTextEntry = true
        view.addSubview(passInput)
        passInput.translatesAutoresizingMaskIntoConstraints = false
        passInput.heightAnchor.constraint(equalToConstant: 50).isActive = true
        passInput.topAnchor.constraint(equalTo: emailInput.topAnchor, constant: 70).isActive = true
        passInput.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        passInput.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        passInput.layer.cornerRadius = 25
    }
    
    func setupLoginButton(){
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.backgroundColor = .black
        
        loadingIndicator.color = .white
        loadingIndicator.isHidden = true
        loginButton.addSubview(loadingIndicator)
        
        view.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        loginButton.topAnchor.constraint(equalTo: passInput.topAnchor, constant: 70).isActive = true
        loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        loginButton.layer.cornerRadius = 25
        
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.centerXAnchor.constraint(equalTo: loginButton.centerXAnchor).isActive = true
        loadingIndicator.centerYAnchor.constraint(equalTo: loginButton.centerYAnchor).isActive = true
    }
    
    func setpSignupButton(){
        signupButton.setTitle("Not Registered ? Signup", for: .normal)
        signupButton.setTitleColor(.white, for: .normal)
        signupButton.backgroundColor = UIColor(red:0.94, green:0.33, blue:0.31, alpha:1.0)
        view.addSubview(signupButton)
        signupButton.translatesAutoresizingMaskIntoConstraints = false
        signupButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        signupButton.topAnchor.constraint(equalTo: loginButton.topAnchor, constant: 70).isActive = true
        signupButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        signupButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        signupButton.layer.cornerRadius = 25
    }

}
