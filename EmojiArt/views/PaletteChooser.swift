//
//  PaletteChooser.swift
//  EmojiArt
//
//  Created by 柴长林 on 2022/3/30.
//

import SwiftUI

struct PaletteChooser: View {
    var emojiFontSize: CGFloat = 40
    var emojiFont: Font {
            .system(size: emojiFontSize)
    }
    @EnvironmentObject var store: PaletteStore
    @State var chosenPaletteIndex = 0
//    @State var editing = false
    @State private var paletteToEdit: Palette?
    @State private var managing = false

    var body: some View {
        HStack {
            paletteControlButton
            paletteBody(for: store.pallete(at: chosenPaletteIndex))
        }
            .clipped()

    }

    @ViewBuilder
    var contextMenu: some View {
        AnimatedActionButton(title: "Edit", systemImage: "pencil") {
//           editing = true
            paletteToEdit = store.pallete(at: chosenPaletteIndex)
        }
        AnimatedActionButton(title: "New", systemImage: "plus") {
//            editing = true
            store.insertPalette(named: "New", emojis: "", at: chosenPaletteIndex)
            paletteToEdit = store.pallete(at: chosenPaletteIndex)
        }
        AnimatedActionButton(title: "Delete", systemImage: "minus") {
            chosenPaletteIndex = store.removePalette(at: chosenPaletteIndex)
        }
        AnimatedActionButton(title: "Manager", systemImage: "slider.vertical.3") {
            managing = true
        }
        gotoMenu
    }

    var gotoMenu: some View {
        Menu {
            ForEach(store.palettes) { palette in
                AnimatedActionButton(title: palette.name) {
                    if let index = store.palettes.index(matching: palette) {
                        chosenPaletteIndex = index
                    }
                }
            }
        } label: {
            Label("Go To", systemImage: "text.insert")
        }
    }

    private var paletteControlButton: some View {
        Button {
            withAnimation {
                chosenPaletteIndex = min(chosenPaletteIndex + 1, store.palettes.count)
            }
        } label: {
            Image(systemName: "paintpalette")
        }
            .font(emojiFont)
            .contextMenu { contextMenu }
    }

    private func paletteBody(for palette: Palette) -> some View {
        HStack {
            Text(palette.name)
            ScrollingEmojisView(emojis: palette.emojis)
                .font(emojiFont)
        }
            .id(palette.id)
            .padding(.horizontal)
            .transition(rollTransition)
            .popover(item: $paletteToEdit) { palette in
                PaletteEditor(palette: $store.palettes[palette])
            }
            .sheet(isPresented: $managing) {
                PaletteManager()
            }
    }

    var rollTransition: AnyTransition {
        AnyTransition.asymmetric(insertion: .offset(x: 0, y: emojiFontSize), removal: .offset(x: 0, y: -emojiFontSize))
    }
}


struct ScrollingEmojisView: View {
    let emojis: String
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(emojis.removingDuplicateCharacters.map { String($0) }, id: \.self) { emoji in
                    Text(emoji)
                        .onDrag { NSItemProvider(object: emoji as NSString) }
                }
            }
        }
    }
}


struct PaletteChooser_Previews: PreviewProvider {
    static var previews: some View {
        PaletteChooser()
    }
}
