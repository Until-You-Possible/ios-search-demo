//
//  RecognitionViewModel.swift
//  gatherSwiftUISearch
//
//  Created by Ray on 2023/3/9.
//

import Foundation
import Speech


class RecognitionViewModel: ObservableObject {
    
    public var isRecording = false
    @Published var recognizedText = "user speech"
    public let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "zh-CN"))
    public var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    public var recognitionTask: SFSpeechRecognitionTask?
    public let audioEngine = AVAudioEngine()
    
    init() {
        
    }
    
    func recording () {
        if audioEngine.isRunning {
            audioEngine.stop()
            self.recognitionRequest?.endAudio()
            self.isRecording = false
        } else {
            startRecording()
            self.isRecording = true
        }
    }
    
    
    func startRecording() {
        self.recognitionTask?.cancel()
        self.recognitionTask = nil

        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Failed to set audio session category.")
        }

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()

        let inputNode = audioEngine.inputNode
        
//        guard let inputNode = audioEngine.inputNode else {
//            fatalError("Audio engine has no input node.")
//        }
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object.")
        }

        recognitionRequest.shouldReportPartialResults = true

        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { [self] result, error in
            var isFinal = false

            if let result = result {
                self.recognizedText = result.bestTranscription.formattedString
                isFinal = result.isFinal
            }

            if error != nil || isFinal {
                audioEngine.stop()
                inputNode.removeTap(onBus: 0)

                recognitionRequest.endAudio()
                recognitionTask = nil
            }
        })

        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            recognitionRequest.append(buffer)
        }

        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            print("Failed to start audio engine.")
        }

        recognizedText = "请开始说话..."
    }
    
}
