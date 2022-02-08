//
//  UIViewContrroller.swift
//  MyWeather
//
//  Created by Muthama Kahohi on 08/02/2022.
//

import UIKit

extension UIViewController {
    
    func presentAlert(alert: inout GenericAlert, width: CGFloat) {
        self.view.addSubview(alert)
        alert.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            alert.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            alert.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            alert.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: width)
        ])
    }
    
    func hideKeyboardWhenTapped() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
