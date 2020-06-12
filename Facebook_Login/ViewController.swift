//
//  ViewController.swift
//  Facebook_Login
//
//  Created by Peter Bassem on 6/9/20.
//  Copyright © 2020 Peter Bassem. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        if let token = AccessToken.current, !token.isExpired {
//            let token = token.tokenString
//            
//            //"email, name, picture.type(large), gender, birthday, phone"
//            
//            /// profile image sizes: small, normal, album, large, square
//            
//            getFacebookUser(token)
//            
//        } else {
//            let loginButton = FBLoginButton()
//            loginButton.center = view.center
//            loginButton.delegate = self
//            loginButton.permissions = ["public_profile", "email", "user_gender", "user_birthday"]
//            view.addSubview(loginButton)
//        }
    }
    
    func getFacebookUser(_ token: String?) {
        let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields": "email, name, first_name, last_name, middle_name, picture.type(album), gender, birthday"], tokenString: token, version: nil, httpMethod: .get)
        request.start { (connection, result, error) in
            if let error = error {
                print("facebook login error:", error)
                return
            }
            print("\(result)")
        }
    }
    
    @IBAction func onFacebookLoginButtonPressed(_ sender: UIButton) {
        let facebookLoginManager = LoginManager()
        facebookLoginManager.logIn(permissions: ["public_profile", "email", "user_gender", "user_birthday"], from: self) { [weak self] (result, error) in
            if let error = error {
                print("Faile to login with facebook:", error)
                return
            }
            guard let result = result else { return }
            if result.isCancelled {
                print("User cancelled facebook login")
                return
            }
            let token = result.token?.tokenString
            self?.getFacebookUser(token)
        }
    }
}

//extension ViewController: LoginButtonDelegate {
//    
//    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
//        let token = result?.token?.tokenString
//        
//        getFacebookUser(token)
//    }
//    
//    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
//        print("logged out successfully")
//    }
//}
