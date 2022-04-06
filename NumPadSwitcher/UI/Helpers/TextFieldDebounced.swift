//
//  TextFieldDebounced.swift
//  NumPadSwitcher
//
//  Created by Michael Maxim on 8/27/21.
//

import SwiftUI
import Combine

class TextFieldObserver : ObservableObject {
  @Published var debouncedText = ""
  @Published var searchText = ""
  
  private var subscriptions = Set<AnyCancellable>()
  
  init() {
    $searchText
      .debounce(for: .milliseconds(200), scheduler: DispatchQueue.main)
      .sink(receiveValue: { t in
        self.debouncedText = t
      })
      .store(in: &subscriptions)
  }
}


struct TextFieldDebounced : View {
  var title: String
  @Binding var text: String
  @StateObject private var textObserver = TextFieldObserver()
  
  var body: some View {
    VStack {
      TextField(title, text: $textObserver.searchText)
    }.onReceive(textObserver.$debouncedText) { (val) in
      text = val
    }
  }
}
