//
//  ExpenseCategorySelectionViewController.swift
//  Expense
//
//  Created by Ray Qu on 18/02/21.
//

import Foundation
import UIKit

protocol ExpenseCategorySelectionViewControllerDelegate : NSObjectProtocol {
    func expenseCategoryDidSelect(_ expenseCategory: ExpenseCategory)
}

class ExpenseCategorySelectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let cellIdentifier = "cellIdentifier";
    
    private lazy var getExpenseCategoriesUseCase : GetExpenseCategoriesUseCase = {
        return DIContainerImpl.shared.resolve()
    }()
    
    private var expenseCategories : [ExpenseCategory]?
    
    weak var delegate: ExpenseCategorySelectionViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        expenseCategories = getExpenseCategoriesUseCase.execute();
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenseCategories?.count ?? 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier);
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: cellIdentifier);
        }
        let model = expenseCategories![indexPath.row];
        cell?.textLabel?.text = String(describing: model.type);
        return cell!;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.expenseCategoryDidSelect(expenseCategories![indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }
}
