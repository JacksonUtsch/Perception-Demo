//
//  Perception_DemoApp.swift
//  Perception-Demo
//
//  Created by Jackson Utsch on 2/19/24.
//

import SwiftUI

@main
struct Perception_DemoApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView(.init(initialState: AppFeature.State(child: .init()), reducer: { AppFeature() }))
    }
  }
}
