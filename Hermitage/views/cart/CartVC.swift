//
//  CartVC.swift
//  Hermitage
//
//  Created by yogesh on 14/05/19.
//  Copyright © 2019 yogesh. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import BraintreeDropIn
import Braintree
import GooglePlaces


public struct cartModel: Codable {
    var name:String
    var qty: Int
    var size: String
    var price: Int
    var fabric: String
    var gsm: String
}

class CartVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, BTViewControllerPresentingDelegate, BTAppSwitchDelegate, GMSAutocompleteViewControllerDelegate {
  
    
   
  let apiClient = BTAPIClient(authorization: "sandbox_q7jtzw7s_gmrp57ykp8mb7388")
    
     private let cellReuseIdentifier = "cart"
    var db = Firestore.firestore()
    var cartData: [cartModel] = []
    let checkOutView = UIView()
    var store = CartMethods()
    let addressBar = UITextField()
    let checkoutButton = UIButton()
    var finalPrice = 0
    var loading = false
    let loadingIndicator = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Cart"
        
        view.backgroundColor = .white
        
        setupViews()
        setupCheckoutButton()
        
        fetchData()
    }
    
    @objc func showDropIn() {
        print("payment")
        if((addressBar.text?.count)! <= 0){
            showAlert(message: "Please enter your address")
        }else{
        let payPalDriver = BTPayPalDriver(apiClient: self.apiClient!)
        payPalDriver.viewControllerPresentingDelegate = self
        payPalDriver.appSwitchDelegate = self
        let request = BTPayPalRequest(amount: "\(finalPrice).00")
         self.startLoading()
        payPalDriver.requestOneTimePayment(request) { (tokenizedPayPalAccount, error) -> Void in
            guard let tokenizedPayPalAccount = tokenizedPayPalAccount else {
                if error != nil {
                      self.stopLoading()
                    // Handle error
                } else {
                 self.stopLoading()
                    // User canceled
                }
                return
            }
             self.placeOrder()
            print("Got a nonce! \(tokenizedPayPalAccount.nonce)")
            if let address = tokenizedPayPalAccount.billingAddress {
                
            }
        }
        }
    }
    
    @objc func autocompleteClicked(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
            UInt(GMSPlaceField.placeID.rawValue))!
        autocompleteController.placeFields = fields
        
        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .address
        autocompleteController.autocompleteFilter = filter
        
        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
    }
    
    func paymentDriver(_ driver: Any, requestsPresentationOf viewController: UIViewController) {
          present(viewController, animated: true, completion: nil)
    }
    
    func paymentDriver(_ driver: Any, requestsDismissalOf viewController: UIViewController) {
           viewController.dismiss(animated: true, completion: nil)
    }
    
    func appSwitcherWillPerformAppSwitch(_ appSwitcher: Any) {
         NotificationCenter.default.addObserver(self, selector: #selector(fetchData), name: NSNotification.Name.NSExtensionHostDidBecomeActive, object: nil)
    }
    
    func appSwitcher(_ appSwitcher: Any, didPerformSwitchTo target: BTAppSwitchTarget) {
      print("d")
    }
    
    func appSwitcherWillProcessPaymentInfo(_ appSwitcher: Any) {
       print("s")
    }
    
    func calculateTotal() {
        var total = 0
        for item in cartData {
            total += item.qty * item.price
            
        }
        finalPrice = total
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Total: $\(total)", style: .plain, target: self, action: nil)
    }
    
    @objc func fetchData() {
        self.cartData = store.fetchCart()
        self.collectionView.reloadData()
        self.calculateTotal()
        self.goBackIfEmpty()
    }
    
    func goBackIfEmpty(){
        if cartData.count <= 0 {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func placeOrder(){
            self.startLoading()
            let dateFormatter : DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MMM-dd"
            let date = Date()
            let dateString = dateFormatter.string(from: date)
            let jsonData = try! JSONEncoder().encode(cartData)
            let jsonArray = try! JSONSerialization.jsonObject(with: jsonData, options : .allowFragments) as! [Dictionary<String,Any>]
            let uid = Auth.auth().currentUser!.uid

        let docData: [String: Any] = [
            "uid" : uid,
            "price" : finalPrice,
            "address" : self.addressBar.text!,
            "items" : jsonArray,
            "date" : dateString,
            "status" : "Confirmed"
        ]
            
        db.collection("orders").addDocument(data: docData) { (err) in
            self.stopLoading()
            if err == nil {
                            self.store.clearCart()
                            let home = HomeVC()
                            self.navigationController?.setViewControllers([home], animated: true)
            }else{
                print(err ?? "no error found")
            }
        }
    }
    
    func showAlert(message: String){
        let alert = UIAlertController(title: "oops", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @objc func onPlusButton(sender: UIButton){
          let index = sender.tag
        let title = cartData[index].name
        let size = cartData[index].size
        let arr = store.fetchCart()
        store.addOneItem(arr: arr, title: title,size: size)
        fetchData()
    }
    
    @objc func onSubButton(sender: UIButton){
        let index = sender.tag
        let title = cartData[index].name
        let size = cartData[index].size
        let arr = store.fetchCart()
        store.removeOneQty(arr: arr, title: title,size: size)
        fetchData()
    }
    
    

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cartData.count
    }
    
    
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! CartItemCell
        let data = cartData[indexPath.row]
        let name =  data.name
        cell.title.text = name
        cell.count.text = "\(String(describing: cartData[indexPath.row].qty))"
        cell.price.text = "\(data.size) | Price: $\(data.price * data.qty)"
        cell.addButton.tag = indexPath.row
        cell.subButton.tag = indexPath.row
        cell.addButton.addTarget(self, action: #selector(onPlusButton(sender:)), for: .touchUpInside)
        cell.subButton.addTarget(self, action: #selector(onSubButton(sender:)), for: .touchUpInside)
        return cell
    }
    
    
    func startLoading(){
        checkoutButton.setTitle("", for: .normal)
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
    }
    
    func stopLoading(){
        checkoutButton.setTitle("Check Out", for: .normal)
        loadingIndicator.isHidden = true
        loadingIndicator.stopAnimating()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 70)
    }
    
    func setupViews(){
        view.addSubview(checkOutView)
        
        checkOutView.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
        checkOutView.translatesAutoresizingMaskIntoConstraints = false
        checkOutView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive  = true
        checkOutView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        checkOutView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = .white
        collectionView?.register(CartItemCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -206).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        addressBar.backgroundColor = .white
        addressBar.layer.borderWidth = 0.5
        addressBar.layer.borderColor = UIColor.gray.cgColor
        addressBar.contentVerticalAlignment = .top;
        addressBar.font = addressBar.font?.withSize(14)
        addressBar.placeholder = "Enter Your Address"
        addressBar.addTarget(self, action: #selector(autocompleteClicked(_:)), for: .allEditingEvents)
        addressBar.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: addressBar.frame.height))
        addressBar.leftViewMode = .always
        addressBar.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: addressBar.frame.height))
        addressBar.rightViewMode = .always
        addressBar.layer.cornerRadius = 6
        checkOutView.addSubview(addressBar)
        
        addressBar.translatesAutoresizingMaskIntoConstraints = false
        addressBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        addressBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        addressBar.bottomAnchor.constraint(equalTo: checkOutView.bottomAnchor, constant: -100).isActive = true
        addressBar.topAnchor.constraint(equalTo: checkOutView.topAnchor, constant: 16).isActive = true
    }
    
    func setupCheckoutButton(){
        loadingIndicator.color = .white
        loadingIndicator.isHidden = true
      
        checkoutButton.setTitle("Check Out", for: .normal)
        checkoutButton.setTitleColor(.white, for: .normal)
        checkoutButton.backgroundColor = UIColor(red:0.13, green:0.59, blue:0.95, alpha:1.0)
        checkoutButton.addSubview(loadingIndicator)
        checkOutView.addSubview(checkoutButton)
        checkoutButton.addTarget(self, action: #selector(showDropIn), for: .touchUpInside)
        checkoutButton.translatesAutoresizingMaskIntoConstraints = false
        checkoutButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        checkoutButton.topAnchor.constraint(equalTo: addressBar.bottomAnchor, constant: 16).isActive = true
        checkoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        checkoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        checkoutButton.layer.cornerRadius = 25
        
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.centerXAnchor.constraint(equalTo: checkoutButton.centerXAnchor).isActive = true
        loadingIndicator.centerYAnchor.constraint(equalTo: checkoutButton.centerYAnchor).isActive = true
    }
    
}

extension CartVC {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
       self.addressBar.text = place.name
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
