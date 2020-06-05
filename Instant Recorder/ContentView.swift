//
//  ContentView.swift
//  Instant Recorder
//
//  Created by Alexey Pyzhianov on 31.05.2020.
//  Copyright © 2020 Alex Pyzhianov. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var progress = 0.0
    
    var body: some View {
        VStack {
            Slider(value: $progress, in: 0.0...1.0, step: 0.01)
            
            HStack {
                Button(action: {
                    print("play")
                }) {
                    Text("Play")
                }
                
                Button(action: {
                    print("pause")
                }) {
                    Text("Pause")
                }
                
                Button(action: {
                    print("delete")
                }) {
                    Text("Delete")
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
