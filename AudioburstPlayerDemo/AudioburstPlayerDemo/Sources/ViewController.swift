//
//  Created by Pawel Leszkiewicz on 03/04/2019.
//  Copyright © 2019 Audioburst. All rights reserved.
//

import UIKit
import AudioburstPlayer

class ViewController: UIViewController {

    @IBOutlet fileprivate weak var applicationKeyTextField: UITextField!
    @IBOutlet fileprivate weak var settingsIdTextField: UITextField!
    @IBOutlet fileprivate weak var reloadPlayerButton: UIButton!
    @IBOutlet weak var darkModeButton: UIButton!
    @IBOutlet weak var fullscreenPlayerButton: UIButton!
    
    @IBOutlet fileprivate weak var playerViewContainer: UIView!
    fileprivate var player: ABPlayer!
    fileprivate var compactPlayerVC: UIViewController!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    fileprivate func setupView() {
        let userDefaults = UserDefaults.standard
        let applicationKey: String
        let experienceId: String?
        if let userDefaultsApplicationKey = userDefaults.string(forKey: "applicationKey") {
            applicationKey = userDefaultsApplicationKey
            experienceId = userDefaults.string(forKey: "experienceId")
        } else if let filePath = Bundle.main.path(forResource: "appData", ofType: "plist"),
            let dict = NSDictionary(contentsOfFile: filePath) {
            applicationKey = dict["applicationKey"] as! String
            experienceId = dict["experienceId"] as? String
        } else {
            applicationKey = ""
            experienceId = nil
        }

        applicationKeyTextField.text = applicationKey
        settingsIdTextField.text = experienceId
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0 )

        if !applicationKey.isEmpty {
            reloadPlayer()
        }
    }

    fileprivate func reloadPlayer() {
        fullscreenPlayerButton.isHidden = true
        self.view.endEditing(true)

        guard let applicationKey = applicationKeyTextField.text, !applicationKey.isEmpty  else {
            let title = "Missing application key"
            let message = "Please provide an application key in order to make the player work. You can obtain the application key on\nhttps://studio.audioburst.com/"
            showAlert(withTitle: title, message: message)
            return
        }

        guard let experienceId = settingsIdTextField.text, !experienceId.isEmpty  else {
              let title = "Missing Experience Id"
              let message = "Please provide an experience id in order to fetch customized playlist. You can obtain the experience id  on\n https://studio.audioburst.com"
              showAlert(withTitle: title, message: message)
              return
          }

        if let player = player {
            player.remove(errorListener: self)
            player.remove(playerListener: self)
        }

        removeViewControllerAsChild(compactPlayerVC)
        compactPlayerVC = nil

        player = ABPlayer(appKey: applicationKey, experienceId: experienceId)

        player.add(errorListener: self)

        player.add(playerListener: self)

        player.load() { [weak self] result in
            guard let self = self else { return }

            if case let .success(viewController) = result {
                self.compactPlayerVC = viewController
                self.addViewControllerAsChild(self.compactPlayerVC, parentView: self.playerViewContainer)
                self.updateUserDefaults()
                self.fullscreenPlayerButton.isHidden = false
            }
        }
    }

    fileprivate func updateUserDefaults() {
        let params: [(value: UITextField, key: String)] = [
            (value: applicationKeyTextField, key: "applicationKey"),
            (value: settingsIdTextField, key: "experienceId"),
        ]

        let userDefaults = UserDefaults.standard
        for param in params {
            if let text = param.value.text, !text.isEmpty {
                userDefaults.setValue(text, forKey: param.key)
            } else {
                userDefaults.removeObject(forKey: param.key)
            }
        }
        userDefaults.synchronize()
    }

    @IBAction fileprivate func reloadPlayerAction(_ sender: UIButton) {
        reloadPlayer()
    }

    @IBAction func toggleDarkModeAction(_ sender: Any) {

        let window = UIApplication.shared.keyWindow
        if #available(iOS 13.0, *) {
            if window?.overrideUserInterfaceStyle == .dark {
                window?.overrideUserInterfaceStyle = .light
            } else {
                window?.overrideUserInterfaceStyle = .dark
            }
        }
    }

    @IBAction func showFullscreenPlayer(_ sender: Any) {
        player.openFullscreenPlayer()
    }

}

extension ViewController: AudioburstPlayerErrorListener {
    func onError(error: AudioburstPlayerError) {
         self.showAlert(withTitle: "Error", message: error.localizedDescription)
    }
}

extension ViewController: AudioburstPlayerListener {
    func onClose() {
        removeViewControllerAsChild(compactPlayerVC)
        fullscreenPlayerButton.isHidden = true
    }
}

extension ViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}

extension ViewController {
    fileprivate func removeViewControllerAsChild(_ viewController: UIViewController?) {
        guard let viewController = viewController else { return }
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
        viewController.didMove(toParent: nil)
    }

    fileprivate func addViewControllerAsChild(_ viewController: UIViewController, parentView: UIView) {
        guard let childView = viewController.view else { return }
        viewController.willMove(toParent: self)
        addChild(viewController)
        parentView.addSubview(childView)
        childView.translatesAutoresizingMaskIntoConstraints = false
        childView.leftAnchor.constraint(equalTo: parentView.leftAnchor, constant: 0).isActive = true
        childView.rightAnchor.constraint(equalTo: parentView.rightAnchor, constant: 0).isActive = true
        childView.topAnchor.constraint(equalTo: parentView.topAnchor, constant: 0).isActive = true
        childView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor, constant: 0).isActive = true
        viewController.didMove(toParent: self)
    }

    fileprivate func showAlert(withTitle title: String, message: String, completion: (() -> ())? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            completion?()
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

