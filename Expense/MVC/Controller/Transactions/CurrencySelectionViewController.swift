//
//  CurrencySelectionViewController.swift
//  Expense
//
//  Created by Ray Qu on 18/02/21.
//

import Foundation
import UIKit
protocol CurrencySelectionViewControllerDelegate: NSObjectProtocol {
    func currencyTypeDidSelect(_ currencyType: CurrencyType)
}

class CurrencySelectionViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    let cellIdentifier = "cellIdentifier";
    
    private lazy var currencyTypes: [CurrencyType] = {
        return CurrencyType.allCases;
    }();
    
    weak var delegate: CurrencySelectionViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyTypes.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier);
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: cellIdentifier);
        }
        
        cell?.textLabel?.text = convertCurrencyToString(currencyTypes[indexPath.row]);
        return cell!;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.currencyTypeDidSelect(self.currencyTypes[indexPath.row]);
        self.navigationController?.popViewController(animated: true);
    }
}
