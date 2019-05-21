//
//  LoginGovBrWebView.swift
//  AutenticadorGovBrExample
//
//  Created by Marco Porcho on 17/05/19.
//  Copyright © 2019 Serviço Federal de Processamento de Dados. All rights reserved.
//

import UIKit
import WebKit

typealias AmbienteGovBr = String

@IBDesignable class LoginGovBrWebView: WKWebView, WKNavigationDelegate {
    
    static let DESENV: AmbienteGovBr = "http://192.168.1.119:5000"
    static let HOMOLOGACAO: AmbienteGovBr = "https://testescp-ecidadao.estaleiro.serpro.gov.br"
    static let PRODUCAO: AmbienteGovBr = "https://testescp-ecidadao.estaleiro.serpro.gov.br"
    
    lazy var delegate: AutenticadorGovBrDelegate? = nil
    
    override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
        self.navigationDelegate = self
        initLoginGovBr()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initLoginGovBr()
    }
    
    private func initLoginGovBr() {
        
        self.navigationDelegate = self
        
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
    }
    
    func loginNoGovBr(ambiente: AmbienteGovBr, delegate: AutenticadorGovBrDelegate) {
        
        self.delegate = delegate
        
        let url = URL(string: getUrlProvider(ambiente))!
        
        self.load(URLRequest(url: url))
        
    }
    
    private func getUrlProvider(_ ambiente: AmbienteGovBr) -> String {
        
        let clientId = Bundle.main.infoDictionary?["govbr_client_id"] as! String
        
        let scope = Bundle.main.infoDictionary?["govbr_scope"] as! String
        
        let redirectUri = Bundle.main.infoDictionary?["govbr_redirect_uri"] as! String
        
        return ambiente +
            "/scp/authorize?response_type=code&client_id=\(clientId)&scope=\(scope)&redirect_uri=\(redirectUri)&nonce=\(randomNumber())&state=\(randomNumber())"
    }
    
    private func randomNumber() -> String {
        return String(Int.random(in: 1...1000))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let url = webView.url?.absoluteString ?? ""
        
        let pattern = "code=([^&]+)"
        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        
        if let match = regex?.firstMatch(in: url, options: [], range: NSRange(location: 0, length: url.utf16.count)) {
            if let codeRange = Range(match.range(at: 1), in: url) {
                let code = url[codeRange]
                
                delegate?.onCodeRecuperado(code: String(code))
                
                let vc = findViewController()
                
                vc?.navigationController?.popViewController(animated: true)
            }
        }
        
    }

    
    
}
