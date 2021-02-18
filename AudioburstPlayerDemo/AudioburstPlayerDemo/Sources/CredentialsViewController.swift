//
//  CredentialsViewController.swift
//  InternalDemoSDK
//
//  Created by Aleksander Kobylak on 04/12/2020.
//

import UIKit
import AudioburstPlayer

class CredentialsViewController: UIViewController {

    override var title: String? {
        get {
            "Credentials"
        }
        set {}
    }

    @IBOutlet weak var reloadButton: UIButton!
    @IBOutlet weak var appKeyTextfield: UITextField!
    @IBOutlet weak var experienceIdTextfield: UITextField!
    @IBOutlet weak var versionLabel: UILabel!

    var delegate: ReloadableDelegate?
    var storageInteractor: StorageInteractor!

    var sdkVersion: String {
        get {
            guard let version = Bundle(for: ABPlayer.self)
                        .infoDictionary?["CFBundleShortVersionString"] as? String else { return "Unknown" }
                    return version
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if let menuItem = storageInteractor.credentialsItem {
            appKeyTextfield.text = menuItem.appKey
            experienceIdTextfield.text = menuItem.experienceId
        }

        versionLabel.text = "App version: \(Bundle.main.versionNumber) SDK version: \(sdkVersion)"
    }

    @IBAction func reloadButtonTapped(_ sender: Any) {

        if let experienceId = experienceIdTextfield.text,
           let appKey = appKeyTextfield.text,
           !experienceId.isEmpty,
           !appKey.isEmpty {
            let configurationItem = ConfigurationItem(name: Constants.credentialsItemName, appKey: appKey, experienceId: experienceId, configuration: nil)
            storageInteractor.saveCredentials(configurationItem)
            delegate?.reloadPlayer(appKey: appKey, experienceId: experienceId)

        }
    }
    
}
