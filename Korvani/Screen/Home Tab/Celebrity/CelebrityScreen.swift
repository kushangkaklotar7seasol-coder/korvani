//
//  CelebrityScreen.swift
//  Korvani
//
//  Created by Kushang kaklotar on 11/07/26.
//

import SwiftUI
import Kingfisher

struct CelebrityScreen: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: CelebrityViewModel
    @State private var refreshID = UUID()
    @EnvironmentObject var adVm: AdCountViewModel
    
    var columns: [GridItem] {
            let count = isiPad ? (Device.isiPadLandscape ? 6 : 5) : 3
            return Array(repeating: GridItem(.flexible(), spacing: 15), count: count)
        }
    
    var body: some View {
        ZStack {
            VStack(spacing: 5) {
                
                DefaultDesign.Header(name: "ABOUT_CELEBRITY", back: {
                    self.dismiss()
                })
                .padding(.horizontal, 16)
                
                ScrollView(showsIndicators: false) {
                    
                    if isShowAdd() {
                        NativeAd9()
                    }
                    
                    if let array = viewModel.celebrity?.results {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(array.indices, id: \.self) { person in
                                celebrity.profile(celebrity: array[person])
                                    .onTapGesture {
                                        viewModel.isShowCelebrityDetail = true
                                        viewModel.celebritySelectedId = array[person].id
                                        adVm.registerTap()
                                    }
                                    .onAppear() {
                                        loadMoreIfNeeded(currentItem: person)
                                    }
                            }
                        }
                        .padding(.top, 20)
                        .padding(.horizontal, 16)
                        .id(refreshID)
                    }
                }
                
                Spacer()
            }
            
        }
        .defaultPage()
        .edgesIgnoringSafeArea(.bottom)
        .navigationDestination(isPresented: $viewModel.isShowCelebrityDetail) {
            CelebrityDetailsScreen(viewModel: CelebrityDetailsViewModel(celebrityId: viewModel.celebritySelectedId))
        }
        .onAppear {
            SwipeBackManager.shared.isEnabled = true
        }
        .onReceive(
            NotificationCenter.default.publisher(
                for: UIDevice.orientationDidChangeNotification
            )
        ) { _ in
            refreshID = UUID()
        }
    }
    
    func loadMoreIfNeeded(currentItem: Int) {
        guard !viewModel.isLoading, currentItem == (viewModel.celebrity?.results.count ?? 0) - 5 else { return }
        viewModel.celebrityAPI()
    }
}

#Preview {
    CelebrityScreen(viewModel: CelebrityViewModel())
}

class celebrity {
    
    struct profile: View {
        var celebrity: Celebrity
        
        var size: CGFloat {
            if isiPad {
                
                if Device.isiPadLandscape {
//                    return (screenHeight-60)/5
//                    return (screenHeight-28)/6
                    return (screenWidth-60)/6
                } else {
                    return (screenWidth-60)/5
                }
            } else {
                return (screenWidth-60)/3
            }
        }
        
        var body: some View {
            VStack(alignment: .leading) {
                ZStack {
                    KFImage.url(URL(string: imageUrl+(celebrity.profilePath ?? "")))
                        .placeholder({ progress in
                            Image("img_nopeople")
                                .resizable()
                                .scaledToFill()
                        })
                        .resizable()
                        .scaledToFill()
                }
                .frame(width: size, height: size, alignment: .center)
                .cornerRadius(14)
                
                Text(celebrity.name)
                    .font(.system(size: 14,weight: .regular))
                    .lineLimit(1)
            }
            .frame(width: size)
        }
    }
}

class DefaultDesign {
    struct Header: View {
        var name: String? = nil
        var icon: String = "ic_back"
        var secondIcon: String = "ic_share_background"
        var isShowSecondbutton = false
        var isShowBackButton = true
        var font: Font = .system(size: 18, weight: .medium)
        
        var back: (() -> Void)?
        var secondButton: (() -> Void)?
        
        var body: some View {
            HStack {
                if isShowBackButton {
                    Button {
                        self.back?()
                    } label: {
                        Image(icon)
                            .resizable()
                            .frame(width: 40, height: 40, alignment: .center)
                    }
                }
                
                if name != nil {
                    Text(name?.localized() ?? "")
                        .font(font)
                        .foregroundColor(.whiteColour)
                }
                
                Spacer()
                
                if isShowSecondbutton {
                    Button {
                        self.secondButton?()
                    } label: {
                        Image(secondIcon)
                            .resizable()
                            .frame(width: 40, height: 40, alignment: .center)
                    }
                }
            }
        }
    }
    
    struct Loader: View {
        var body: some View {
            ZStack {
                ProgressView()
                    .tint(.whiteColour)
            }
        }
    }
}
