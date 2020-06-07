//
//  Recorder.swift
//  Instant Recorder
//
//  Created by Alexey Pyzhianov on 06.06.2020.
//  Copyright © 2020 Alex Pyzhianov. All rights reserved.
//

import Cocoa
import AVFoundation

func createOutputURL() -> URL {
    let path = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask)[0]
    return URL(fileURLWithPath: "InstantRecorderLatest.m4a", relativeTo: path)
}

class SoundRecorder: NSObject {
    var recorder: AVAudioRecorder?
    var outputUrl = createOutputURL()
    
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
    }
    
    func clear() {
        do {
            try FileManager.default.removeItem(at: outputUrl)
        } catch {
            print(error)
        }
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
        } catch {
            print(error)
        }
    }
}
