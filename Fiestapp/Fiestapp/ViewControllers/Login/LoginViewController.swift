//
//  LoginViewController.swift
//  fiestapp
//
//  Created by Nicolás Hechim on 25/5/17.
//  Copyright © 2017 Mint. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase


class LoginViewController: UIViewController {
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    @IBOutlet var viewLoginButtons: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewLoginButtons.applyGradient(colours: [UIColor(red: 0/255, green: 177/255, blue: 255/255, alpha: 1),
                                                 UIColor(red: 232/255, green: 0/255, blue: 166/255, alpha: 1)],
                                       locations: [0.0, 1.0])
        
        let currentUser = FIRAuth.auth()?.currentUser
        if(currentUser != nil) {
            // User is logged in, go to next view controller.
            print("User is logged in")
            print("photo url facebook: " + (currentUser?.photoURL?.absoluteString)!)
            print("user name facebook: " + (currentUser?.displayName!)!)
            print("email facebook: " + (currentUser?.email!)!)
            
            let appDelegate = UIApplication.shared.delegate! as! AppDelegate
            let initialViewController = self.storyboard!.instantiateViewController(withIdentifier: "HomeTabBarController")
            appDelegate.window?.rootViewController = initialViewController
            appDelegate.window?.makeKeyAndVisible()
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func facebookLogin(sender: UIButton) {
        ProgressOverlayView.shared.showProgressView(self.view)
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            
            guard let accessToken = FBSDKAccessToken.current() else {
                print("Failed to get access token")
                return
            }
            
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            // Perform login by calling Firebase APIs
            FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Error de login", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                    return
                }
                // Present the main view
                if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeTabBarController") {
                    UIApplication.shared.keyWindow?.rootViewController = viewController
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }
    }
}
