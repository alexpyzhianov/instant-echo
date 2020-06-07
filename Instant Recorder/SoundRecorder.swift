//
//  Recorder.swift
//  Instant Recorder
//
//  Created by Alexey Pyzhianov on 06.06.2020.
//  Copyright © 2020 Alex Pyzhianov. All rights reserved.
//

import Cocoa
import AVFoundation

class SoundRecorder: NSObject {
    private var outputUrl: URL?
    private var recorder: AVAudioRecorder?
    
    open func start() {
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
    
    open func stop() {
        recorder?.stop()
    }
    
    private func record() {
        let url = createUniqueOutputURL()
        
        do {
            let format = AVAudioFormat(settings: [
                AVFormatIDKey: kAudioFormatMPEG4AAC,
                AVEncoderAudioQualityKey: AVAudioQuality.high,
                AVSampleRateKey: 44100.0,
                AVNumberOfChannelsKey: 2,
                AVLinearPCMBitDepthKey: 16,
            ])!
            let recorder = try AVAudioRecorder(url: url, format: format)
            
            // workaround against Swift, AVAudioRecorder: Error 317: ca_debug_string: inPropertyData == NULL issue
            // https://stackoverflow.com/a/57670740/598057
            let firstSuccess = recorder.record()
            if firstSuccess == false || recorder.isRecording == false {
                recorder.record()
            }
            assert(recorder.isRecording)
            
            self.recorder = recorder
            outputUrl = url
        } catch {
            print(error)
        }
    }

    private func createUniqueOutputURL() -> URL {
        let musicPath = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask)[0]
        let currentTime = Int(Date().timeIntervalSince1970 * 1000)
        
        return URL(fileURLWithPath: "InstantRecorder-\(currentTime).m4a", relativeTo: musicPath)
    }
}
