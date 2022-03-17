//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by 柴长林 on 2022/3/16.
//

import SwiftUI

@main
struct EmojiArtApp: App {
    @StateObject var model = EmojiArtDocument()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(model)
        }
    }
}
