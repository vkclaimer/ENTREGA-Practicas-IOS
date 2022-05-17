/*

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
this list of conditions and the following disclaimer in the documentation
and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.
*/

import Foundation
import UIKit
import MessageUI

// Input del Router
protocol MenuRouterInputProtocol {
    func canSendMail(delegate: MFMailComposeViewControllerDelegate)
    func showCustomAlert(delegate: AlertDefaultViewControllerDelegate?, model: CustomAlertManager)
    func showGenericWebView()
    func showTipsViewController()
}

final class MenuRouter: BaseRouter<MenuViewController> {
        
}

// Input del Router
extension MenuRouter: MenuRouterInputProtocol {
    func canSendMail(delegate: MFMailComposeViewControllerDelegate) {
        DispatchQueue.main.async {
            self.viewController?.present(Utils.configuracionMailCompose(delegate: delegate,
                                                                        data: []),
                                         animated: true,
                                         completion: nil)
        }
    }
    
    func showCustomAlert(delegate: AlertDefaultViewControllerDelegate?, model: CustomAlertManager){
        DispatchQueue.main.async {
            let vc = AlertDefaultViewController()
            
            switch model.type {
            case .cantSendMail:
                vc.delegate = nil
                vc.alertManager = model
            default:
                vc.delegate = delegate
                vc.alertManager = model
            }
            
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.viewController?.present(vc, animated: true, completion: nil)
        }
    }
    
    func showGenericWebView() {
        DispatchQueue.main.async {
            let vc = GenericWebCoordinator.navigation()
            self.viewController?.present(vc, animated: true, completion: nil)
        }
    }
    
    func showTipsViewController() {
        DispatchQueue.main.async {
            let vc = TipCoordinator.navigation()
            self.viewController?.show(vc, sender: nil)
        }
    }
    
    
}


