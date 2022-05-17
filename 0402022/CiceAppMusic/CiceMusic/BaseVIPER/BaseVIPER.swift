//
//  BaseVIPER.swift
//  CiceMusic
//
//  Created by CICE on 07/02/2022.
//

import UIKit
import PKHUD

// MARK: ViewController
class BaseView<P>: UIViewController {
    var presenter: P?
    
    func showLoading() {
        HUD.show(.progress)
    }
    
    func hideLoading(){
        HUD.hide()
    }
}

// MARK: Presenter
class BasePresenter<V, I, R> {
    var viewController: V?
    var interactor: I?
    var router: R?
    
    convenience init(vc: V, interactor: I? = nil, router: R? = nil){
        self.init()
        self.viewController = vc
        self.interactor = interactor
        self.router = router
        
    }
}

// MARK: Interactor
class BaseInteractor<P> {
    var presenter: P?
    
    convenience init(presenter: P){
        self.init()
        self.presenter = presenter
    }
}

// MARK: Router
class BaseRouter<V> {
    var viewController: V?
    
    convenience init(view: V? = nil){
        self.init()
        self.viewController = view
    }
}

class BaseNavigation: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
