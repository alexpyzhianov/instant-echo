//
//  Recorder.swift
//  Instant Recorder
//
//  Created by Alexey Pyzhianov on 06.06.2020.
//  Copyright © 2020 Alex Pyzhianov. All rights reserved.
//

import AVFoundation

private func createOutputURL() -> URL {
    let path = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask)[0]
    return URL(fileURLWithPath: "InstantRecorderLatest.m4a", relativeTo: path)
}

class SoundRecorder: ObservableObject {
    static let shared = SoundRecorder()
    
    @Published var outputUrl = createOutputURL()
    @Published var isRecording = false
    
    private var recorder: AVAudioRecorder?
    private var player: AVAudioPlayer?
    private init() {}
    
    func start() {
        switch AVCaptureDevice.authorizationStatus(for: .audio) {
        case .authorized:
            record();
            
        case .notDetermined, .denied:
            AVCaptureDevice.requestAccess(for: .audio) { granted in
                if granted {
                    self.record()
                }
            }
            
        case .restricted:
            print("Oops")
            
        @unknown default:
            fatalError()
        }
    }
    
    func stop() {
        recorder?.stop()
        isRecording = false
    }
    
    func clear() {
        do {
            try FileManager.default.removeItem(at: outputUrl)
        } catch {
            print(error)
        }
    }
    
    func play() {
        do {
            player = try AVAudioPlayer(contentsOf: outputUrl)
            player?.play()
        } catch {
            print(error)
        }
    }
    
    func pause() {
        player?.pause()
    }
    
    private func record() {
        let format = AVAudioFormat(settings: [
            AVFormatIDKey: kAudioFormatMPEG4AAC,
            AVEncoderAudioQualityKey: AVAudioQuality.high,
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 2,
            AVLinearPCMBitDepthKey: 16,
        ])!
        
        do {
            self.recorder = try AVAudioRecorder(url: outputUrl, format: format)
            recorder?.record()
            isRecording = true
        } catch {
            print(error)
        }
    }
}
