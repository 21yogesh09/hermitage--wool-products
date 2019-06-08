//
//  Signup.swift
//  Hermitage
//
//  Created by yogesh on 11/05/19.
//  Copyright © 2019 yogesh. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class Signup: UIViewController, UITextFieldDelegate {
 let db = Firestore.firestore()
    let emailInput = UITextField()
     let nameInput = UITextField()
     let confirmPassInput = UITextField()
    let phoneInput = UITextField()
    let passInput = UITextField()
    let loginButton = UIButton()
    let signupButton = UIButton()
      let logo = UIImageView()
     let loadingIndicator = UIActivityIndicatorView()
     let scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "loginback"))
        navigationItem.title = "Signup"
        view.addSubview(scrollView)
         scrollView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        setupLogo()
        phoneInput.keyboardType = .numberPad
        phoneInput.delegate = self
        setupInput(inputView: nameInput, placeholder: "Enter Name", constraintFrom: logo, isActive: true, top: 16)
        setupInput(inputView: emailInput, placeholder: "Enter Email", constraintFrom: nameInput, isActive: true, top: 16)
        setupInput(inputView: phoneInput, placeholder: "Enter Phone Number", constraintFrom: emailInput, isActive: true, top: 16)
        setupPassword(input: passInput, placeholder: "Enter Password", constraintFrom: phoneInput, top: 16)
        setupPassword(input: confirmPassInput, placeholder: "Confirm Password", constraintFrom: passInput, top: 16)
        setupLoginButton()
        setpSignupButton()
        loginButton.addTarget(self, action: #selector(onLogin), for: .touchUpInside)
        signupButton.addTarget(self, action: #selector(onSignup), for: .touchUpInside)
    }
    
    @objc func onSignup(){
        let email = emailInput.text!
        let name = nameInput.text!
        let phone = phoneInput.text!
        let password = passInput.text!
        let confirm = confirmPassInput.text!
        if (name.count) <= 0 {
            showAlert(message: "Name must not be empty")
        }else if (email.count) <= 0 {
            showAlert(message: "Email must not be empty")
        }else if (phone.count) <= 0 {
            showAlert(message: "Phone number must not be empty")
        }else if password.count <= 8 {
            showAlert(message: "Password must be 8 Characters long")
        }else if password != confirm {
            showAlert(message: "Confirm Password mismatch")
        }else {
            startLoading()
            Auth.auth().createUser(withEmail: email, password: password) { (user, err) in
                if err != nil {
                    self.showAlert(message: (err?.localizedDescription)!)
                    self.stopLoading()
                }
                
                if user != nil {
                    Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                        if error == nil {
                    self.db.collection("users").document(user?.user.uid ?? "23873").setData([
                        "name": name ,
                        "email": email,
                        "phone" : phone,
                        ], merge: true) { err in
                            if let err = err {
                                print("Error adding document: \(err)")
                                self.stopLoading()
                            } else {
                                self.stopLoading()
                              self.navigationController?.setViewControllers([HomeVC()], animated: true)
                            }
                    }
                }
            })
        }
        
    }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setGradientBackground()
        super.viewWillAppear(animated)
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
    
    func startLoading(){
        signupButton.setTitle("", for: .normal)
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
    }
    
    func stopLoading(){
        signupButton.setTitle("Signup", for: .normal)
        loadingIndicator.isHidden = true
        loadingIndicator.stopAnimating()
    }
    
    func showAlert(message: String){
        let alert = UIAlertController(title: "oops", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= 10 // replace 30 for your max length value
    }
    
    @objc func onLogin(){
       self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var contentRect = CGRect.zero
        for view: UIView in scrollView.subviews {
            contentRect = contentRect.union(view.frame)
        }
        contentRect.size.height = contentRect.size.height + 20
        scrollView.contentSize = contentRect.size
    }
    
    
    func setupLogo(){
        logo.sd_setImage(with: URL(string: "https://burner.bonanza.com/background_masks/119707684.png?1557843179"), completed: nil)
        scrollView.addSubview(logo)
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.heightAnchor.constraint(equalToConstant: 100).isActive = true
        logo.widthAnchor.constraint(equalToConstant: 100).isActive = true
        logo.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10).isActive = true
        logo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    
    func setupInput(inputView: UITextField, placeholder: String, constraintFrom: UIView, isActive: Bool, top: CGFloat){
        inputView.placeholder = placeholder
        let indentView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 50))
        inputView.leftView = indentView
        inputView.leftViewMode = .always
        inputView.clearButtonMode = .whileEditing
        inputView.keyboardType = .emailAddress
        inputView.backgroundColor = .white
        
        scrollView.addSubview(inputView)
        inputView.translatesAutoresizingMaskIntoConstraints = false
        inputView.heightAnchor.constraint(equalToConstant: 45).isActive = true
        inputView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        inputView.topAnchor.constraint(equalTo: constraintFrom.bottomAnchor, constant: top).isActive = isActive
        inputView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        inputView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = !isActive
        inputView.layer.cornerRadius = 45 / 2
    }
    
    
    
    func setupPassword(input: UITextField, placeholder: String,constraintFrom: UIView, top: CGFloat){
        input.placeholder = placeholder
        let indentView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 50))
        input.leftView = indentView
        input.leftViewMode = .always
        input.backgroundColor = .white
        input.isSecureTextEntry = true
        scrollView.addSubview(input)
        input.translatesAutoresizingMaskIntoConstraints = false
        input.heightAnchor.constraint(equalToConstant: 50).isActive = true
        input.topAnchor.constraint(equalTo: constraintFrom.bottomAnchor, constant: top).isActive = true
        input.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        input.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        input.layer.cornerRadius = 25
    }
    
    func setupLoginButton(){
        signupButton.setTitle("Signup", for: .normal)
        signupButton.setTitleColor(.white, for: .normal)
        signupButton.backgroundColor = .black
        
        loadingIndicator.color = .white
        loadingIndicator.isHidden = true
        signupButton.addSubview(loadingIndicator)
        
        view.addSubview(signupButton)
        signupButton.translatesAutoresizingMaskIntoConstraints = false
        signupButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        signupButton.topAnchor.constraint(equalTo: confirmPassInput.bottomAnchor, constant: 16).isActive = true
        signupButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        signupButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        signupButton.layer.cornerRadius = 25
        
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.centerXAnchor.constraint(equalTo: signupButton.centerXAnchor).isActive = true
        loadingIndicator.centerYAnchor.constraint(equalTo: signupButton.centerYAnchor).isActive = true
    }
    
    func setpSignupButton(){
        loginButton.setTitle("Already Registered ? Login", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.backgroundColor = UIColor(red:0.94, green:0.33, blue:0.31, alpha:1.0)
        view.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        loginButton.topAnchor.constraint(equalTo: signupButton.bottomAnchor, constant: 16).isActive = true
        loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        loginButton.layer.cornerRadius = 25
    }
    
}
