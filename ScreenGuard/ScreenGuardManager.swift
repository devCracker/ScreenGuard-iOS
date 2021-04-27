//
//  ScreenCaptureProtector.swift
//  ScreenGuard
//
//  Created by devCracker on 22/04/21.
//

import Foundation

private extension UIView {
    
    struct Constants {
        static var texfieldTag: Int { Int.max }
    }
    
    func setScreenCaptureProtection() {
        
        guard superview != nil else {
            for subview in subviews { //to avoid layer cyclic crash, when it is a topmost view, adding all its subviews in textfield's layer, TODO: Find a better logic.
                subview.setScreenCaptureProtection()
            }
            return
        }
        
        let guardTextField = UITextField()
        guardTextField.backgroundColor = .red
        guardTextField.translatesAutoresizingMaskIntoConstraints = false
        guardTextField.tag = Constants.texfieldTag
        guardTextField.isSecureTextEntry = true
        
        addSubview(guardTextField)
        guardTextField.isUserInteractionEnabled = false
        sendSubview(toBack: guardTextField)
        
        layer.superlayer?.addSublayer(guardTextField.layer)
        guardTextField.layer.sublayers?.first?.addSublayer(layer)
        
        guardTextField.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        guardTextField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        guardTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        guardTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
    }
    
    // These remove method are only for demo purpose, didnt even test it...

    func removeGuardTextView() {
        guard let guardView = subviews.first(where: { $0.tag == Constants.texfieldTag }) else {
            return
        }
        
        guardView.removeFromSuperview()
    }
    
}

public protocol ScreenRecordDelegate {
    func screen(_ screen: UIScreen, didRecordStarted isRecording: Bool)
    func screen(_ screen: UIScreen, didRecordEnded isRecording: Bool)
}

public class ScreenGuardManager {
    
    // MARK: Shared
    
    public static let shared = ScreenGuardManager()
    public var screenRecordDelegate: ScreenRecordDelegate?
    private var recordingObservation: NSKeyValueObservation?

    // MARK: Init
    
    private init() { }
    
    // MARK: Functions
    
    public func guardScreenshot(`for` window: UIWindow) {
        window.setScreenCaptureProtection()
    }
    
    public func guardScreenshot(`for` view: UIView) {
        view.setScreenCaptureProtection()
    }
    
    // These disable methods are only for demo purpose...
    
    public func disableScreenshotProtection(`for` window: UIWindow) {
        window.removeGuardTextView()
    }
    
    public func disableScreenshotProtection(`for` view: UIView) {
        view.removeGuardTextView()
    }
    
    public func listenForScreenRecord() {
        recordingObservation =  UIScreen.main.observe(\UIScreen.isCaptured, options: [.new]) { [weak self] screen, change in
            let isRecording = change.newValue ?? false
            
            if isRecording {
                self?.screenRecordDelegate?.screen(screen, didRecordStarted: isRecording)
            } else {
                self?.screenRecordDelegate?.screen(screen, didRecordEnded: isRecording)
            }
        }
    }
    
    // MARK: Deinit
    
    deinit {
        screenRecordDelegate = nil
    }
    
}
