//
//  PaletteEditor.swift
//  EmojiArt
//
//  Created by 柴长林 on 2022/3/31.
//

import SwiftUI

struct PaletteEditor: View {
    @Binding var palette: Palette
    var body: some View {
        Form {
            TextField("Name", text: $palette.name)
        }
            .frame(minWidth: 300, minHeight: 350)
    }
}

