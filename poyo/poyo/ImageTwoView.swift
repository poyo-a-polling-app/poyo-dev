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
    func setImage(image: UIImage, int: Int, rev: Int);
}

class ImageTwoView: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var senderInt: Int! = nil
    var frontInt: Int! = nil
    var isFront: Bool?
    
    @IBOutlet weak var didTake: UIButton!

    var captureSession : AVCaptureSession?
    var stillImageOutput : AVCaptureStillImageOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?

    var captureDevice : AVCaptureDevice?

    @IBOutlet weak var realCaptureButton: UIButton!
    @IBOutlet weak var captureButton: UIButton!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var tempImageView: UIImageView!
    @IBOutlet weak var newImageView: UIView!

    var delegate : ImageTwoViewDelegate! = nil

    @IBOutlet weak var BackAction: UIButton!
    @IBOutlet weak var FrontAction: UIButton!

    var currentCameraPosition: AVCaptureDevicePosition = .Back

    let vc = UIImagePickerController()

    let flerror : NSError? = nil

    var input : AVCaptureDeviceInput?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.newImageView.hidden = true
        self.didTake.hidden = true
        self.tabBarController?.tabBar.hidden = true
        //reloadCamera()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        BackAction.hidden = true
        FrontAction.hidden = false
        videoDeviceWithPosition(currentCameraPosition)
        frontInt = 2
        isFront = false
        loadCamera()
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
        self.navigationController?.navigationBar.barTintColor = UIColor.blackColor()
    }

    override func willMoveToParentViewController(parent: UIViewController?) {
        if parent == nil {
            self.navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
            self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        }
    }



    //loads the camera in in order to crop to whatever the image view is
    func loadCamera(){


        captureSession = AVCaptureSession()
        captureSession?.accessibilityFrame = cameraView.bounds
        captureSession?.sessionPreset = AVCaptureSessionPresetPhoto

        let backCamera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)

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

    //sets the device to either front or back
    func videoDeviceWithPosition(position: AVCaptureDevicePosition) -> AVCaptureDevice? {
        if (position == .Front) {
            let videoDevices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo)

            for device in videoDevices {
                if device.position == AVCaptureDevicePosition.Front {
                    captureDevice = device as? AVCaptureDevice
                    return captureDevice!
                }
            }
        }
        else {
            captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
            return captureDevice!
        }
        print("No device found")
        return nil
    }


    //toggles the camera
    func toggleCamera() {
        let newPosition: AVCaptureDevicePosition = self.currentCameraPosition == .Back ? .Front : .Back
        let sessionPreset = AVCaptureSessionPreset640x480

        // Remove all old inputs
        let inputs = captureSession?.inputs
        for input in inputs! {
            captureSession?.removeInput(input as! AVCaptureInput)
        }

        let device = self.videoDeviceWithPosition(newPosition)!
        var deviceInput: AVCaptureDeviceInput
        do {
            deviceInput = try AVCaptureDeviceInput(device: device)
        } catch {
            print("Exception while getting device input")
            return
        }

        guard let captureSession = captureSession else {
            print("CaptureSession was nil")
            return
        }

        captureSession.beginConfiguration()
        captureSession.sessionPreset = sessionPreset

        if captureSession.canAddInput(deviceInput) {
            captureSession.addInput(deviceInput)
            self.currentCameraPosition = newPosition
        } else {
            print("Error trying to add input")
            return
        }

        if device.supportsAVCaptureSessionPreset(sessionPreset) {
            captureSession.sessionPreset = sessionPreset
        }

        do {
            try device.lockForConfiguration()
        } catch {
            print("Error when trying to lock device for configuration")
            return
        }

        device.subjectAreaChangeMonitoringEnabled = true
        device.unlockForConfiguration()
        captureSession.commitConfiguration()
    }

    //switch to the front camera
    @IBAction func takeFront(sender: AnyObject) {
        BackAction.hidden = false
        FrontAction.hidden = true
        isFront = true
        frontInt = nil
        frontInt = 1
        toggleCamera()
    }

    //switch back to the back camera from the front camera
    @IBAction func takeBack(sender: AnyObject) {
        FrontAction.hidden = false
        BackAction.hidden = true
        isFront = false
        frontInt = nil
        frontInt = 2
        toggleCamera()
    }


    //takes a photo of preview layer
    func didPressTakePhoto(){
        if let videoConnection = stillImageOutput?.connectionWithMediaType(AVMediaTypeVideo){
            videoConnection.videoOrientation = AVCaptureVideoOrientation.Portrait
            stillImageOutput?.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: {
                    (sampleBuffer, error) in

                if sampleBuffer != nil {
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)

                    let dataProvider = CGDataProviderCreateWithCFData(imageData)
                    let cgImageRef = CGImageCreateWithJPEGDataProvider(dataProvider, nil, true, .RenderingIntentDefault)

                    let image = UIImage(CGImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.Right)

                    if self.frontInt == 1 {
                        self.tempImageView.image = image
                        self.tempImageView.transform = CGAffineTransformMakeScale(-1, 1)
                    }
                    else if self.frontInt == 2{
                        self.tempImageView.image = image
                        self.tempImageView.transform = CGAffineTransformIdentity
                    }

                    self.tempImageView.contentMode = .ScaleAspectFill
                    self.tempImageView.clipsToBounds = true
                    self.tempImageView.image = image
                    self.newImageView.hidden = false
                    self.didTake.hidden = false
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
                self.didTake.hidden = false
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
            self.didTake.hidden = true
            didTakePhoto = false
        }
        else {
            captureSession?.startRunning()
            didTakePhoto = true
            didPressTakePhoto()
        }

    }
    @IBAction func onSend(sender: AnyObject) {
        delegate.setImage(self.tempImageView.image!, int: senderInt, rev: frontInt)
        self.navigationController?.popViewControllerAnimated(true)
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
