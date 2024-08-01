//
//  ExpenseTableViewCell.swift
//  Expense_tracker
//
//  Created by arjun verma on 31/07/24.
//

import UIKit

class ExpenseTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var dateTime: UILabel!
    @IBOutlet weak var descpriction: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
