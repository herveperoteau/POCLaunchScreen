//
//  LaunchScreenViewController.swift
//  POCLaunchScreen
//
//  Created by HPE3698 on 31/05/2017.
//  Copyright © 2017 Viseo. All rights reserved.
//

import UIKit

class LaunchScreenViewController: UIViewController {

    @IBOutlet weak var lblVersion: UILabel!
    @IBOutlet weak var constraintBottomLabel: NSLayoutConstraint!
    
    deinit {
        print("deinit launchscreen")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblVersion.text = "v 1.1"
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.startAnimation()
    }
    
    private func startAnimation() {

        constraintBottomLabel.constant = 20
        
        print("start anim")
        UIView.animate(
            withDuration: 1.5,
            animations:
            {
                self.view.layoutIfNeeded()
        }
        ) { (finish) in
            self.presentMainViewController()
        }
    }

    private func presentMainViewController() {
        
        print("presentMainViewController")

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateInitialViewController()
        UIApplication.shared.keyWindow!.replaceRootViewControllerWith(vc!, animated: true, completion: nil)
    }
}

extension UIView {
    func snapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result!
    }
}

extension UIWindow {
    func replaceRootViewControllerWith(_ replacementController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        let snapshotImageView = UIImageView(image: self.snapshot())
        self.addSubview(snapshotImageView)
        
        let dismissCompletion = { () -> Void in // dismiss all modal view controllers
            self.rootViewController = replacementController
            self.bringSubview(toFront: snapshotImageView)
            if animated {
                UIView.animate(withDuration: 1.5, animations: { () -> Void in
                    snapshotImageView.alpha = 0
                }, completion: { (success) -> Void in
                    snapshotImageView.removeFromSuperview()
                    completion?()
                })
            }
            else {
                snapshotImageView.removeFromSuperview()
                completion?()
            }
        }
        if self.rootViewController!.presentedViewController != nil {
            self.rootViewController!.dismiss(animated: false, completion: dismissCompletion)
        }
        else {
            dismissCompletion()
        }
    }
}
