//
//  Recorder.swift
//  Instant Recorder
//
//  Created by Alexey Pyzhianov on 06.06.2020.
//  Copyright © 2020 Alex Pyzhianov. All rights reserved.
//

import AVFoundation

private func createOutputURL() -> URL {
    let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    return URL(fileURLWithPath: "InstantRecorder.m4a", relativeTo: path)
}

class SoundRecorder: ObservableObject {
    static let shared = SoundRecorder()
    
    @Published var isRecording = false
    @Published var isPlaying = false
    
    private var outputUrl = createOutputURL()
    private var recorder: AVAudioRecorder?
    private var player: AVAudioPlayer?
    
    func startRecording() {
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
    
    func endRecording() {
        recorder?.stop()
        isRecording = false
        
        do {
            player = try AVAudioPlayer(contentsOf: outputUrl)
        } catch {
            print(error)
        }
    }
    
    func deleteRecording() {
        do {
            try FileManager.default.removeItem(at: outputUrl)
        } catch {
            print(error)
        }
    }
    
    func play() {
        player?.play()
        isPlaying = true
    }
    
    func pause() {
        player?.pause()
        isPlaying = false
    }
    
    func getPlaybackProgress() -> Double {
        if let player = self.player {
            return player.currentTime / player.duration
        }
        return Double(0)
    }
    
    func skipToPosition(time: Double) {
        if let player = self.player {
            player.currentTime = player.duration * time
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
            isRecording = true
        } catch {
            print(error)
        }
    }
}
