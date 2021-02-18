//
//  Created by Pawel Leszkiewicz on 03/04/2019.
//  Copyright © 2019 Audioburst. All rights reserved.
//

import UIKit
import AudioburstPlayer
import Tabman
import Pageboy


protocol ReloadableDelegate: class {
    func reloadPlayer(appKey: String, experienceId: String)
    func reloadPlayer(configuration: ABPlayer.Configuration)
    func reloadVoiceData(data: Data)
    func closePlayer()
    func play()
}


class MainViewController: TabmanViewController {

    private var viewControllers: [UIViewController] = []

    private let storageInteractor = StorageInteractor()

    @IBOutlet fileprivate weak var playerViewContainer: PassthroughView!
    fileprivate var player: ABPlayer!
    fileprivate var compactPlayerVC: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    fileprivate func setupView() {
        loadChildViewControllers()
        setupTMBar()
    }

    private func loadChildViewControllers() {
        let credentials = CredentialsViewController.instantiateFromStoryboard()
        credentials.storageInteractor = storageInteractor
        credentials.delegate = self

        let custom = CustomConfigurationViewController.instantiateFromStoryboard()
        custom.storageInteractor = storageInteractor
        custom.delegate = self

        viewControllers.append(credentials)
        viewControllers.append(custom)
    }


    private func setupTMBar() {
        self.dataSource = self

        let bar = TMBar.ButtonBar()
        bar.layout.transitionStyle = .snap
        bar.indicator.cornerStyle = .rounded
        bar.indicator.weight = .light
        bar.indicator.tintColor = .label
        bar.layout.alignment = .centerDistributed
        bar.layout.contentMode = .fit
        bar.backgroundView.style = .flat(color: .systemBackground)

        bar.buttons.customize { (button) in
            button.tintColor = .label
            button.selectedTintColor = .label
            guard let font = UIFont(name: "Montserrat-Regular", size: 15) else { return }
            button.font = font
        }

        addBar(bar, dataSource: self, at: .top)
    }

    internal func loadPlayer(appKey: String, experienceId: String) {
        let player = ABPlayer(appKey: appKey , experienceId: experienceId)
        add(player: player)
    }

    internal func loadPlayer(configuration: ABPlayer.Configuration) {
        let player = ABPlayer(configuration: configuration)
        add(player: player)
    }

    private func add(player: ABPlayer) {
        if let player = self.player {
            player.remove(errorListener: self)
            player.remove(playerListener: self)
        }
        removeViewControllerAsChild(compactPlayerVC)
        compactPlayerVC = nil
        self.player = player
        self.player?.add(errorListener: self)
        self.player?.add(playerListener: self)
        self.player?.load() { [weak self] result in
            guard let self = self else { return }
            if case let .success(viewController) = result {
                self.compactPlayerVC = viewController
                self.addViewControllerAsChild(self.compactPlayerVC, parentView: self.playerViewContainer)
            }
        }
    }
}

extension MainViewController: AudioburstPlayerErrorListener {
    func onError(error: AudioburstPlayerError) {
         self.showAlert(withTitle: "Error", message: error.localizedDescription)
    }
}

extension MainViewController: AudioburstPlayerListener {
    func onClose() {
        removeViewControllerAsChild(compactPlayerVC)
    }
}

extension MainViewController: ReloadableDelegate {

    func reloadPlayer(appKey: String, experienceId: String) {
        loadPlayer(appKey: appKey, experienceId: experienceId)
    }

    func reloadPlayer(configuration: ABPlayer.Configuration) {
        loadPlayer(configuration: configuration)
    }

    func closePlayer() {
        onClose()
    }

    func play() {
        player?.play()
    }

    func reloadVoiceData(data: Data) {
        player?.load(voiceData: data) { result in
            //empty
        }
    }
}


extension MainViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}

extension MainViewController {
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

extension MainViewController: PageboyViewControllerDataSource, TMBarDataSource {

    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }

    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }

    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }

    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        let title = "\(viewControllers[index].title ?? "" )"
        return TMBarItem(title: title)
    }
}


