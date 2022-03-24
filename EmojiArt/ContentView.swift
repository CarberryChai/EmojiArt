//
//  ContentView.swift
//  EmojiArt
//
//  Created by 柴长林 on 2022/3/16.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var document: EmojiArtDocument
    @State var steadyStateZoomScale: CGFloat = 1
    @GestureState var gestureZoomScale: CGFloat = 1
    private var zoomScale: CGFloat {
        steadyStateZoomScale * gestureZoomScale
    }

    @State var steadyStatePanOffset: CGSize = .zero
    @GestureState var gesturePanOffset: CGSize = .zero
    private var panOffset: CGSize {
        (steadyStatePanOffset + gesturePanOffset) * zoomScale
    }

    let defaultEmojiSize: CGFloat = 40

    var body: some View {
        VStack {
            documentBody
            palette
        }.onAppear {
            document.addEmoji("🍇", at: (-100, 50), size: defaultEmojiSize / zoomScale)
        }
    }

    var documentBody: some View {
        GeometryReader { geometry in
            ZStack {
                Color.white.overlay(
                    OptionalImage(uiImage: document.backgroundImage)
                        .scaleEffect(zoomScale)
                        .position(convertFromEmojiCoordinates((0, 0), in: geometry))
                )
                    .gesture(doubleTapToFit(in: geometry.size))
                if document.bgImgLoading {
                    ProgressView().scaleEffect(2)
                } else {
                    ForEach(document.emojis) { emoji in
                        Text(emoji.text)
                            .scaleEffect(zoomScale)
                            .font(.system(size: fontSize(for: emoji)))
                            .position(position(for: emoji, in: geometry))
                    }
                }
            }
                .clipped()
                .gesture(panGesture.simultaneously(with: zoomGesture))
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
                            document.addEmoji(String(c), at: convertToEmojiCoordinates(location, in: geometry), size: defaultEmojiSize / zoomScale)
                        }
                    }
                }
                return found
            }
        }
    }
    
    private var panGesture: some Gesture {
        DragGesture()
            .updating($gesturePanOffset) { latestDragPanOffset, gesturePanOffset, _ in
                gesturePanOffset = latestDragPanOffset.translation / zoomScale
            }
            .onEnded { finalDragGestureValue in
                steadyStatePanOffset = steadyStatePanOffset + finalDragGestureValue.translation / zoomScale
            }
    }

    private var zoomGesture: some Gesture {
        MagnificationGesture()
            .updating($gestureZoomScale, body: { theLastestState, gestureZoomScale, _ in
            gestureZoomScale = theLastestState
        })
            .onEnded { theEndedScaleState in
            steadyStateZoomScale = theEndedScaleState
        }
    }

    private func doubleTapToFit(in size: CGSize) -> some Gesture {
        TapGesture(count: 2)
            .onEnded {
            withAnimation {
                zoomToFit(document.backgroundImage, in: size)
            }
        }
    }

    private func zoomToFit(_ image: UIImage?, in size: CGSize) {
        guard let img = image, img.size.width > 0, img.size.height > 0, size.width > 0, size.height > 0 else { return }
        let hZoom = size.width / img.size.width
        let vZoom = size.height / img.size.height
        steadyStatePanOffset = .zero
        steadyStateZoomScale = min(hZoom, vZoom)
    }

    private func position(for emoji: EmojiArtModel.Emoji, in geometry: GeometryProxy) -> CGPoint {
        convertFromEmojiCoordinates((emoji.x, emoji.y), in: geometry)
    }

    private func convertToEmojiCoordinates(_ location: CGPoint, in geometry: GeometryProxy) -> (x: Int, y: Int) {
        let center = geometry.frame(in: .local).center
        let location = CGPoint(x: (location.x - panOffset.width - center.x) / zoomScale, y: (location.y - panOffset.height - center.y) / zoomScale)
        return (Int(location.x), Int(location.y))
    }

    private func convertFromEmojiCoordinates(_ location: (x: Int, y: Int), in geometry: GeometryProxy) -> CGPoint {
        let center = geometry.frame(in: .local).center
        return CGPoint(
            x: center.x + CGFloat(location.x) * zoomScale + panOffset.width,
            y: center.y + CGFloat(location.y) * zoomScale + panOffset.height
        )
    }

    private func fontSize(for emoji: EmojiArtModel.Emoji) -> CGFloat {
        CGFloat(emoji.size) * zoomScale
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
