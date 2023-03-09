//
//  RecognitionView.swift
//  gatherSwiftUISearch
//
//  Created by Ray on 2023/3/9.
//

import SwiftUI
import Speech

struct RecognitionView: View {
    
    var viewModel = RecognitionViewModel()

    var body: some View {
        VStack {
            Text(viewModel.recognizedText)
            Button(action: {
                viewModel.recording()
            }) {
                if viewModel.isRecording {
                    Text("停止")
                } else {
                    Text("录音")
                }
            }
        }
    }

}

struct RecognitionView_Previews: PreviewProvider {
    static var previews: some View {
        RecognitionView()
    }
}
