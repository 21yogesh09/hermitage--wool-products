//
//  HealthStatusVC.swift
//  Hermitage
//
//  Created by yogesh on 11/05/19.
//  Copyright © 2019 yogesh. All rights reserved.
//

import UIKit
import SwiftIconFont
import LBTATools
import AAInfographics

class HealthStatusVC: LBTAFormController, UIPickerViewDataSource, UIPickerViewDelegate  {
    
    
    
    let sleepLabel = UILabel(text: "How many hours did you sleep last night?", font: UIFont.boldSystemFont(ofSize: 16), textColor: .white, textAlignment: .center, numberOfLines: 0)
    let feelLabel = UILabel(text: "How did you feel last night?", font: UIFont.boldSystemFont(ofSize: 16), textColor: .white, textAlignment: .center, numberOfLines: 0)
     let templabel = UILabel(text: "What was the room temperature 🤒 last night?", font: UIFont.boldSystemFont(ofSize: 16), textColor: .white, textAlignment: .center, numberOfLines: 0)
    
    var sleepInput = IndentedTextField(placeholder: "Select", padding: 12, cornerRadius: 25, backgroundColor: .white)
    var feelInput = IndentedTextField(placeholder: "Select", padding: 12, cornerRadius: 25, backgroundColor: .white)
    var tempInput = IndentedTextField(placeholder: "Select", padding: 12, cornerRadius: 25, backgroundColor: .white)
    
    let submitButton = UIButton(title: "Save data", titleColor: .white, backgroundColor: UIColor(red:0.13, green:0.59, blue:0.95, alpha:1.0), target: self, action: #selector(getResult))
    let space = UIView()
    let space2 = UIView()
    
    let sleepPicker = UIPickerView()
    let feelPicker = UIPickerView()
    let tempPicker = UIPickerView()
    var score = 0
    var feelscore = 0
    var tempscore = 0
    var sleepscore = 0
    
    var chartdata:[Int] = []
    
    var chart = AAChartView()
    
    
    let sleep = ["0-2","3-4","5-6", "7-9", "10-12"]
    let temp = ["-20°C","-19°C","-18°C","-17°C","-16°C","-15°C","-14°C","-13°C","-12°C","-11°C","-10°C","-9°C","-8°C","-7°C","-6°C","-5°C","-4°C","-3°C","-2°C","-1°C","0°C","1°C","2°C","3°C","4°C","5°C","6°C","7°C","8°C","9°C","10°C","11°C","12°C","13°C","14°C","15°C","16°C","17°C","18°C","19°C","20°C","21°C","22°C","23°C","24°C","25°C","26°C","27°C","28°C","29°C","30°C","31°C","32°C","33°C","34°C","35°C","36°C","37°C","38°C","39°C","40°C","41°C","42°C","43°C","44°C","45°C","46°C","47°C","48°C","49°C","50°C"]
    let feel = ["cold","hot","normal"]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        formContainerStackView.axis = .vertical
        formContainerStackView.spacing = 16
        formContainerStackView.layoutMargins = .init(top: 10, left: 30, bottom: 0, right: 30)
        sleepInput.constrainHeight(50)
        feelInput.constrainHeight(50)
        tempInput.constrainHeight(50)
        submitButton.constrainHeight(50)
        submitButton.layer.cornerRadius = 25
        space2.constrainHeight(30)
        chart.withHeight(230)
        chart.layer.cornerRadius = 7
        
        sleepInput.textAlignment = .center
        feelInput.textAlignment = .center
        tempInput.textAlignment = .center
        
        sleepPicker.dataSource = self
        feelPicker.dataSource = self
        tempPicker.dataSource = self
        
        sleepPicker.delegate = self
        feelPicker.delegate = self
        tempPicker.delegate = self
        
        
        sleepPicker.tag = 1
        feelPicker.tag = 2;
        tempPicker.tag = 3;
        
        sleepInput.inputView = sleepPicker
        feelInput.inputView = feelPicker
        tempInput.inputView = tempPicker
        
        
        formContainerStackView.addArrangedSubview(sleepLabel)
        formContainerStackView.addArrangedSubview(sleepInput)
        formContainerStackView.addArrangedSubview(feelLabel)
        formContainerStackView.addArrangedSubview(feelInput)
        formContainerStackView.addArrangedSubview(templabel)
         formContainerStackView.addArrangedSubview(tempInput)
        formContainerStackView.addArrangedSubview(submitButton)
        formContainerStackView.addArrangedSubview(space2)
        formContainerStackView.addArrangedSubview(chart)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
         self.tabBarController?.title = "Health Status"
         chartdata = fetchForm()
        drawChart(data: fetchForm())
         setGradientBackground()
    }
    
    func drawChart (data: [Int]) {
        let chartModel = AAChartModel()
            .chartType(.line)
            .animationType(.bounce)
            .borderRadius(7)
            .title("How well is your sleep ?")
            .dataLabelEnabled(false)
            .tooltipValueSuffix("%")
            .categories(self.getLast7Days())
            .colorsTheme(["#2396f3"])
            .series([
                AASeriesElement()
                    .name("Sleep Status")
                    .data(data)
                    .toDic()!,])
        
        chart.aa_drawChartWithChartModel(chartModel)
    }
    
    func saveForm(){
        let defaults = UserDefaults.standard
        defaults.set(chartdata, forKey: "chart")
        drawChart(data: fetchForm())
    }
    
    func fetchForm() -> [Int]{
         let defaults = UserDefaults.standard
        var result:[Int]?
        let data = defaults.array(forKey: "chart") as? [Int] ?? []
        
        if data.count > 7 {
            result = Array(data.suffix(7))
        }else if(data.count < 7){
            result = data
            while(result?.count ?? 0 < 7){
                result?.append(0)
            }
        }else{
            result = data
        }
        return result ?? [];
    }
    
    func getLast7Days() -> [String] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let cal = Calendar.current
        var date = cal.startOfDay(for: Date())
        var days = [String]()
        for i in 1 ... 7 {
//            let day = cal.component(.day, from: date)
            days.append(dateFormatter.string(from: date))
            date = cal.date(byAdding: .day, value: -1, to: date)!
        }
        return days.reversed()
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
    
    @objc func getResult(){
        if ((feelscore > 0) && (sleepscore > 0) && (tempscore > 0)){
            score = feelscore + sleepscore
            chartdata.append(score)
            saveForm()
        }else{
            print((feelscore > 0))
            print( (tempscore > 0))
            print( (sleepscore > 0))
        self.showAlert(message: "All fields are required")
        }
    }
    
    func showAlert(message: String){
        let alert = UIAlertController(title: "oops", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        
        
        if pickerView == sleepPicker {
            return sleep.count
            
        } else if pickerView == feelPicker{
            return feel.count
        } else if pickerView == tempPicker {
            return temp.count
        }
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        
        if pickerView == sleepPicker {
            return sleep[row]
            
        } else if pickerView == feelPicker{
            return feel[row]
        } else if pickerView == tempPicker {
            return temp[row]
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == sleepPicker {
            sleepInput.text = sleep[row]
            print(row)
            switch (row){
            case 0 : sleepscore = 20;
            case 1 : sleepscore = 30;
            case 2 : sleepscore = 40;
            case 3 : sleepscore = 45;
            case 4 : sleepscore = 40;
            default:
                sleepscore = 0
            }
        } else if pickerView == feelPicker{
            feelInput.text = feel[row]
            print(row)
            switch (row){
            case 0 : feelscore = 33;
            case 1 : feelscore = 33;
            case 2 : feelscore = 45;
            default:
                tempscore = 0
            }
        } else if pickerView == tempPicker {
            tempInput.text = temp[row]
            tempscore = 1
        }
    }
    
 
}
