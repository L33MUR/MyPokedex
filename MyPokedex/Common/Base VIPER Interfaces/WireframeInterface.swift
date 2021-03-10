//
//  WireframeInterface.swift
//  MyPokedex
//
//  Created by Pedro Rey Simons on 01/03/2021.
//

import UIKit

protocol WireframeInterface: AnyObject {
    func popFromNavigationController(animated: Bool)
    func dismiss(animated: Bool)

    func showErrorAlert(with message: String?)
    func showAlert(with title: String?, message: String?)
    func showAlert(with title: String?, message: String?, actions: [UIAlertAction])
}

class BaseWireframe {

    private unowned var _viewController: UIViewController

    //to retain view controller reference upon first access
    private var _temporaryStoredViewController: UIViewController?

    init(viewController: UIViewController) {
        _temporaryStoredViewController = viewController
        _viewController = viewController
    }

}

extension BaseWireframe: WireframeInterface {
    func popFromNavigationController(animated: Bool) {
        DispatchQueue.main.async {
            let _ = self.navigationController?.popViewController(animated: animated)
        }
    }

    func dismiss(animated: Bool) {
        DispatchQueue.main.async {
            self.navigationController?.dismiss(animated: animated)
        }
    }

    func showErrorAlert(with message: String?) {
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        showAlert(with: "Something went wrong", message: message, actions: [okAction])
    }

    func showAlert(with title: String?, message: String?) {
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        showAlert(with: title, message: message, actions: [okAction])
    }

    func showAlert(with title: String?, message: String?, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { alert.addAction($0) }
        DispatchQueue.main.async {
            self.navigationController?.present(alert, animated: true, completion: nil)
        }
    }
}

extension BaseWireframe {

    var viewController: UIViewController {
        defer { _temporaryStoredViewController = nil }
        return _viewController
    }

    var navigationController: UINavigationController? {
        return viewController.navigationController
    }

}

extension UIViewController {

    func presentWireframe(_ wireframe: BaseWireframe, animated: Bool = true, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            self.present(wireframe.viewController, animated: animated, completion: completion)
        }

    }

}

extension UINavigationController {

    func pushWireframe(_ wireframe: BaseWireframe, animated: Bool = true) {
        DispatchQueue.main.async {
            self.pushViewController(wireframe.viewController, animated: animated)
        }
    }

    func setRootWireframe(_ wireframe: BaseWireframe, animated: Bool = true) {
        DispatchQueue.main.async {
            self.setViewControllers([wireframe.viewController], animated: animated)
        }
    }

}
