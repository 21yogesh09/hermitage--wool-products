//
//  ScanQRVC.swift
//  Hermitage
//
//  Created by yogesh on 11/05/19.
//  Copyright © 2019 yogesh. All rights reserved.
//

import UIKit
import SwiftIconFont
import AVFoundation
import FirebaseFirestore

class ScanQRVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var qrCodeFrameView:UIView?
     var db = Firestore.firestore()
    
    let qrImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 200))
     let scanLabel = UILabel()
     let enterCodeLabel = UILabel()
     let codeInput = UITextField()
    let nextButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        captureSession = AVCaptureSession()
//        setQRLayout()
//        setupInput()
//        setupButton()
        // Initialize QR Code Frame to highlight the QR code
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        qrCodeFrameView = UIView()
        qrCodeFrameView?.layer.borderColor = UIColor.green.cgColor
        qrCodeFrameView?.layer.borderWidth = 2
        view.addSubview(qrCodeFrameView!)
        view.bringSubviewToFront(qrCodeFrameView!)
        
        captureSession.startRunning()
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         self.tabBarController?.title = "Scan QR Code"
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
              qrCodeFrameView?.frame = metadataObject.bounds;
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
        
        dismiss(animated: true)
    }
    
    func found(code: String) {
        db.collection("products").whereField("offerid", isEqualTo: code).getDocuments { (querySnapshot, error) in
        if error != nil {
            self.showAlert(message: "QR code does not exists in our database.")
            self.captureSession.startRunning()
        }
            if(querySnapshot!.count > 0){
            let vc = ChooseProductVC(collectionViewLayout: UICollectionViewFlowLayout())
            vc.type = code
            self.navigationController?.pushViewController(vc, animated: true);
            }else{
                self.showAlert(message: "QR code does not exists in our database.")
                self.captureSession.startRunning()
            }
    }
        
//        let data: Data? = code.data(using: .utf8)
//        let json = try! JSONDecoder().decode(cartModel.self, from: data!)
//        let
//        print(json)
    }
    
    func showAlert(message: String){
        let alert = UIAlertController(title: "oops", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    
   func setQRLayout(){
    qrImage.image = UIImage(imageLiteralResourceName: "qr")
    view.addSubview(qrImage)
    qrImage.translatesAutoresizingMaskIntoConstraints = false
    qrImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 130).isActive = true
    qrImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    
   
    scanLabel.text = "Scan QR-Code"
    scanLabel.textColor = .blue
    view.addSubview(scanLabel)
    scanLabel.translatesAutoresizingMaskIntoConstraints = false
    scanLabel.topAnchor.constraint(equalTo: qrImage.topAnchor, constant: 176).isActive = true
    scanLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    
    }
    
    func setupInput(){
        codeInput.placeholder = "Enter Code"
        codeInput.textAlignment = .center
        codeInput.backgroundColor = .white
        codeInput.layer.borderColor = UIColor.black.cgColor
        codeInput.layer.borderWidth = 1
        
        view.addSubview(codeInput)
        codeInput.translatesAutoresizingMaskIntoConstraints = false
        codeInput.heightAnchor.constraint(equalToConstant: 50).isActive = true
        codeInput.topAnchor.constraint(equalTo: scanLabel.topAnchor, constant: 100).isActive = true
        codeInput.widthAnchor.constraint(equalToConstant: 150).isActive = true
        codeInput.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        codeInput.layer.cornerRadius = 25
        
        enterCodeLabel.text = "Enter Code"
        enterCodeLabel.textColor = .blue
        view.addSubview(enterCodeLabel)
        enterCodeLabel.translatesAutoresizingMaskIntoConstraints = false
        enterCodeLabel.topAnchor.constraint(equalTo: codeInput.topAnchor, constant: 76).isActive = true
        enterCodeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
 
    }
    
    func setupButton(){
        nextButton.setTitle("Next", for: .normal)
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.backgroundColor = .black
        nextButton.layer.cornerRadius = 25
        view.addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        nextButton.topAnchor.constraint(equalTo: enterCodeLabel.topAnchor, constant: 70).isActive = true

        nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
   

}
