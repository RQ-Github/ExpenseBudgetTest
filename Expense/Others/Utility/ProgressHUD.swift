//
//  ProgressHUD.swift
//  Expense
//
//  Created by Ray Qu on 18/02/21.
//

import Foundation
import SVProgressHUD

class ProgressHUD{
    class func show() {
        SVProgressHUD.show();
    }
    
    class func dismiss() {
        SVProgressHUD.dismiss();
    }
    
    class func showError(_ message: String) {
        SVProgressHUD.showError(withStatus: message);
    }
}
