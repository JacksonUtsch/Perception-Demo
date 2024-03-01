//
//  ContentView.swift
//  Perception-Demo
//
//  Created by Jackson Utsch on 2/19/24.
//

import ComposableArchitecture
import SwiftUI

struct ContentView: View {
  let store: StoreOf<AppFeature>

  init(_ store: StoreOf<AppFeature>) {
    self.store = store
  }

  var body: some View {
    WithPerceptionTracking {
      VStack {
        Image(systemName: "globe")
          .imageScale(.large)

        Text("Hello, world! \(String(describing: store.session))")

        Button(action: {
          if let session = store.session {
            store.send(.setSession(session + 1))
          } else {
            store.send(.setSession(5))
          }
        }, label: {
          Text("Button")
        })
      }.padding()

      ChildView(store.scope(state: \.child, action: \.toAppAction))
    }
  }
}

@Reducer
struct AppFeature {
  @ObservableState
  struct State {
    var session: Int?
    var child: ChildFeature.State
  }
  enum Action {
    case setSession(Int?)
    case child(ChildFeature.Success)
    case handleFailure(Failure)
  }
  enum Failure: Error {
    case child(ChildFeature.Failure)
  }

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .setSession(let session):
        state.session = session
        return .none
      case .child(let childAction):
        return ChildFeature()
          .reduce(into: &state.child, action: .success(childAction))
          .map({ result in
            switch result {
            case .success(let success):
              return Action.child(success)
            case .failure(let failure):
              return Action.handleFailure(.child(failure))
            }
          })
      case .handleFailure(let failure):
        // toast, retry, send to monitoring etc..
        return .none
      }
    }
  }
}

extension ChildFeature.Action {
  var toAppAction: AppFeature.Action {
    switch self {
    case .success(let success):
      return .child(success)
    case .failure(let failure):
      return .handleFailure(.child(failure))
    }
  }
}
