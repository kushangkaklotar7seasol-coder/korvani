//
//  CastCrewScreen.swift
//  Korvani
//
//  Created by Kushang kaklotar on 31/07/26.
//

import SwiftUI

struct CastCrewScreen: View {
    var cast: [CastMember] = []
    var crew: [CrewMember] = []
    var header: String = ""
    var isCast: Bool = true
    @Environment(\.dismiss) private var dismiss
    @State private var refreshID = UUID()
    @EnvironmentObject var adVm: AdCountViewModel
    @State var selectedCelebrityId: Int = 0
    @State var isShowCastDetails: Bool = false
    var columns: [GridItem] {
            let count = isiPad ? (Device.isiPadLandscape ? 6 : 5) : 3
            return Array(repeating: GridItem(.flexible(), spacing: 15), count: count)
        }
    
    var body: some View {
        ZStack {
            VStack {
                DefaultDesign.Header(name: header, back: {
                    self.dismiss()
                })
                .padding(.horizontal, 16)
                 
                if isCast {
                    ScrollView(showsIndicators: false) {
                        if isShowAdd() {
                            NativeAd6()
                        }
                        
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(cast.indices, id: \.self) { index in
                                MovieDetailsDesign.CastDetail(
                                    image: cast[index].profilePath ?? "",
                                    firstName: cast[index].name,
                                    lastName: ""
                                )
                                .onTapGesture {
                                    selectedCelebrityId = cast[index].id
                                    isShowCastDetails = true
                                    adVm.registerTap()
                                    logAnalyticAction(title: "", status: AnalyticEvent.CastCrew)
                                }
                            }
                        }
                        .padding(.top, 20)
                        .padding(.horizontal, 16)
                        .id(refreshID)
                    }
                } else  {
                    ScrollView(showsIndicators: false) {
                        if isShowAdd() {
                            NativeAd9()
                        }
                        
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(crew.indices, id: \.self) { index in
                                MovieDetailsDesign.CastDetail(
                                    image: crew[index].profilePath ?? "",
                                    firstName: crew[index].name,
                                    lastName: ""
                                )
                                .onTapGesture {
                                    selectedCelebrityId = crew[index].id
                                    isShowCastDetails = true
                                    adVm.registerTap()
                                    logAnalyticAction(title: "", status: AnalyticEvent.CastCrew)
                                }
                            }
                        }
                        .padding(.top, 20)
                        .padding(.horizontal, 16)
                        .id(refreshID)
                    }
                }
            }
        }
        .defaultPage()
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) {_ in
            refreshID = UUID()
        }
        .navigationDestination(isPresented: $isShowCastDetails) {
            CelebrityDetailsScreen(viewModel: CelebrityDetailsViewModel(celebrityId: selectedCelebrityId))
        }
    }
}

#Preview {
    CastCrewScreen()
}
