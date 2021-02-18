//
//  ViewController.swift
//  Expense
//
//  Created by Ray Qu on 13/02/21.
//

import UIKit

class TransactionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    private let cellName = String.init(describing: TransactionCell.self)
    private let addEditTransactionSegueIdentifier = "addEditTransaction";
    
    private lazy var getTransactionsUseCase : GetTransactionsUseCase = {
        return DIContainerImpl.shared.resolve()
    }()
    private var transactionSections: [TransactionSection] = [TransactionSection]();
    private var selectedTransaction: Transaction?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Transactions";
        RegisterTableViewCell();
    }
    
    private func RegisterTableViewCell() {
        self.tableView.register(UINib(nibName: cellName, bundle: nil), forCellReuseIdentifier: cellName)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        debugPrint("viewWillAppear")
        self.transactionSections = getTransactionsUseCase.execute();
        self.tableView.reloadData();
        self.selectedTransaction = nil;
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date = self.transactionSections[section].date;
        return date.toString(format: Constant.DateFormat.yyyyMMddDash);
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.transactionSections.count;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.transactionSections[section].transactions.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellName) as! TransactionCell
        let section = self.transactionSections[indexPath.section];
        cell.transaction = section.transactions[indexPath.row];
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedTransaction = self.transactionSections[indexPath.section].transactions[indexPath.row];
        self.performSegue(withIdentifier: addEditTransactionSegueIdentifier, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? AddEditTransactionViewController, let selectedTransaction = self.selectedTransaction{
            viewController.transaction = selectedTransaction;
        }
    }
}

