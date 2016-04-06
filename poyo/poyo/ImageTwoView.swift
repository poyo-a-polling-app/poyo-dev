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
    
    var captureSession : AVCaptureSession?
    var stillImageOutput : AVCaptureStillImageOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    var captureDevice : AVCaptureDevice?

    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var tempImageView: UIImageView!
    @IBOutlet weak var newImageView: UIView!
    
    var delegate : ImageTwoViewDelegate! = nil
    
    @IBOutlet weak var BackAction: UIButton!
    @IBOutlet weak var FrontAction: UIButton!
    
    let vc = UIImagePickerController()
    
    let flerror : NSError? = nil
    
    var input : AVCaptureDeviceInput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.newImageView.hidden = true
        let cameraInte = 1
        //reloadCamera()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        BackAction.hidden = true
        FrontAction.hidden = false
        loadCamera(cameraInte)
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
        super.viewWillAppear(animated)
    }
    
    
    func loadCamera(inte: Int){
        captureSession?.startRunning()
        reloadCamera(inte)
        
        
        captureSession = AVCaptureSession()
        captureSession?.accessibilityFrame = cameraView.bounds
        captureSession?.sessionPreset = AVCaptureSessionPresetPhoto
        
        
                do{
                    input = try AVCaptureDeviceInput(device: captureDevice)
        
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
    
    
    
    func reloadCamera(int: Int) {
        if (int == 2) {
            let videoDevices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo)
            
            for device in videoDevices{
                let device = device as! AVCaptureDevice
                if device.position == AVCaptureDevicePosition.Front {
                    captureDevice = device
                }
            }
        }
        else if (int == 1) {
            captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        }
    }
    
    @IBAction func takeFront(sender: AnyObject) {
        BackAction.hidden = false
        FrontAction.hidden = true
        let cameraInte = 2
        loadCamera(cameraInte)
        //didPressTakeAnother()
    }
    
    
    @IBAction func takeBack(sender: AnyObject) {
        FrontAction.hidden = false
        BackAction.hidden = true
        let cameraInte = 1
        loadCamera(cameraInte)
        //didPressTakeAnother()
    }
    
    func didPressTakePhoto(){
        if let videoConnection = stillImageOutput?.connectionWithMediaType(AVMediaTypeVideo){
            videoConnection.videoOrientation = AVCaptureVideoOrientation.Portrait
            stillImageOutput?.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: {
                    (sampleBuffer, error) in
                
                if sampleBuffer != nil {
                    let
                    imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                    
                    let dataProvider = CGDataProviderCreateWithCFData(imageData)
                    let cgImageRef = CGImageCreateWithJPEGDataProvider(dataProvider, nil, true, .RenderingIntentDefault)
                    
                    let image = UIImage(CGImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.Right)
                    
                   
                    
                    self.tempImageView.contentMode = .ScaleAspectFill
                    self.tempImageView.clipsToBounds = true
                    self.tempImageView.image = image
                    self.newImageView.hidden = false
                }
                
            })
        }
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
