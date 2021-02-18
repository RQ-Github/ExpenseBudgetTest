//
//  ExpenseCategoryCell.swift
//  Expense
//
//  Created by Ray Qu on 14/02/21.
//

import UIKit

protocol ExpenseCategoryCellDelegate : NSObjectProtocol {
    func typeTextFieldDidEndEditing(_ sender: UITextField, _ expenseCategory: ExpenseCategory)
}

class ExpenseCategoryCell: UITableViewCell  {
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var typeTextField: UITextField!
    
    weak var delegate : ExpenseCategoryCellDelegate?
    var expenseCategory : ExpenseCategory! {
        didSet {
            if let value = expenseCategory {
                expenseCategoryDidSet(value);
            }
        }
    }
    
    private func expenseCategoryDidSet(_ expenseCategory : ExpenseCategory)
    {
        self.typeTextField.text = expenseCategory.type;
        self.amountLabel.text = String(format: Constant.MoneyFormat.General, expenseCategory.amount);
    }
    @IBAction func typeTextFieldDidEndEditing(_ sender: UITextField) {
        delegate?.typeTextFieldDidEndEditing(sender, expenseCategory);
    }
    @IBAction func typeTextFieldDidReturn(_ sender: UITextField) {
        sender.resignFirstResponder();
    }
}
