//
//  scrollNote_App.swift
//  scrollNote!
//
//  Created by 沈钰婷 on 2021/12/27.
//

import SwiftUI

@main
struct scrollNote_App: App {
    var body: some Scene {
        WindowGroup {
            let game = noteCardModel()
            scrollNoteView(model: game)
        }
    }
}
