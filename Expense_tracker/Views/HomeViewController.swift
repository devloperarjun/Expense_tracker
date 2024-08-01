//
//  HomeViewController.swift
//  Expense_tracker
//
//  Created by arjun verma on 31/07/24.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import GoogleSignIn


class HomeViewController: UIViewController {
    
    
    @IBOutlet weak var startDate: UIDatePicker!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var expenses: UILabel!
    @IBOutlet weak var earnings: UILabel!
    @IBOutlet weak var totalBalance: UILabel!
    
    var earningsData: [Earning] = []
    var expensesData: [Expense] = []
    
    var filteredEarnings: [Earning] = []
    var filteredExpenses: [Expense] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchEarningsAndExpenses()
        validateAuth()
        filterView.layer.borderWidth = 0.5
        filterView.layer.borderColor = UIColor.black.cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchEarningsAndExpenses()
        updateTotals()
        
    }
    
    @IBAction func clearBtnPressed(_ sender: UIButton) {
        filteredEarnings = earningsData
        filteredExpenses = expensesData
        tableView.reloadData()
        updateTotals()
    }
    
    @IBAction func filterBtnPressed(_ sender: UIButton) {
        filterDataByDate()
    }
    
    
    func fetchEarningsAndExpenses() {
        earningsData = CoreDataManager.shared.fetchEarnings()
        expensesData = CoreDataManager.shared.fetchExpenses()
        filteredEarnings = earningsData
        filteredExpenses = expensesData
        tableView.reloadData()
    }
    
    
    func updateTotals() {
        let totalEarnings = CoreDataManager.shared.calculateTotalEarnings()
        earnings.text = "Rs.\(totalEarnings)"
        let totalExpenses = CoreDataManager.shared.calculateTotalExpenses()
        expenses.text = "Rs.\(totalExpenses)"
        let totalBalances = (totalEarnings) - (totalExpenses)
        totalBalance.text = "Rs.\(totalBalances)"
    }
    
    func filterDataByDate() {
        let selectedDate = startDate.date
        
        filteredEarnings = earningsData.filter { earning in
            guard let earningDate = earning.date else { return false }
            return Calendar.current.isDate(earningDate, inSameDayAs: selectedDate)
        }
        
        filteredExpenses = expensesData.filter { expense in
            guard let expenseDate = expense.date else { return false }
            return Calendar.current.isDate(expenseDate, inSameDayAs: selectedDate)
        }
        
        tableView.reloadData()
        updateTotals()
    }
    
    private func validateAuth(){
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            let navController = UINavigationController(rootViewController: VC1)
            navController.modalPresentationStyle = .fullScreen
            navController.modalTransitionStyle = .flipHorizontal
            self.present(navController, animated:true, completion: nil)
        }
    }
    
}

extension HomeViewController: UITableViewDelegate,UITableViewDataSource,AddEarningViewControllerDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return filteredEarnings.count
        } else {
            return filteredExpenses.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenseTableViewCell", for: indexPath) as! ExpenseTableViewCell
            let earning = filteredEarnings[indexPath.row]
            cell.bgView.clipsToBounds = false
            cell.bgView.layer.cornerRadius = 10
            cell.bgView.backgroundColor = UIColor.green.withAlphaComponent(CGFloat(0.3))
            cell.descpriction.text = earning.desc
            cell.amount.text = "Rs.\(earning.amount)"
            cell.dateTime?.text = "\(earning.date ?? Date())"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenseTableViewCell", for: indexPath) as! ExpenseTableViewCell
            let expense = filteredExpenses[indexPath.row]
            cell.bgView.clipsToBounds = false
            cell.bgView.layer.cornerRadius = 10
            cell.bgView.backgroundColor = UIColor.red.withAlphaComponent(CGFloat(0.5))
            cell.descpriction.text = expense.desc
            cell.amount.text = "Rs.\(expense.amount)"
            cell.dateTime?.text = "\(expense.date ?? Date())"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if indexPath.section == 0 {
                let earning = filteredEarnings[indexPath.row]
                CoreDataManager.shared.deleteEarning(earning: earning)
            } else {
                let expense = filteredExpenses[indexPath.row]
                CoreDataManager.shared.deleteExpense(expense: expense)
            }
            fetchEarningsAndExpenses()
            filterDataByDate()
        }
    }
    
    
    
    func didSaveEarning() {
        fetchEarningsAndExpenses()
        filterDataByDate()
    }
    
    func didSaveExpense() {
        fetchEarningsAndExpenses()
        filterDataByDate()
    }
}
