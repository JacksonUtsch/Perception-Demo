//
//  ChildFeature.swift
//  Perception-Demo
//
//  Created by Jackson Utsch on 3/1/24.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct ChildFeature {
  @ObservableState
  struct State: Hashable {
    var count: Int = 0
  }

  typealias Action = Result<Success, Failure>

  enum Success: Hashable {
    case incr
  }

  enum Failure: Error, Hashable {
    case failedToIncr
  }

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      guard case .success(let success) = action else { return .none }
      switch success {
      case .incr:
        state.count += 1
        return .none
      }
    }
  }
}

struct ChildView: View {
  let store: StoreOf<ChildFeature>

  init(_ store: StoreOf<ChildFeature>) {
    self.store = store
  }

  var body: some View {
    WithPerceptionTracking {
      VStack {
        Text("Child View \(store.count)")

        Button(action: {
          if store.count == 2 {
            store.send(.success(.incr))
          } else {
            store.send(.success(.incr))
          }
        }, label: {
          Text("Incr")
        })
      }.padding()
    }
  }
}
