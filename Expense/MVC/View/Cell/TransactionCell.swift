//
//  TransactionCell.swift
//  Expense
//
//  Created by Ray Qu on 19/02/21.
//

import Foundation
import UIKit

class TransactionCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var usdAmountLabel: UILabel!
    @IBOutlet weak var nzdAmountLabel: UILabel!
    
    var transaction: Transaction! {
        didSet {
            setupData(transaction: transaction);
        }
    }
    
    private func setupData(transaction: Transaction) {
        self.titleLabel.text = transaction.category.type;
        self.usdAmountLabel.text = String(format: Constant.MoneyFormat.General, transaction.amountInUSD);
        self.nzdAmountLabel.text = String(format: Constant.MoneyFormat.General, transaction.amountInNZD);
    }
}
