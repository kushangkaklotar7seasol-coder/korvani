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
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ZStack {
            VStack(spacing: 5) {
                
                HStack {
                    Button {
                        self.dismiss()
                    } label: {
                        Image("ic_back")
                            .resizable()
                            .frame(width: 40, height: 40, alignment: .center)
                    }
                    
                    Text("About the Celebrity")
                        .font(.system(size: 18, weight: .medium))
                    
                    Spacer()
                }
                
                ScrollView(showsIndicators: false) {
                    if let array = viewModel.celebrity?.results {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(array.indices, id: \.self) { person in
                                celebrity.profile(celebrity: array[person])
                                    .onAppear() {
                                        loadMoreIfNeeded(currentItem: person)
                                    }
                            }
                        }
                        .padding(.top, 20)
                    }
                }
                
                Spacer()
            }
        }
        .padding(.horizontal, 16)
        .defaultPage()
        .edgesIgnoringSafeArea(.bottom)
    }
    
    func loadMoreIfNeeded(currentItem: Int) {
        print(currentItem)
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
        var size = {
            return (screenWidth-60)/3
        }
        
        var body: some View {
            VStack(alignment: .leading) {
                ZStack {
                    KFImage.url(URL(string: imageUrl+(celebrity.profilePath ?? "")))
                        .resizable()
                        .scaledToFill()
                }
                .frame(width: size(), height: size(), alignment: .center)
                .background(.whiteColour)
                .cornerRadius(12)
                
                Text(celebrity.name)
                    .font(.system(size: 14,weight: .regular))
                    .lineLimit(1)
            }
        }
    }
}
