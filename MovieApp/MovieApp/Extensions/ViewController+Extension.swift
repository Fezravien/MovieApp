//
//  ViewController+Extension.swift
//  MovieApp
//
//  Created by Fezravien on 2021/11/04.
//

import UIKit

extension UIViewController {
    typealias AlertActionHandler = ((UIAlertAction) -> Void)
    
    func alert(title: String, message: String? = nil, okTitle: String = "OK", completion: (() -> ())? = nil ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: okTitle, style: .cancel) { _ in
            completion?()
        }
        alert.addAction(okAction)
    
        self.present(alert, animated: true)
    }
}
