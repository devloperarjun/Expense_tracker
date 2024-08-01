//
//  LoginViewController.swift
//  Expense_tracker
//
//  Created by arjun verma on 31/07/24.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView(){
        loginBtn.layer.borderWidth = 1
        loginBtn.layer.borderColor = UIColor.black.cgColor
        loginBtn.layer.cornerRadius = 20
        loginBtn.addTarget(self, action: #selector(logedIn), for: .touchUpInside)
    }
    
    
    @objc func logedIn(){
        guard  let clientId = FirebaseApp.app()?.options.clientID else {return}
        let config = GIDConfiguration(clientID: clientId)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self) {	[weak self] result, error in
            guard error == nil else {return}
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {return}
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            Auth.auth().signIn(with: credential) { authResult, error in
                if error != nil{
                    return
                }
                UserDefaults.standard.set(true, forKey: "login")
            }
            
            guard let email = user.profile?.email,
                  let firstName = user.profile?.name
            else{
                return
            }
            UserDefaults.standard.set(email, forKey: "userEmail")
            UserDefaults.standard.set(firstName, forKey: "firstName")
            self?.dismissSelf()
        }
    }
    
    func dismissSelf(){
           self.dismiss(animated: true, completion: nil)
       }
}
