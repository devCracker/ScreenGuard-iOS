//
//  ViewController.swift
//  ScreenGuardDemo
//
//  Created by devCracker on 22/04/21.
//

import UIKit
import ScreenGuard

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        ScreenGuardManager.shared.screenRecordDelegate = self
        ScreenGuardManager.shared.listenForScreenRecord()
        
    }

    @IBAction func guardCompleteWindowAction(_ sender: Any) {
        guard  let window = UIApplication.shared.windows.last else {
            return
        }
        
        ScreenGuardManager.shared.guardScreenshot(for: window)
    }
    
    @IBAction func guardCompleteView(_ sender: Any) {
        ScreenGuardManager.shared.guardScreenshot(for: self.view)
    }
    
    @IBAction func guardThisButtonAction(_ sender: Any) {
        guard let button = sender as? UIView else {
            return
        }
        
        ScreenGuardManager.shared.guardScreenshot(for: button)
    }
}

extension ViewController: ScreenRecordDelegate {
    func screen(_ screen: UIScreen, didRecordStarted isRecording: Bool) {
        showAlert(with: "Recording Started", title: "Recording")
    }
    
    func screen(_ screen: UIScreen, didRecordEnded isRecording: Bool) {
        showAlert(with: "Recording ended", title: "Recording")
    }
    
}

extension ViewController {
    
    func showAlert(with message: String, title: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
            alertController.dismiss(animated: true)
        }
        
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}
