//
//  CartMethods.swift
//  Hermitage
//
//  Created by yogesh on 16/05/19.
//  Copyright © 2019 yogesh. All rights reserved.
//

import Foundation

class CartMethods {
    
    func saveCart(arr: [cartModel]){
        let jsonData = try! JSONEncoder().encode(arr)
        let defaults = UserDefaults.standard
        defaults.set(jsonData, forKey: "cart")
    }
    
    func clearCart(){
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "cart")
    }
    
    func fetchCart() -> [cartModel]{
        var cartarray: [cartModel] = []
        if let cartData = UserDefaults.standard.object(forKey: "cart") as? Data {
            if let cart = try? JSONDecoder().decode([cartModel].self, from: cartData) {
                cartarray = cart
            }
        }
        return cartarray
    }
    
    func checkifExist(arr: [cartModel], title: String, size: String) -> Bool{
        var isExist = false
        arr.forEach { (item) in
            if item.name == title && item.size == size {
                 let qty = item.qty
                if(qty > 0){
                    isExist = true
                }
            }
        }     
            return isExist
    }
    
    func getItem(arr: [cartModel], title: String,size: String) -> cartModel {
        var cartitem: cartModel?
        arr.forEach { (item) in
            if item.name == title && item.size == size {
                cartitem = item
            }
        }
        return cartitem!
    }
    
    func removeIfEmpty(arr: [cartModel], title: String, size: String){
        var cartarray = arr
        cartarray.forEach { (item) in
            if item.name == title && item.size == size{
                let qty = item.qty
                if(qty > 0){
                    if let ind =  cartarray.firstIndex(where: {$0.name == item.name}) {
                        cartarray.remove(at: ind)
                        saveCart(arr: cartarray)
                    }
                }
            }
        }
    }
    
    func removeOneQty(arr: [cartModel], title: String,size: String){
        var cartarray = arr
        var cartitem: cartModel?
         var index = 0
        cartarray.forEach { (item) in
            if item.name == title && item.size == size {
                cartitem = item
                cartitem?.qty = item.qty - 1
                    if(cartitem!.qty <= 0){
                          cartarray.remove(at: index)
                    }else{
                        cartarray[index] = cartitem!
                    }
                    saveCart(arr: cartarray)
            }
             index += 1
        }
    }
    
    func addOneItem(arr: [cartModel], title: String,size: String)  {
        var cartarray = arr
        var cartitem: cartModel?
        var index = 0
        cartarray.forEach { (item) in
            if item.name == title && item.size == size {
                cartitem = item
                cartitem?.qty = item.qty + 1
                cartarray[index] = cartitem!
                saveCart(arr: cartarray)
            }
            index += 1
        }
    }
}


