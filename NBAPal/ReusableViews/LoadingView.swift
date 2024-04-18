//
//  LoadingView.swift
//  NBAPal
//
//  Created by Roman Auersvald on 16.04.2024.
//

import SwiftUI

struct LoadingView<Content: View>: View {
    
    let isLoadingFail: Bool
    let isLoadingFinished: Bool
    
    let loadingDetail: Content
    
    let finishedView: Content
    let loadinFailView: Content
    
    var body: some View {
        ZStack {
            if isLoadingFail {
                loadinFailView
            } else
            if isLoadingFinished{
                finishedView
            } else {
                HStack {
                    Spacer()
                    VStack(alignment: .center) {
                        ProgressView {
                            loadingDetail
                        }
                        .progressViewStyle(.circular)
                    }
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    LoadingView(isLoadingFail: false, isLoadingFinished: false, loadingDetail: Text("Loading next Players..."), finishedView: Text(LocalizedStringKey("LoadingFinished")), loadinFailView: Text("Failed"))
}
