//
//  QRViewController.swift
//  Show-off test
//
//  Created by Sela Shabtai on 31/12/2020.
//

import UIKit
import AVFoundation
import Vision

class QRViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;

    var qrCodeData = [QRCodeData]();
    var coreData = [Entity]();
    
    @IBOutlet var cameraView: UIView!
    @IBOutlet var QRCodeDetectionLabel: UIView!
    
    
    

    let captureSession = AVCaptureSession();
    var videoPreviewLayer : AVCaptureVideoPreviewLayer?
    var count = 0;
    var flag = true;

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video);
        
        do
        {   if let safeCaptureDevice = captureDevice{
            let input = try AVCaptureDeviceInput(device: safeCaptureDevice);
            captureSession.addInput(input);
        }
        
        let captureMetaDataOutput = AVCaptureMetadataOutput();
        captureSession.addOutput(captureMetaDataOutput);
        
        captureMetaDataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main);
        captureMetaDataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr];
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession);
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill;
        videoPreviewLayer?.frame = view.layer.bounds
        cameraView.layer.addSublayer(videoPreviewLayer!);
        
        captureSession.startRunning();
        
        }
        catch{
            print(error);
            return;
        }
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        captureSession.stopRunning();
    }
    
    
    @IBAction func RestartCamBtn(_ sender: UIButton) {
        captureSession.startRunning();
    }
    
    
}
extension QRViewController : AVCaptureMetadataOutputObjectsDelegate{
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count == 0 {
            
            return;
        }
        
        
        let metaDataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metaDataObj.type == AVMetadataObject.ObjectType.dogBody && flag == true
        {
            flag = false;
            QRCodeDetectionLabel.backgroundColor = .green;
            
            let alert = UIAlertController(title: "QR Code", message: metaDataObj.stringValue, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Retake", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "SaveQR", style: .default, handler: { (nil) in
                if let safeQRCode = metaDataObj.stringValue  {
                    let section = "QR Codes"
                    let qrObject = QRCodeData(title: safeQRCode, section: section)
                    let qrToCoreData = Entity(context: self.context);
                    qrToCoreData.title = qrObject.title;
                    qrToCoreData.section = qrObject.section;
                    qrToCoreData.releaseYear = 2500;
                    self.saveItems();
                    self.captureSession.stopRunning()
                }
            }))
            present(alert, animated: true, completion: nil);
            
            if metaDataObj.stringValue != nil {
                print(metaDataObj.stringValue ?? "no string for QR code");
            }
            
        }
        
        
        
        
    }
    func saveItems() {
                do {
                     try context.save()
                    print("Success")
                } catch {
                    print("Error decoding item array, \(error)")
                }
            }
}
