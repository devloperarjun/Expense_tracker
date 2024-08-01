//
//  coreDataManager.swift
//  Expense_tracker
//
//  Created by arjun verma on 31/07/24.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager{
    static let shared = CoreDataManager()
    var persistentContainer: NSPersistentContainer
    
    private init(){
        persistentContainer = NSPersistentContainer(name: "Expense_tracker")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
    }
    
    func saveContext(){
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do{
                try context.save()
            }
            catch{
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    func createEarning(amount:Double,desc:String,date:Date){
        let context = persistentContainer.viewContext
        let earning = Earning(context: context)
        earning.amount = amount
        earning.date = date
        earning.desc = desc
        saveContext()
    }
    
    
    func fetchEarnings() -> [Earning]{
        let context = persistentContainer.viewContext
        let fecthRequest:NSFetchRequest<Earning> = Earning.fetchRequest()
        do{
            return try context.fetch(fecthRequest)
        }catch{
            print("Failed to fetch earnings: \(error)")
            return []
        }
    }
    
    func updateEarning(earning: Earning, amount: Double, desc: String, date: Date) {
        _ = persistentContainer.viewContext
        earning.amount = amount
        earning.desc = desc
        earning.date = date
        
        saveContext()
    }
    
    
    func deleteEarning(earning: Earning) {
        let context = persistentContainer.viewContext
        context.delete(earning)
        saveContext()
    }
    
    
    
    // Expenses functions
    func createExpense(amount: Double, desc: String, date: Date) {
        let context = persistentContainer.viewContext
        let expense = Expense(context: context)
        expense.amount = amount
        expense.desc = desc
        expense.date = date
        
        saveContext()
    }
    
    func fetchExpenses() -> [Expense] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch expenses: \(error)")
            return []
        }
    }
    
    func updateExpense(expense: Expense, amount: Double, desc: String, date: Date) {
        _ = persistentContainer.viewContext
        expense.amount = amount
        expense.desc = desc
        expense.date = date
        saveContext()
    }
    
    func deleteExpense(expense: Expense) {
        let context = persistentContainer.viewContext
        context.delete(expense)
        
        saveContext()
    }
    
    func calculateTotalEarnings() -> Double {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Earning> = Earning.fetchRequest()
        
        do {
            let earnings = try context.fetch(fetchRequest)
            return earnings.reduce(0) { $0 + $1.amount }
        } catch {
            print("Failed to fetch earnings: \(error)")
            return 0
        }
    }
    
    func calculateTotalExpenses() -> Double {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
        
        do {
            let expenses = try context.fetch(fetchRequest)
            return expenses.reduce(0) { $0 + $1.amount }
        } catch {
            print("Failed to fetch expenses: \(error)")
            return 0
        }
    }
    
    
    func deleteAllEntries() {
            deleteAllEntries(for: "Earning")
            deleteAllEntries(for: "Expense")
        }

        private func deleteAllEntries(for entityName: String) {
            let context = persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try context.execute(batchDeleteRequest)
                try context.save()
            } catch {
                print("Failed to delete all entries for \(entityName): \(error)")
            }
        }
    
}
