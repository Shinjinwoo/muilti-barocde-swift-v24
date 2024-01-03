//
//  MultiBarcodePluginViewController.swift
//  v24swift
//
//  Created by 신진우 on 12/22/23.
//

import UIKit
import AVFoundation
import CoreVideo
import MLImage
import MLKit

enum Constant {
    static let CODE_SUCCES = 0
    static let CODE_ERROR = -1
    static let CODE_PERMISSION_ERROR = -9
    
    static let NEXA_FORMAT_ALL = 0;
    static let MLKIT_FORMAT_ALL = 0xFFFF;
    
    static let sessionQueueLabel = "com.google.mlkit.visiondetector.SessionQueue"
    static let videoDataOutputQueueLabel = "com.google.mlkit.visiondetector.VideoDataOutputQueue"
}

class MultiBarcodeViewController: UIViewController {
    
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var captureBtn: UIButton!
    
    var isUseFrontCamera: Bool? = false
    var isUseTextLabel: Bool? = true
    var isUseSoundEffect: Bool? = true
    var isUseTimer: Bool? = false
    var isUseAutoCapture: Bool? = false
    var isUseVibration: Bool? = true
    var isUsePinchZoom: Bool? = false
    var isUnlimitedTime: Bool? = false
    var selectingCount: Int? = 2
    var barcodeFormat: Int = Constant.MLKIT_FORMAT_ALL
    var limitCount: Int? = 100
    var limitTime: CGFloat? = 10
    var zoomFactor: CGFloat? = 1.5
    var boxColor: UIColor?
    
    
    var device: AVCaptureDevice?
    
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private lazy var captureSession = AVCaptureSession()
    private lazy var sessionQueue = DispatchQueue(label: Constant.sessionQueueLabel)
    private var lastFrame: CMSampleBuffer?
    
    private lazy var previewOverlayView: UIImageView = {
      precondition(isViewLoaded)
      let previewOverlayView = UIImageView(frame: .zero)
      previewOverlayView.contentMode = UIView.ContentMode.scaleAspectFill
      previewOverlayView.translatesAutoresizingMaskIntoConstraints = false
      return previewOverlayView
    }()

    private lazy var annotationOverlayView: UIView = {
      precondition(isViewLoaded)
      let annotationOverlayView = UIView(frame: .zero)
      annotationOverlayView.translatesAutoresizingMaskIntoConstraints = false
      return annotationOverlayView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        previewLayer.videoGravity = .resize
        previewLayer.connection?.videoOrientation = .portrait
        
        setUpPreviewOverlayView()
        setUpAnnotationOverlayView()
        setUpCaptureSessionOutput()
        setUpCaptureSessionInput()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startSession()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopSession()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        previewLayer.frame = cameraView.frame
    }
    
    private func startSession() {
      weak var weakSelf = self
      sessionQueue.async {
        guard let strongSelf = weakSelf else {
          print("Self is nil!")
          return
        }
        strongSelf.captureSession.startRunning()
      }
    }
    
    private func stopSession() {
      weak var weakSelf = self
      sessionQueue.async {
        guard let strongSelf = weakSelf else {
          print("Self is nil!")
          return
        }
        strongSelf.captureSession.stopRunning()
      }
    }
    
    private func setUpPreviewOverlayView() {
      cameraView.addSubview(previewOverlayView)
      NSLayoutConstraint.activate([
        previewOverlayView.centerXAnchor.constraint(equalTo: cameraView.centerXAnchor),
        previewOverlayView.centerYAnchor.constraint(equalTo: cameraView.centerYAnchor),
        previewOverlayView.leadingAnchor.constraint(equalTo: cameraView.leadingAnchor),
        previewOverlayView.trailingAnchor.constraint(equalTo: cameraView.trailingAnchor),
      ])
    }

    private func setUpAnnotationOverlayView() {
      cameraView.addSubview(annotationOverlayView)
      NSLayoutConstraint.activate([
        annotationOverlayView.topAnchor.constraint(equalTo: cameraView.topAnchor),
        annotationOverlayView.leadingAnchor.constraint(equalTo: cameraView.leadingAnchor),
        annotationOverlayView.trailingAnchor.constraint(equalTo: cameraView.trailingAnchor),
        annotationOverlayView.bottomAnchor.constraint(equalTo: cameraView.bottomAnchor),
      ])
    }
    
    private func setUpCaptureSessionOutput() {
      weak var weakSelf = self
      sessionQueue.async {
        guard let strongSelf = weakSelf else {
          print("Self is nil!")
          return
        }
        strongSelf.captureSession.beginConfiguration()
        // When performing latency tests to determine ideal capture settings,
        // run the app in 'release' mode to get accurate performance metrics
        strongSelf.captureSession.sessionPreset = AVCaptureSession.Preset.medium

        let output = AVCaptureVideoDataOutput()
        output.videoSettings = [
          (kCVPixelBufferPixelFormatTypeKey as String): kCVPixelFormatType_32BGRA
        ]
        output.alwaysDiscardsLateVideoFrames = true
        let outputQueue = DispatchQueue(label: Constant.videoDataOutputQueueLabel)
        output.setSampleBufferDelegate(strongSelf, queue: outputQueue)
        guard strongSelf.captureSession.canAddOutput(output) else {
          print("Failed to add capture session output.")
          return
        }
        strongSelf.captureSession.addOutput(output)
        strongSelf.captureSession.commitConfiguration()
      }
    }
    
    private func setUpCaptureSessionInput() {
        weak var weakSelf = self
        
        guard let strongSelf = weakSelf else {
            NSLog("Failed to setUpCaptureSessionInput because self was deallocated")
            return
        }

        let cameraPosition: AVCaptureDevice.Position = strongSelf.isUseFrontCamera! ? .front : .back
        
        strongSelf.device = strongSelf.captureDevice(forPosition: cameraPosition)
        
        if let device = strongSelf.device {
            strongSelf.captureSession.beginConfiguration()
            
            let currentInputs = strongSelf.captureSession.inputs
            for input in currentInputs {
                strongSelf.captureSession.removeInput(input)
            }
            
            do {
                let input = try AVCaptureDeviceInput(device: device)
                
                if strongSelf.captureSession.canAddInput(input) {
                    strongSelf.captureSession.addInput(input)
                    
                    do {
                        try device.lockForConfiguration()
                        
                        if device.maxAvailableVideoZoomFactor <= self.zoomFactor! {
                            device.videoZoomFactor = device.maxAvailableVideoZoomFactor
                        } else if device.minAvailableVideoZoomFactor >= self.zoomFactor! {
                            device.videoZoomFactor = device.minAvailableVideoZoomFactor
                        } else {
                            device.videoZoomFactor = self.zoomFactor!
                        }
                        
                        device.unlockForConfiguration()
                    } catch {
                        NSLog(error.localizedDescription)
                    }
                } else {
                    NSLog("Failed to add capture session input.")
                }
            } catch {
                NSLog("Failed to create capture device input: \(error.localizedDescription)")
            }
            
            strongSelf.captureSession.commitConfiguration()
        } else {
            NSLog("Failed to get capture device for camera position: \(cameraPosition)")
        }
    }

    
    private func captureDevice(forPosition position: AVCaptureDevice.Position) -> AVCaptureDevice? {
      if #available(iOS 10.0, *) {
        let discoverySession = AVCaptureDevice.DiscoverySession(
          deviceTypes: [.builtInWideAngleCamera],
          mediaType: .video,
          position: .unspecified
        )
        return discoverySession.devices.first { $0.position == position }
      }
      return nil
    }
    
    private func removeDetectionAnnotations() {
      for annotationView in annotationOverlayView.subviews {
        annotationView.removeFromSuperview()
      }
    }
    
    private func updatePreviewOverlayViewWithLastFrame() {
      guard let lastFrame = lastFrame,
        let imageBuffer = CMSampleBufferGetImageBuffer(lastFrame)
      else {
        return
      }
      self.updatePreviewOverlayViewWithImageBuffer(imageBuffer)
      self.removeDetectionAnnotations()
    }
    
    
    private func updatePreviewOverlayViewWithImageBuffer(_ imageBuffer: CVImageBuffer?) {
      guard let imageBuffer = imageBuffer else {
        return
      }
       
        let orientation: UIImage.Orientation = isUseFrontCamera! ? .leftMirrored : .right
        let image = UIUtilities.createUIImage(from: imageBuffer, orientation: orientation)
        
        previewOverlayView.image = image
    }
    
    @IBAction func test(_ sender: Any) {
        
        self.dismiss(animated: true)
    }
    
}


extension MultiBarcodeViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
            lastFrame = sampleBuffer
            
            // 프레임 단위로 버퍼에 들어가서 이미지를 분석한다.
            let visionImage = VisionImage(buffer: sampleBuffer)
            // 마지막 버퍼를 기준으로 비전이미지 인스턴스 생성
            // 비전 이미지 : 비전 감지에 사용되는 이미지 또는 이미지 버퍼
            
            let imageWidth = CGFloat(CVPixelBufferGetWidth(imageBuffer))
            let imageHeight = CGFloat(CVPixelBufferGetHeight(imageBuffer))
            // 버퍼를 통해 이미지 가로세로 길이 Get
            
            self.scanBarcodesOnDevice(
                in: visionImage,
                width: imageWidth,
                height: imageHeight
            )
        } else {
            print("Failed to get image buffer from sample buffer.")
        }

    }
    
    func scanBarcodesOnDevice(
        in image: VisionImage,
        width: CGFloat,
        height: CGFloat
        //options: BarcodeScannerOptions
    ) {
        
        let orientation: UIImage.Orientation = UIUtilities.imageOrientation(
            fromDevicePosition: isUseFrontCamera! ? .front : .back
        )
        
        let combinedFormat: BarcodeFormat = BarcodeFormat(rawValue: barcodeFormat)
        // 정수형 값을 MLKBarcodeFormat의 열거형으로 다시 변환하여 바코드 포맷 얻기
        
        let barcodeOptions = BarcodeScannerOptions(formats: combinedFormat)
        let scanner = BarcodeScanner.barcodeScanner(options: barcodeOptions)
        
        do {
            let barcodes = try scanner.results(in: image)
            
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                
                strongSelf.removeDetectionAnnotations()
                strongSelf.updatePreviewOverlayViewWithLastFrame()
                
                for barcode in barcodes {
                    print(barcode)
                }
            }
        } catch {
            NSLog("Error: \(error.localizedDescription)")
        }
    }

    
}
