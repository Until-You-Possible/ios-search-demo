//
//  RecognitionView.swift
//  gatherSwiftUISearch
//
//  Created by Ray on 2023/3/9.
//

import SwiftUI
import AVFoundation


struct RecognitionView: View {
    
    @StateObject var speechRecognizer = SpeechRecognizer()
    @State private var isRecording = false
    
    var body: some View {
        NavigationView {
            VStack {
                HStack(alignment: .center) {
                    Text("What Can I Do For You With ?")
                }
                .font(.largeTitle)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .padding(.top, 80)
                
                VStack() {
                    Text("say something......")
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 40)
                    Text(speechRecognizer.transcript)
                }
                .padding(.top, 20)
                Spacer()
                HStack {
                    Button {
                        // do sth
                        if isRecording {
                            self.isRecording = false
                            speechRecognizer.stopTranscribing()
                        } else {
                            self.isRecording = true
                            speechRecognizer.reset()
                            speechRecognizer.transcribe()
                        }
                    } label: {
                        Text(isRecording ? "End Recording": "Start Recording")
                             .font(.headline)
                             .padding()
                             .foregroundColor(.white)
                             .background(Color.blue)
                             .cornerRadius(10)
                             .overlay(
                                 RoundedRectangle(cornerRadius: 10)
                                     .stroke(Color.blue, lineWidth: 2)
                             )
                    }
                
                }
            }
            .navigationTitle("wow-team-demo")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

}

struct RecognitionView_Previews: PreviewProvider {
    static var previews: some View {
        RecognitionView()
    }
}
