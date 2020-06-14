//
//  ContentView.swift
//  Instant Recorder
//
//  Created by Alexey Pyzhianov on 31.05.2020.
//  Copyright © 2020 Alex Pyzhianov. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var progress: Double = 0
    @State var timer: Timer?
    @ObservedObject private var recorder = SoundRecorder.shared
    
    var body: some View {
        VStack {
            Slider(value: Binding(get: { self.progress }, set: { newVal in
                self.progress = newVal
                self.recorder.skipToPosition(time: newVal)
            }), in: 0.0...1.0, step: 0.001).onAppear {
                self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
                    self.progress = self.recorder.getPlaybackProgress()
                })
            } .onDisappear {
                self.timer?.invalidate()
                self.timer = nil
            }
            
            HStack {
                if recorder.isPlaying {
                    Button(action: {
                        self.recorder.pause()
                    }) {
                        Text("Pause")
                    }
                    
                } else {
                    Button(action: {
                        self.recorder.play()
                    }) {
                        Text("Play")
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
