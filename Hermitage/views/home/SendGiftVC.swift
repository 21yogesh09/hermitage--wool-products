//
//  SendGiftVC.swift
//  Hermitage
//
//  Created by yogesh on 23/05/19.
//  Copyright © 2019 yogesh. All rights reserved.
//

import UIKit
import LBTATools
import FirebaseFirestore
import FirebaseAuth

class SendGiftVC: LBTAFormController {
    
    let loadingIndicator = UIActivityIndicatorView()
    var db = Firestore.firestore()
    
    var giftItem: productModel?
    var nameInput = IndentedTextField(placeholder: "Enter Name", padding: 12, cornerRadius: 25, backgroundColor: .white)
    var number = IndentedTextField(placeholder: "Enter Phone Number", padding: 12, cornerRadius: 25, backgroundColor: .white)
    var size = IndentedTextField(placeholder: "Enter Size", padding: 12, cornerRadius: 25, backgroundColor: .white)
    var gsm = IndentedTextField(placeholder: "Enter Gsm", padding: 12, cornerRadius: 25, backgroundColor: .white)
    var fabric = IndentedTextField(placeholder: "Enter Fabric type", padding: 12, cornerRadius: 25, backgroundColor: .white)
    var address = IndentedTextField(placeholder: "Enter Receiver Address", padding: 12, cornerRadius: 25, backgroundColor: .white)
    
    let submitButton = UIButton(title: "Send Gift", titleColor: .white, backgroundColor: UIColor(red:1.00, green:0.76, blue:0.03, alpha:1.0), target: self, action: #selector(sendGift))
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.9372549057, blue: 0.9568627477, alpha: 1)
        formContainerStackView.axis = .vertical
        formContainerStackView.spacing = 12
        formContainerStackView.layoutMargins = .init(top: 80, left: 23, bottom: 0, right: 24)
        
        nameInput.constrainHeight(50)
        number.constrainHeight(50)
        address.constrainHeight(50)
        submitButton.constrainHeight(50)
        submitButton.layer.cornerRadius = 25
        
        submitButton.addSubview(loadingIndicator)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.centerXAnchor.constraint(equalTo: submitButton.centerXAnchor).isActive = true
        loadingIndicator.centerYAnchor.constraint(equalTo: submitButton.centerYAnchor).isActive = true
        loadingIndicator.isHidden = true
        
        formContainerStackView.addArrangedSubview(nameInput)
        formContainerStackView.addArrangedSubview(number)
//        formContainerStackView.addArrangedSubview(size)
//        formContainerStackView.addArrangedSubview(gsm)
//        formContainerStackView.addArrangedSubview(fabric)
        formContainerStackView.addArrangedSubview(address)
        formContainerStackView.addArrangedSubview(submitButton)
        

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
   
    @objc func sendGift(){
            if((nameInput.text?.count)! <= 0){
                self.showAlert(message: "Please enter your name")
            }else if((number.text?.count)! <= 0){
                self.showAlert(message: "Please enter Number")
        }else if((address.text?.count)! <= 0){
            self.showAlert(message: "Please enter your address")
        }else{
                self.startLoading()
                let dateFormatter : DateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MMM-dd"
                let date = Date()
                let dateString = dateFormatter.string(from: date)
                var array:[cartModel] = []
                let item = cartModel.init(name: (self.giftItem?.name)!, qty: 1, size: (giftItem?.sizes[0])! as! String, price: 0, fabric: giftItem?.fabric[0] as! String, gsm: giftItem?.gsm[0] as! String )
                array.append(item)
                let jsonData = try! JSONEncoder().encode(array)
                let jsonArray = try! JSONSerialization.jsonObject(with: jsonData, options : .allowFragments) as! [Dictionary<String,Any>]
                let uid = Auth.auth().currentUser!.uid
                
                let docData: [String: Any] = [
                    "uid" : uid,
                    "price" : 0,
                    "address" : self.address.text!,
                    "items" : jsonArray,
                    "date" : dateString,
                    "status" : "Confirmed"
                ]
                
                db.collection("orders").addDocument(data: docData) { (err) in
                    self.stopLoading()
                    if err == nil {
                        let home = HomeVC()
                        self.navigationController?.setViewControllers([home], animated: true)
                    }else{
                        print(err ?? "no error found")
                    }
                }
            }
    }
    
    func startLoading(){
        submitButton.setTitle("", for: .normal)
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
    }
    
    func stopLoading(){
        submitButton.setTitle("Send Gift", for: .normal)
        loadingIndicator.isHidden = true
        loadingIndicator.stopAnimating()
    }
    
    func showAlert(message: String){
        let alert = UIAlertController(title: "oops", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}
