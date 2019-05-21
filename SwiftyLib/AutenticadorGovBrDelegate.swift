//
//  AutenticadorGovBrDelegate.swift
//  AutenticadorGovBrExample
//
//  Created by Marco Porcho on 16/05/19.
//  Copyright © 2019 Serviço Federal de Processamento de Dados. All rights reserved.
//

import Foundation

protocol AutenticadorGovBrDelegate {
    
    func onCodeRecuperado(code: String)
    
}
