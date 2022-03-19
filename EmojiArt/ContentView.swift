//
//  ContentView.swift
//  EmojiArt
//
//  Created by 柴长林 on 2022/3/16.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var document: EmojiArtDocument
    let defaultEmojiSize: CGFloat = 40
    var body: some View {
        VStack {
            documentBody
            palette
        }.onAppear {
            document.addEmoji("🍇", at: (-100, 50), size: 50)
        }
    }

    var documentBody: some View {
        GeometryReader { geometry in
            ZStack {
                Color.white.overlay(
                    OptionalImage(uiImage: document.backgroundImage)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .aspectRatio(contentMode: .fit)
                        .position(convertFromEmojiCoordinates((0, 0), in: geometry))
                )
                ForEach(document.emojis) { emoji in
                    Text(emoji.text)
                        .font(.system(size: fontSize(for: emoji)))
                        .position(position(for: emoji, in: geometry))
                }
            }
                .onDrop(of: [.plainText, .url, .data], isTargeted: nil) { providers, location in
                var found = providers.loadObjects(ofType: URL.self) { url in
                    document.setBackground(.url(url.imageURL))
                }
                if !found {
                    found = providers.loadObjects(ofType: UIImage.self, using: { img in
                        if let data = img.jpegData(compressionQuality: 1) {
                            document.setBackground(.imageData(data))
                        }
                    })
                }
                if !found {
                    found = providers.loadObjects(ofType: String.self) { string in
                        if let c = string.first, c.isEmoji {
                            document.addEmoji(String(c), at: convertToEmojiCoordinates(location, in: geometry), size: defaultEmojiSize)
                        }
                    }
                }
                return found
            }
        }
    }

    private func position(for emoji: EmojiArtModel.Emoji, in geometry: GeometryProxy) -> CGPoint {
        convertFromEmojiCoordinates((emoji.x, emoji.y), in: geometry)
    }

    private func convertToEmojiCoordinates(_ location: CGPoint, in geometry: GeometryProxy) -> (x: Int, y: Int) {
        let center = geometry.frame(in: .local).center
        return (Int(location.x - center.x), Int(location.y - center.y))
    }

    private func convertFromEmojiCoordinates(_ location: (x: Int, y: Int), in geometry: GeometryProxy) -> CGPoint {
        let center = geometry.frame(in: .local).center
        return CGPoint(x: center.x + CGFloat(location.x), y: center.y + CGFloat(location.y))
    }

    private func fontSize(for emoji: EmojiArtModel.Emoji) -> CGFloat {
        CGFloat(emoji.size)
    }

    var palette: some View {
        ScrollingEmojisView(emojis: testEmojis)
            .font(.system(size: defaultEmojiSize))
    }

    let testEmojis = "🎤🛵⚽️🏀🏈🪀🥍🏑🏒🏸🏏🪃🥅⛳️🚗🚌⌚️📱💻⌨️⏰📡🌽🥕🍒🍇"
}

struct ScrollingEmojisView: View {
    let emojis: String
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(emojis.map { String($0) }, id: \.self) { emoji in
                    Text(emoji)
                        .onDrag { NSItemProvider(object: emoji as NSString) }
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
