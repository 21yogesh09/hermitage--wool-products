
//
//  ProductDetailVC.swift
//  Hermitage
//
//  Created by yogesh on 13/05/19.
//  Copyright © 2019 yogesh. All rights reserved.
//

import UIKit
import LBTATools
import FirebaseAuth
import FirebaseFirestore
import SwiftIconFont
import ImageSlideshow

class ProductDetailVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, ImageSlideshowDelegate {
  
   
    let store = CartMethods()
    
    var slideshow = ImageSlideshow()
    
    var sdWebImageSource:[InputSource] = []
    
    let db = Firestore.firestore()
    var productImage = UIImageView()
    var price = UILabel()
    var productTitle = UILabel()
    let cartButton = UIButton()
    let addButton = UIButton()
    let subButton = UIButton()
    let count = UILabel()
    let descLabel = UILabel()
    var productDescription = UILabel()
    let specsLabel = UILabel()
    var specifications = UILabel()
    let countView = UIView()
    let scrollView = UIScrollView()
    
    var imageNames:[String] = []
    var currentImage = 0
    var currentSize = 0
    var currentGsm = 0
    var currentFabric = 0
    var sizes: [String] = []
    var gsms: [String] = []
    var fabrics: [String] = []
    var prices: [Any] = []
    
    let sizeText = UITextField(placeholder: "Select Size")
    let sizeCard = UIView()
    let sizePicker = UIPickerView()
    let gsmText = UITextField(placeholder: "Select GSM")
    let gsmCard = UIView()
    let gsmPicker = UIPickerView()
    let fabricText = UITextField(placeholder: "Select Fabric")
    let fabricCard = UIView()
    let fabricPicker = UIPickerView()
    
    var currentQty = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.title = "Product Detail"

        imageNames.forEach { (item) in
            sdWebImageSource.append(SDWebImageSource(urlString: item)!)
        }
        
        slideshow.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        pageControl.pageIndicatorTintColor = UIColor.black
        slideshow.pageIndicator = pageControl
         slideshow.setImageInputs(sdWebImageSource)
        slideshow.delegate = self
        let cartIcon =  UIImage(from: .iconic, code: "cart", textColor: .black, backgroundColor: .clear, size: CGSize(width: 30, height: 30))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: cartIcon, style: .plain, target: self, action: #selector(goToCart))
        setViewContent()
        addViews()
        setupViews()
        setupDelegate(picker: sizePicker)
        setupDelegate(picker: gsmPicker)
        setupDelegate(picker: fabricPicker)
        sizeText.text = "Size: \(sizes[0])"
        gsmText.text = "Gsm: \(gsms[0])"
        fabricText.text = "Fabric: \(fabrics[0])"
        
    }
    
    func setupDelegate(picker: UIPickerView){
        picker.delegate   = self
        picker.dataSource = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        fetchCart()
    }
    
    @objc func goToCart(){
        let Cart = CartVC(collectionViewLayout: UICollectionViewFlowLayout())
        self.navigationController?.pushViewController(Cart, animated: true)
    }
    
    
    @objc func onAddtoCart(){
        var array = store.fetchCart()
        let item = cartModel.init(name: self.productTitle.text!, qty: 1, size: sizes[currentSize] , price: prices[currentSize] as! Int, fabric: fabrics[currentFabric], gsm: gsms[currentGsm])
        array.append(item)
        saveCart(arr: array)
        fetchCart()
    }
    
    func saveCart(arr: [cartModel]){
       store.saveCart(arr: arr)
    }
    
    func fetchCart(){
        let arr = store.fetchCart()
        let title = self.productTitle.text!
        let size =  sizes[currentSize]
        if(store.checkifExist(arr: arr, title: title,size: size)){
            self.hideCart()
            let item = store.getItem(arr: arr, title: title,size: size)
            self.count.text = String(describing: item.qty)
        }else{
            store.removeIfEmpty(arr: arr, title: title,size: size)
            self.showCart()
        }
    }
    
    @objc func onPlusButton(){
        let arr = store.fetchCart()
        let size =  sizes[currentSize]
        let title = self.productTitle.text!
        store.addOneItem(arr: arr, title: title,size: size)
        fetchCart()
    }
    
    @objc func onSubButton(){
         let arr = store.fetchCart()
        let size =  sizes[currentSize]
        let title = self.productTitle.text!
        store.removeOneQty(arr: arr, title: title,size: size)
        fetchCart()
    }
    
    func hideCart(){
    self.cartButton.isHidden = true
    self.countView.isHidden = false
    }
    
    func showCart(){
        self.cartButton.isHidden = false
        self.countView.isHidden = true
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case sizePicker:
            return sizes.count
        case gsmPicker:
            return gsms.count
        case fabricPicker:
            return fabrics.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case sizePicker:
            return sizes[row]
        case gsmPicker:
            return gsms[row]
        case fabricPicker:
            return fabrics[row]
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == sizePicker {
            currentSize = row
            sizeText.text = "Size: \(sizes[currentSize])"
            price.text = "Price: $\(prices[currentSize])"
            fetchCart()
        }
        if pickerView == gsmPicker {
            currentGsm = row;
            gsmText.text = "GSM: \(gsms[currentGsm])"
        }
        if pickerView == fabricPicker {
            currentFabric = row
            fabricText.text = "Fabric: \(fabrics[currentFabric])"
        }
    }
    
    
    func addViews(){
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width, height: 100)
        layout.scrollDirection = .horizontal

        
        sizeCard.addSubview(sizeText)
        gsmCard.addSubview(gsmText)
        fabricCard.addSubview(fabricText)
        
        scrollView.isScrollEnabled = true
        scrollView.addSubview(slideshow)
        scrollView.addSubview(sizeCard)
        scrollView.addSubview(fabricCard)
        scrollView.addSubview(gsmCard)
        scrollView.addSubview(price)
        scrollView.addSubview(productTitle)
        scrollView.addSubview(cartButton)
        
        
        countView.addSubview(subButton)
        countView.addSubview(count)
        countView.addSubview(addButton)
        
        cartButton.addTarget(self, action: #selector(onAddtoCart), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(onPlusButton), for: .touchUpInside)
        subButton.addTarget(self, action: #selector(onSubButton), for: .touchUpInside)
        
        scrollView.addSubview(countView)
        descLabel.text = "Description"
        scrollView.addSubview(descLabel)
        scrollView.addSubview(productDescription)
        specsLabel.text = "Specifications"
        scrollView.addSubview(specsLabel)
        scrollView.addSubview(specifications)
        view.addSubview(scrollView)
    }
    
    func setViewContent(){
        price.font = price.font.withSize(16)
        price.textColor = UIColor(red:0.21, green:0.77, blue:0.00, alpha:1.0)
        price.text = "Price: $\(prices[currentSize])"
        productTitle.numberOfLines = 0
        
        
        cartButton.backgroundColor = UIColor(red:0.21, green:0.77, blue:0.00, alpha:1.0)
        cartButton.layer.cornerRadius = 20
        cartButton.setTitle("Add to cart", for: .normal)
        cartButton.setTitleColor(.white, for: .normal)
        countView.isHidden = true
        
        addButton.backgroundColor = UIColor(red:0.30, green:0.69, blue:0.31, alpha:1.0)
        addButton.layer.cornerRadius = 40 / 2
        addButton.setTitle("+", for: .normal)
        addButton.setTitleColor(.white, for: .normal)
        
        setupPickerCard(card: sizeCard, text: sizeText, picker: sizePicker)
        setupPickerCard(card: gsmCard, text: gsmText, picker: gsmPicker)
        setupPickerCard(card: fabricCard, text: fabricText, picker: fabricPicker)
        
        count.text = "0"
        
        subButton.backgroundColor = UIColor(red:0.96, green:0.26, blue:0.21, alpha:1.0)
        subButton.layer.cornerRadius = 40 / 2
        subButton.setTitle("-", for: .normal)
        subButton.setTitleColor(.white, for: .normal)
        
        descLabel.font = UIFont.boldSystemFont(ofSize: 17)
        descLabel.textColor = .gray
        productDescription.numberOfLines = 0
        
        specsLabel.font = UIFont.boldSystemFont(ofSize: 17)
        specsLabel.textColor = .gray
        specifications.numberOfLines = 0
        
    }
    
    func setupPickerCard(card: UIView, text: UITextField, picker: UIPickerView){
        card.layer.shadowColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0).cgColor
        card.layer.cornerRadius = 4
        card.layer.shadowOffset = CGSize(width: 0, height: 4)
        card.layer.shadowOpacity = 0.4
        card.layer.shadowRadius = 10
        card.backgroundColor = UIColor(red:0.07, green:0.20, blue:0.34, alpha:1.0)
        text.textColor = .white
        text.inputView = picker
        text.tintColor = .clear
    }
    
    func setupViews(){
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        
        slideshow.translatesAutoresizingMaskIntoConstraints = false
        
        slideshow.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        slideshow.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        slideshow.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10).isActive = true
        slideshow.heightAnchor.constraint(equalToConstant: view.frame.height / 3).isActive = true
        
        sizeCard.translatesAutoresizingMaskIntoConstraints = false
        sizeCard.topAnchor.constraint(equalTo: slideshow.bottomAnchor, constant: 10).isActive = true
        sizeCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        sizeCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        sizeCard.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        gsmCard.translatesAutoresizingMaskIntoConstraints = false
        gsmCard.topAnchor.constraint(equalTo: sizeCard.bottomAnchor, constant: 10).isActive = true
        gsmCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        gsmCard.heightAnchor.constraint(equalToConstant: 50).isActive = true
        gsmCard.widthAnchor.constraint(equalToConstant: (view.frame.width / 2) - 24 ).isActive = true
        
        fabricCard.translatesAutoresizingMaskIntoConstraints = false
        fabricCard.topAnchor.constraint(equalTo: sizeCard.bottomAnchor, constant: 10).isActive = true
        fabricCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        fabricCard.heightAnchor.constraint(equalToConstant: 50).isActive = true
        fabricCard.widthAnchor.constraint(equalToConstant: (view.frame.width / 2) - 24 ).isActive = true
    
        setupTextInsidePicker(text: sizeText, card: sizeCard)
        setupTextInsidePicker(text: fabricText, card: fabricCard)
        setupTextInsidePicker(text: gsmText, card: gsmCard)
        
        
        productTitle.translatesAutoresizingMaskIntoConstraints = false
        productTitle.topAnchor.constraint(equalTo: fabricCard.bottomAnchor, constant: 10).isActive = true
        productTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        productTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -136).isActive = true
        
        price.translatesAutoresizingMaskIntoConstraints = false
        price.topAnchor.constraint(equalTo: productTitle.bottomAnchor, constant: 16).isActive = true
        price.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        
        cartButton.translatesAutoresizingMaskIntoConstraints = false
        cartButton.topAnchor.constraint(equalTo: fabricCard.bottomAnchor, constant: 10).isActive = true
        cartButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        cartButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        cartButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        // count view start
        
        countView.translatesAutoresizingMaskIntoConstraints = false
    
        countView.topAnchor.constraint(equalTo: fabricCard.bottomAnchor, constant: 10).isActive = true
        countView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        countView.heightAnchor.constraint(equalToConstant: 45).isActive = true
        countView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        subButton.translatesAutoresizingMaskIntoConstraints = false
        subButton.leadingAnchor.constraint(equalTo: countView.leadingAnchor).isActive = true
        subButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        subButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        subButton.centerYAnchor.constraint(equalTo: count.centerYAnchor).isActive = true
        
        
        count.translatesAutoresizingMaskIntoConstraints = false
        count.centerXAnchor.constraint(equalTo: countView.centerXAnchor).isActive = true
        count.centerYAnchor.constraint(equalTo: countView.centerYAnchor).isActive = true
        
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.trailingAnchor.constraint(equalTo: countView.trailingAnchor).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        addButton.centerYAnchor.constraint(equalTo: count.centerYAnchor).isActive = true
        
        
        //count view end
        
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.topAnchor.constraint(equalTo: price.bottomAnchor, constant: 16).isActive = true
        descLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        
        productDescription.translatesAutoresizingMaskIntoConstraints = false
        productDescription.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: 16).isActive = true
        productDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        productDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        specsLabel.translatesAutoresizingMaskIntoConstraints = false
        specsLabel.topAnchor.constraint(equalTo: productDescription.bottomAnchor, constant: 16).isActive = true
        specsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        
        specifications.translatesAutoresizingMaskIntoConstraints = false
        specifications.topAnchor.constraint(equalTo: specsLabel.bottomAnchor, constant: 16).isActive = true
        specifications.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        specifications.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
    }
    
    func setupTextInsidePicker(text: UITextField, card: UIView){
        text.translatesAutoresizingMaskIntoConstraints = false
        text.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16).isActive = true
        text.centerYAnchor.constraint(equalTo: card.centerYAnchor).isActive = true
    }
    

 

}
