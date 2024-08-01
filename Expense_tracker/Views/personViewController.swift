//
//  personViewController.swift
//  Expense_tracker
//
//  Created by arjun verma on 31/07/24.
//

import UIKit
import GoogleSignIn
import FirebaseAuth

class personViewController: UIViewController {
    
    
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var logOutBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView(){
        guard let email = UserDefaults.standard.string(forKey: "userEmail") , let name = UserDefaults.standard.string(forKey: "firstName")
        else {return}
        self.emailLbl.text = email
        self.nameLbl.text = name
        self.logOutBtn.addTarget(self, action: #selector(logOut), for: .touchUpInside)
    }
    
    
    @objc func logOut(){
        UserDefaults.standard.removeObject(forKey: "userEmail")
        UserDefaults.standard.removeObject(forKey: "firstName")
        GIDSignIn.sharedInstance.signOut()
        CoreDataManager.shared.deleteAllEntries()
        do {
            try FirebaseAuth.Auth.auth().signOut()
            let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            let navController = UINavigationController(rootViewController: VC1)
            navController.modalPresentationStyle = .fullScreen
            navController.modalTransitionStyle = .flipHorizontal
            self.present(navController, animated:true, completion: nil)
        }catch{
            print("Failed to log out")
        }
        
    }
}
