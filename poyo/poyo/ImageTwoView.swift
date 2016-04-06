//
//  ImageTwoView.swift
//  poyo
//
//  Created by Kevin Asistores on 3/29/16.
//  Copyright © 2016 Takashi Wickes. All rights reserved.
//

import UIKit
import AVFoundation

protocol ImageTwoViewDelegate {
    func setImage(image: UIImage, int: Int);
}

class ImageTwoView: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var senderInt: Int! = nil
    var cameraInt: Int! = nil
    
    var captureSession : AVCaptureSession?
    var stillImageOutput : AVCaptureStillImageOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    var captureDevice : AVCaptureDevice? = nil

    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var tempImageView: UIImageView!
    @IBOutlet weak var newImageView: UIView!
    
    var delegate : ImageTwoViewDelegate! = nil
    
    @IBOutlet weak var BackAction: UIButton!
    @IBOutlet weak var FrontAction: UIButton!
    
    let vc = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.newImageView.hidden = true
        cameraInt = 1
        //reloadCamera()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        BackAction.hidden = true
        FrontAction.hidden = false
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        previewLayer?.frame = cameraView.bounds
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        print(cameraInt)
        
        //super.viewWillAppear(animated)
        //captureSession?.stopRunning()
        //captureDevice
        //reloadCamera()
        
        captureSession = AVCaptureSession()
        captureSession?.accessibilityFrame = cameraView.bounds
        captureSession?.sessionPreset = AVCaptureSessionPresetPhoto
        captureSession?.sessionPreset = AVCaptureSessionPresetPhoto
        
        
        
        let devices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo)
        for device in devices {
            // Make sure this particular device supports video
            if (device.hasMediaType(AVMediaTypeVideo)) {
                // Finally check the position and confirm we've got the back camera
                if(device.position == AVCaptureDevicePosition.Back && cameraInt == 1) {
                    captureDevice = device as? AVCaptureDevice
                    print("yas")
                    viewWillAppear(true)
                }
                else if(device.position == AVCaptureDevicePosition.Front && cameraInt == 2) {
                    captureDevice = device as? AVCaptureDevice
                    print("noo")
                    viewWillAppear(true)
                }
                
            }
        }
        
        
        var flerror : NSError?
        
        do{
            var input = try AVCaptureDeviceInput(device: captureDevice)
        
        if (flerror == nil && captureSession?.canAddInput(input) != nil){
            captureSession?.addInput(input)
            
            stillImageOutput = AVCaptureStillImageOutput()
            
            stillImageOutput?.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
            
            if ((captureSession?.canAddOutput(stillImageOutput)) != nil){
                captureSession?.addOutput(stillImageOutput)
                previewLayer?.frame = cameraView.bounds
                previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
                previewLayer?.connection.videoOrientation = AVCaptureVideoOrientation.Portrait
                cameraView.layer.addSublayer(previewLayer!)
                captureSession?.startRunning()
            }
        }
        }
        catch{
            fatalError("Could not create capture device input.")
        }
    }
    
    func configureDevice() {
        if let device = captureDevice {
            device.lockForConfiguration(nil)
            device.focusMode = .Locked
            device.unlockForConfiguration()
        }
        
    }
    
    func beginSession() {
        
        configureDevice()
        
        var err : NSError? = nil
        captureSession.addInput(AVCaptureDeviceInput(device: captureDevice, error: &err))
        
        if err != nil {
            println("error: \(err?.localizedDescription)")
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.view.layer.addSublayer(previewLayer)
        previewLayer?.frame = self.view.layer.frame
        captureSession.startRunning()
    }
    
    func didPressTakePhoto(){
        if let videoConnection = stillImageOutput?.connectionWithMediaType(AVMediaTypeVideo){
            videoConnection.videoOrientation = AVCaptureVideoOrientation.Portrait
            stillImageOutput?.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: {
                    (sampleBuffer, error) in
                
                if sampleBuffer != nil {
                    var imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                    
                    var dataProvider = CGDataProviderCreateWithCFData(imageData)
                    var cgImageRef = CGImageCreateWithJPEGDataProvider(dataProvider, nil, true, .RenderingIntentDefault)
                    
                    var image = UIImage(CGImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.Right)
                    
                   
                    
                    self.tempImageView.contentMode = .ScaleAspectFill
                    self.tempImageView.clipsToBounds = true
                    self.tempImageView.image = image
                    self.newImageView.hidden = false
                }
                
            })
        }
    }
    
    @IBAction func takeFront(sender: AnyObject) {
        FrontAction.hidden = true
        BackAction.hidden = false
        cameraInt = 2
        //viewWillAppear(true)
    }
    
   
    @IBAction func takeBack(sender: AnyObject) {
        FrontAction.hidden = false
        BackAction.hidden = true
        cameraInt = 1
        //viewWillAppear(true)
    }

    
    var didTakePhoto = Bool()
    
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject]) {
            let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
            
            vc.dismissViewControllerAnimated(true) { () -> Void in
                self.tempImageView.image = editedImage
                self.newImageView.hidden = false
                self.didTakePhoto = true
            }
    }
    
    @IBAction func didTakeImage(sender: AnyObject) {
        didPressTakeAnother()
    }
    
    @IBAction func retryButton(sender: AnyObject) {
        didPressTakeAnother()
    }
    
    @IBAction func didFindImage(sender: AnyObject) {
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func didPressTakeAnother(){
        if didTakePhoto == true{
            self.newImageView.hidden = true
            didTakePhoto = false
        }
        else {
            captureSession?.startRunning()
            didTakePhoto = true
            didPressTakePhoto()
        }
        
    }
    
    @IBAction func dismiss(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onSend(sender: AnyObject) {
        delegate.setImage(self.tempImageView.image!, int: senderInt)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func reloadCamera() {
        //captureSession?.stopRunning()
        //captureSession?.delete(previewLayer)
        // camera loading code
        // var backCamera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        if (cameraInt == 2) {
            let videoDevices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo)
            
            for device in videoDevices{
                let device = device as! AVCaptureDevice
                if device.position == AVCaptureDevicePosition.Front {
                    captureDevice = device
                    break
                }
            }
        } else {
            captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
            captureSession?.startRunning()
        }
    }
    
    
    // MARK: - Navigation

     //In a storyboard-based application, you will often want to do a little preparation before navigation
    /*override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var sendImage : ComposeViewController = segue.destinationViewController as! ComposeViewController
        
        if senderInt == 1{
            sendImage.imageOne = tempImageView.image
        }
        else if senderInt == 2{
            sendImage.imageTwo = tempImageView.image
        }
                // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }*/
    

}
