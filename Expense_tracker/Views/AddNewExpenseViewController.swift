//
//  AddNewExpenseViewController.swift
//  Expense_tracker
//
//  Created by arjun verma on 31/07/24.
//

import UIKit

protocol AddEarningViewControllerDelegate: AnyObject {
    func didSaveEarning()
    func didSaveExpense()
}


class AddNewExpenseViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var descrpitionText: UITextField!
    @IBOutlet weak var amountText: UITextField!
    
    weak var delegate: AddEarningViewControllerDelegate?
    var earning: Earning?
    var expense: Expense?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let earning = earning {
            amountText.text = "\(earning.amount)"
            descrpitionText.text = earning.desc
            datePicker.date = earning.date ?? Date()
        }
        
    }
    
    @IBAction func expenses(_ sender: UIButton) {
        guard let amountTexte = amountText.text,
              let amount = Double(amountTexte),
              let desc = descrpitionText.text else { return }
        
        let date = datePicker.date
        
        if let expense = expense {
            CoreDataManager.shared.updateExpense(expense: expense, amount: amount, desc: desc, date: date)
        } else {
            CoreDataManager.shared.createExpense(amount: amount, desc: desc, date: date)
        }
        
        delegate?.didSaveExpense()
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func earnings(_ sender: UIButton) {
        guard let amountTexte = amountText.text,
              let amount = Double(amountTexte),
              let desc = descrpitionText.text else { return }
        let date = datePicker.date
        if let earning = earning {
            CoreDataManager.shared.updateEarning(earning: earning, amount: amount, desc: desc, date: date)
        } else {
            CoreDataManager.shared.createEarning(amount: amount, desc: desc, date: date)
        }
        delegate?.didSaveEarning()
        navigationController?.popViewController(animated: true)
    }
}

