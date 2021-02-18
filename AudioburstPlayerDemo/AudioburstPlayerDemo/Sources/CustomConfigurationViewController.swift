//
//  CustomConfigurationViewController.swift
//  InternalDemoSDK
//
//  Created by Aleksander Kobylak on 15/01/2021.
//

import UIKit
import AudioburstPlayer
import AVFoundation

class CustomConfigurationViewController: UIViewController {

    override var title: String? {
        get {
            "Custom"
        }
        set {}
    }

    @IBOutlet weak var appKeyTextField: UITextField!
    @IBOutlet weak var actionSegmentedControl: UISegmentedControl!
    @IBOutlet weak var actionValueTextField: UITextField!
    @IBOutlet weak var playerModeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var playerThemeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var colorAccentTextField: UITextField!
    @IBOutlet weak var autoplaySegmentedControl: UISegmentedControl!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var reloadButton: UIButton!
    @IBOutlet weak var recordingStackView: UIStackView!

    var delegate: ReloadableDelegate?
    var storageInteractor: StorageInteractor!
    var recordingInteractor = RecordingInteractor()

    let playerActions = ["channel", "user", "source", "account", "voice"]
    let voiceActionIndex = 4


    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
               view.addGestureRecognizer(tap)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadConfiguration()
    }

    private func loadConfiguration() {
        if let configuration = storageInteractor.customItem?.configuration {
            appKeyTextField.text = configuration.appKey
            recordingStackView.isHidden = true
            actionValueTextField.isEnabled = true

            switch configuration.playerAction {
            case .channel(let category):
                actionSegmentedControl.selectedSegmentIndex = 0
                actionValueTextField.text = category

            case .userGenerated(let id):
                actionSegmentedControl.selectedSegmentIndex = 1
                actionValueTextField.text = id

            case .source(let id):
                actionSegmentedControl.selectedSegmentIndex = 2
                actionValueTextField.text = id

            case .account(let id):
                actionSegmentedControl.selectedSegmentIndex = 3
                actionValueTextField.text = id

            case .voice:
                actionSegmentedControl.selectedSegmentIndex = 4
                setVoiceActionState()
            @unknown default:
                debugPrint("Player action not supported")
            }

        colorAccentTextField.text = configuration.playerSettings.accentColor
        playerModeSegmentedControl.selectedSegmentIndex = configuration.playerSettings.mode?.index ?? 0
        playerThemeSegmentedControl.selectedSegmentIndex = configuration.playerSettings.theme?.index ?? 0
            autoplaySegmentedControl.selectedSegmentIndex = (configuration.playerSettings.autoplay ?? false) ? 0 : 1
        }
        else {
            //set default values
            actionSegmentedControl.selectedSegmentIndex = -1
            colorAccentTextField.text = "#ff009e"
            playerModeSegmentedControl.selectedSegmentIndex = 1
            playerThemeSegmentedControl.selectedSegmentIndex = 1
            autoplaySegmentedControl.selectedSegmentIndex = 1
        }
    }

    @objc func handleTap() {
        appKeyTextField.resignFirstResponder()
        actionValueTextField.resignFirstResponder()
        colorAccentTextField.resignFirstResponder()
        }

    private func setupView() {
        actionSegmentedControl.removeAllSegments()
        playerActions.enumerated().map{ (index, element) in
            actionSegmentedControl.insertSegment(withTitle: element, at: index, animated: false)
        }

        playerModeSegmentedControl.removeAllSegments()
        UserExperience.PlayerSettings.PlayerMode.allCases.enumerated().map{ (index, element) in
            playerModeSegmentedControl.insertSegment(withTitle: element.rawValue, at: index, animated: false)
        }

        playerThemeSegmentedControl.removeAllSegments()
        UserExperience.PlayerSettings.PlayerTheme.allCases.enumerated().map{ (index, element) in
            playerThemeSegmentedControl.insertSegment(withTitle: element.rawValue, at: index, animated: false)
        }

        appKeyTextField.delegate = self
        actionValueTextField.delegate = self
        colorAccentTextField.delegate = self

    }

    @IBAction func actionSegmentChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == voiceActionIndex {
            setVoiceActionState()
        }
        else {
            recordingStackView.isHidden = true
            actionValueTextField.isEnabled = true
            actionValueTextField.text = ""
        }
    }

    private func setVoiceActionState() {
        recordingStackView.isHidden = false
        actionValueTextField.isEnabled = false
        actionValueTextField.text = recordingInteractor.isRecordingAvailable ? "Voice data recorded" : "No voice data"
    }

    @IBAction func playButtonTapped(_ sender: Any) {
        delegate?.play()
    }

    @IBAction func reloadButtonTapped(_ sender: Any) {
        guard let appKey = appKeyTextField.text,
              !appKey.isEmpty  else { return }

        guard actionSegmentedControl.selectedSegmentIndex >= 0,
              playerModeSegmentedControl.selectedSegmentIndex >= 0,
              playerThemeSegmentedControl.selectedSegmentIndex >= 0 else { return }

        let playerAction: UserExperience.PlayerAction

        switch actionSegmentedControl.selectedSegmentIndex {
        case 0:
            playerAction = .channel(category: actionValueTextField.text ?? "")
        case 1:
            playerAction = .userGenerated(id: actionValueTextField.text ?? "")
        case 2:
            playerAction = .source(id: actionValueTextField.text ?? "")
        case 3:
            playerAction = .account(id: actionValueTextField.text ?? "")
        case 4:
            guard let contents = recordingInteractor.recordedData else { return }
            playerAction = UserExperience.PlayerAction.voice(data: contents)
        default:
            playerAction = .channel(category: "")
        }

        let mode = UserExperience.PlayerSettings.PlayerMode.allCases[playerModeSegmentedControl.selectedSegmentIndex]
        let theme = UserExperience.PlayerSettings.PlayerTheme.allCases[playerThemeSegmentedControl.selectedSegmentIndex]
        let accentColor =  colorAccentTextField.text
        let autoplay = autoplaySegmentedControl.selectedSegmentIndex == 0

        let playerConfiguration = ABPlayer.Configuration(appKey: appKey, playerAction: playerAction, mode: mode, theme: theme, accentColor: accentColor, autoPlay: autoplay)

        let configurationItem = ConfigurationItem(name: Constants.customItemName,
                                                  appKey: appKey,
                                                  experienceId: nil,
                                                  configuration: playerConfiguration)
        storageInteractor.saveCustom(configurationItem)
        delegate?.reloadPlayer(configuration: playerConfiguration)
    }
    
    @IBAction func reloadVoiceDataButtonTapped(_ sender: Any) {
        guard let voiceData = recordingInteractor.recordedData else { return }
        delegate?.reloadVoiceData(data: voiceData)
    }

    @IBAction func recordButtonTapped(_ sender: Any) {
        recordingInteractor.toggleRecording() {[weak self] recordingStarted in
            DispatchQueue.main.async {
                let title = recordingStarted ? "Stop recording" : "Record voice data"
                self?.recordButton.setTitle(title, for: .normal)
                self?.setVoiceActionState()
            }

        }
    }
}

extension CustomConfigurationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
    
