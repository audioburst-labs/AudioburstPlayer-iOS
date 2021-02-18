//
//  RecordingInteractor.swift
//  AudioburstPlayerDemo
//
//  Created by Aleksander Kobylak on 08/02/2021.
//  Copyright © 2021 Audioburst. All rights reserved.
//

import Foundation
import AVFoundation
import AudioburstPlayer

class RecordingInteractor {

    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!

    var recordingPath: URL? = nil

    var isRecordingAvailable: Bool {
        recordedData != nil
    }
    
    var soundID: SystemSoundID = 0

    var recordedData: Data? {
        do {
            guard let recordingPath = recordingPath else {return nil}
            return try Data(contentsOf: recordingPath)
        } catch {
            debugPrint("File not found")
            return nil
        }
    }

    init() {
        recordingPath = getDocumentsDirectory().appendingPathComponent(Constants.audiofileName)
        if let soundUrl = Bundle.main.url(forResource: "beep", withExtension: "wav") {
            AudioServicesCreateSystemSoundID(soundUrl as CFURL, &soundID)
        }
    }

    func toggleRecording(completion: @escaping (_ recordingStarted: Bool) -> Void) {
        recordingSession = AVAudioSession.sharedInstance()
        recordingSession.requestRecordPermission() { [unowned self] allowed in
            if allowed {
                if audioRecorder == nil {
                    AudioServicesPlaySystemSound(soundID)
                    startRecording(completion: completion)
                } else {
                    finishRecording()
                    AudioServicesPlaySystemSound(soundID)
                    completion(false)
                }
            } else {
                completion(false)
            }
        }
    }

    private func startRecording(completion: @escaping (_ recordingStarted: Bool) -> Void) {
        guard let recordingPath = recordingPath else { return }

        let settings = [
            AVFormatIDKey: Int(kAudioFormatLinearPCM),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            audioRecorder = try AVAudioRecorder(url: recordingPath, settings: settings)
            audioRecorder.record()
            completion(true)
        } catch {
            finishRecording()
            completion(false)
        }
    }

    private func finishRecording() {
        do {
            audioRecorder.stop()
            audioRecorder = nil
            try recordingSession.setCategory(.playback, mode: .default)
        } catch {
            debugPrint("Error on finishing recording")
        }
    }

    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}




