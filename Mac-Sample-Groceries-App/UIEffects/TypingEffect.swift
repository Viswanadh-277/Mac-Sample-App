//
//  TypingEffect.swift
//  Mac-Sample-Groceries-App
//
//  Created by Durga Viswanadh on 20/07/24.
//

import SwiftUI
import AVFoundation

struct TypingEffect: ViewModifier {
    @State private var displayText: String = ""
    let text: String
    let speed: Double
    
    func body(content: Content) -> some View {
        Text(displayText)
            .onAppear {
                displayText = ""
                var index = 0
                Timer.scheduledTimer(withTimeInterval: speed, repeats: true) { timer in
                    if index < text.count {
                        displayText.append(text[text.index(text.startIndex, offsetBy: index)])
                        index += 1
                    } else {
                        timer.invalidate()
                    }
                }
            }
    }
}

extension View {
    func typingEffect(text: String, speed: Double) -> some View {
        self.modifier(TypingEffect(text: text, speed: speed))
    }
}

