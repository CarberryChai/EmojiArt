//
//  PaletteEditor.swift
//  EmojiArt
//
//  Created by 柴长林 on 2022/3/31.
//

import SwiftUI

struct PaletteEditor: View {
    @Binding var palette: Palette
    @State var currentEmojis = ""
    var body: some View {
        Form {
            nameSection
            addEmojisSection
            removeEmojisSection
        }
            .navigationTitle("Edit \(palette.name)")
            .frame(minWidth: 300, minHeight: 350)
    }

    var nameSection: some View {
        Section(header: Text("Name")) {
            TextField("Name", text: $palette.name)
        }
    }

    var addEmojisSection: some View {
        Section(header: Text("Add Emojis")) {
            TextField("", text: $currentEmojis)
                .disableAutocorrection(true)
                .onChange(of: currentEmojis) { newValue in
                withAnimation {
                    palette.emojis = fileterEmoji(newValue + palette.emojis)
                }
            }
        }
    }

    var removeEmojisSection: some View {
        Section(header: Text("Remove Emojis")) {
            let emojis = palette.emojis.removingDuplicateCharacters.map { String($0) }
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))]) {
                ForEach(emojis, id: \.self) { emoji in
                    Text(emoji)
                        .onTapGesture {
                        withAnimation {
                            palette.emojis.removeAll(where: { String($0) == emoji })
                        }
                    }
                }
            }
        }
    }

    private func fileterEmoji(_ emojis: String) -> String {
        emojis.filter { $0.isEmoji }.removingDuplicateCharacters
    }
}

