//
//  AddEditTransactionViewController.swift
//  Expense
//
//  Created by Ray Qu on 17/02/21.
//

import Foundation
import UIKit

class AddEditTransactionViewController: UITableViewController {
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    
    private lazy var saveTransactionUseCase : SaveTransactionUseCase = {
        return DIContainerImpl.shared.resolve()
    }()
    
    private lazy var getExpenseCategoriesUseCase : GetExpenseCategoriesUseCase = {
        return DIContainerImpl.shared.resolve()
    }()
    
    private lazy var minimumDate: Date = {
        return Date.fromString("2000-01-01", format: Constant.DateFormat.yyyyMMddDash)!;
    }();
    
    private var maxmumDate: Date {
        get {
            return Date.init();
        }
    }
    
    lazy var transaction: Transaction = {
        return Transaction.init(amountInNZD: 0, amountInUSD: 0, date: Date.init(), currency: .nzd, category: getExpenseCategoriesUseCase.execute().first!);
    }()
    
    private weak var datePicker : UIDatePicker?
    private lazy var dateFormatter : DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constant.DateFormat.yyyyMMMddHHmm;
        return dateFormatter;
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad();
        setupViews();
        setupViewData();
    }
    
    private func setupViewData()
    {
        setupCategoryLabelData();
        self.dateTextField.text = dateFormatter.string(from: transaction.date)
        self.amountTextField.text = convertTransactionToAmountString(self.transaction)
        setupCurrencyLabelData();
    }
    
    private func setupCurrencyLabelData() {
        self.currencyLabel.text = convertCurrencyToString(transaction.currency);
    }
    
    private func setupCategoryLabelData() {
        self.categoryLabel.text = self.transaction.category.type;
    }
    
    @IBAction func doneButtonDidClick(_ sender: Any) {
        self.view.endEditing(true);
        ProgressHUD.show();
        saveTransactionUseCase.execute(transaction: self.transaction) { [weak self] (result) in
            ProgressHUD.dismiss();
            switch result {
            case .success():
                self?.navigationController?.popViewController(animated: true)
            case .failure(_):
                ProgressHUD.showError("Something goes wrong");
            }
        }
    }
    
    deinit {
        debugPrint("deinit");
    }
}

extension AddEditTransactionViewController: CurrencySelectionViewControllerDelegate, ExpenseCategorySelectionViewControllerDelegate {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let currencySelectionVC = segue.destination as? CurrencySelectionViewController {
            currencySelectionVC.delegate = self;
        }
        
        if let expenseCategorySelectionVC = segue.destination as? ExpenseCategorySelectionViewController  {
            expenseCategorySelectionVC.delegate = self;
        }
    }
    
    func currencyTypeDidSelect(_ currencyType: CurrencyType) {
        self.transaction.currency = currencyType;
        onAmountOrCurrencyChanged();
        setupCurrencyLabelData();
    }
    
    func expenseCategoryDidSelect(_ expenseCategory: ExpenseCategory) {
        self.transaction.category = expenseCategory;
        setupCategoryLabelData();
    }
    
    private func onAmountOrCurrencyChanged() {
        guard let text = self.amountTextField.text else {
            return;
        }
        let amount: Double! = text.count > 0 ? Double.init(text) : 0.0;
        
        switch self.transaction.currency {
        case .usd:
            self.transaction.amountInUSD = amount
        case .nzd:
            self.transaction.amountInNZD = amount
        }
    }
}

extension AddEditTransactionViewController { // Setup view
    private func setupViews() {
        setupDateTextField();
        self.amountTextField.inputAccessoryView = createDonePickerToolBar();
    }
    
    private func setupDateTextField() {
        let datePicker = createDatePicker();
        let toolbar = createDatePickerToolBar();
        
        dateTextField.inputView = datePicker
        dateTextField.inputAccessoryView = toolbar;
        self.datePicker = datePicker;
    }
    
    private func createDatePicker() -> UIDatePicker {
        let datePicker = UIDatePicker()
        datePicker.maximumDate = self.maxmumDate;
        datePicker.minimumDate = self.minimumDate;
        datePicker.date = self.transaction.date;
        datePicker.datePickerMode = .dateAndTime
        datePicker.locale = .current
        if #available(iOS 14, *) {
            datePicker.preferredDatePickerStyle = .wheels
            datePicker.sizeToFit()
        }
        
        return datePicker;
    }
    
    private func createDatePickerToolBar() -> UIToolbar
    {
        let toolBar = createToolBar(selector: #selector(datePickerDidEndEditing));
        return toolBar;
    }
    
    private func createDonePickerToolBar() -> UIToolbar {
        let toolBar = createToolBar(selector: #selector(toolbarDoneButtonDidClick));
        return toolBar;
    }
    
    private func createToolBar(selector: Selector) -> UIToolbar
    {
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: selector);
        let flexibleSpaceItem = UIBarButtonItem.init(systemItem: .flexibleSpace);
        toolbar.setItems([flexibleSpaceItem, doneButton], animated: false)
        
        return toolbar;
    }
    
    @objc func datePickerDidEndEditing(){
        dateTextField.text = dateFormatter.string(from: datePicker!.date)
        self.transaction.date =  datePicker!.date;
        dateTextField.resignFirstResponder();
    }
    
    @objc func toolbarDoneButtonDidClick(){
        self.view.endEditing(true);
    }
    
    @IBAction func amountTextFieldDidEndEditing(_ sender: UITextField) {
        onAmountOrCurrencyChanged();
    }
}
