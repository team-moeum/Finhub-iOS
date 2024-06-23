//
//  ContentView.swift
//  app
//
//  Created by 정승덕 on 2024/02/08.
//

import SwiftUI

struct ContentView: View {
    @State private var keyboardHeight: CGFloat
    @State private var url: String
    
    init() {
        self.keyboardHeight = 0
        self.url = Static.baseUrl + Static.viewUrl
    }
    
    var body: some View {
        ZStack {
            Webview(url: $url)
                .edgesIgnoringSafeArea(.top)
                .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { notification in
                    if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                        self.keyboardHeight = keyboardFrame.height
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                    self.keyboardHeight = 0
                }
                .onReceive(NotificationCenter.default.publisher(for: .push), perform: { notification in
                    if let data = notification.userInfo?["data"] as? String,
                       let json = data.convertToDictionary() {
                        
                        if let view = json.getString("view") {
                            url = ""
                            url = Static.baseUrl + view
                        }
                    }
                })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
