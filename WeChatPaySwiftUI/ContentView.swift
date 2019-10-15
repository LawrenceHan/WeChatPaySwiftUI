//
//  ContentView.swift
//  WeChatPaySwiftUI
//
//  Created by Hanguang on 2019/10/11.
//  Copyright © 2019 hanguang. All rights reserved.
//

import SwiftUI
import Combine

struct ContentView: View {
    @ObservedObject var viewModel: ContentViewModel
    
    var body: some View {
        LoadingView(isShowing: viewModel.isLoading, title: "申请预支付请求", content: {
            Button(action: {
                self.viewModel.prePayRequest()
            }) {
                Text("给微信团队贡献一分钱")
            }
        }).alert(item: $viewModel.payResponse) { response in
            alert(title: response.title, message: response.message)
        }
    }
    
    private func alert(title: String, message: String) -> Alert {
        return Alert(title: Text(title), message: Text(message), dismissButton: nil)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ContentViewModel())
    }
}
