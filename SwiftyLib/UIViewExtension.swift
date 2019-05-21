//
//  UIViewExtension.swift
//  AutenticadorGovBrExample
//
//  Created by Marco Porcho on 17/05/19.
//  Copyright © 2019 Serviço Federal de Processamento de Dados. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
}
