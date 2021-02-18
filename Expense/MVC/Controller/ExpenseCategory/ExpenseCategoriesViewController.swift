//
//  ExpenseCategoriesViewController.swift
//  Expense
//
//  Created by Ray Qu on 13/02/21.
//

import UIKit

class ExpenseCategoriesViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private let cellName = String.init(describing: ExpenseCategoryCell.self)
    private lazy var getExpenseCategoriesUseCase : GetExpenseCategoriesUseCase = {
        return DIContainerImpl.shared.resolve()
    }()
    private lazy var saveCategoryUseCase : SaveExpenseCategoryUseCase = {
        return DIContainerImpl.shared.resolve()
    }()
    
    private var expenseCategories : [ExpenseCategory]?
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        RegisterTableViewCell();
        self.expenseCategories = getExpenseCategoriesUseCase.execute();
    }
    
    private func RegisterTableViewCell()
    {
        tableView.register(UINib(nibName: cellName, bundle: nil), forCellReuseIdentifier: cellName)
    }
}

extension ExpenseCategoriesViewController : UITableViewDelegate, UITableViewDataSource, ExpenseCategoryCellDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.expenseCategories?.count ?? 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellName) as! ExpenseCategoryCell
        cell.expenseCategory = self.expenseCategories![indexPath.row];
        cell.delegate = self;
        return cell;
    }
    
    func typeTextFieldDidEndEditing(_ sender: UITextField, _ expenseCategory: ExpenseCategory) {
        var model = expenseCategory;
        if let text = sender.text {
            model.type = text;
        }
        saveCategoryUseCase.execute(model);
    }
}
