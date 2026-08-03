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
//    @EnvironmentObject var orientation: OrientationObserver
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
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(cast.indices, id: \.self) { index in
                                MovieDetailsDesign.CastDetail(
                                    image: cast[index].profilePath ?? "",
                                    firstName: cast[index].name,
                                    lastName: ""
                                )
//                                .onTapGesture {
//                                    viewModel.selectedCelebrityId = cast[index].id
//                                    viewModel.isShowCastDetails = true
//                                }
                            }
                        }
                        .padding(.top, 20)
                    }
                }
                // ૨. જો isCast False હોય અથવા Cast ખાલી હોય, તો Crew ચેક કરશે
                else  {
                    ScrollView(showsIndicators: false) {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(crew.indices, id: \.self) { index in
                                MovieDetailsDesign.CastDetail(
                                    image: crew[index].profilePath ?? "",  // અહીં crew[index] વાપરવું
                                    firstName: crew[index].name,          // અહીં crew[index] વાપરવું
                                    lastName: ""
                                )
//                                .onTapGesture {
//                                    viewModel.selectedCelebrityId = crew[index].id
//                                    viewModel.isShowCastDetails = true
//                                }
                            }
                        }
                        .padding(.top, 20)
                    }
                }
                // ૩. જો Cast અને Crew બંને ખાલી હોય તો નો ડેટા લેબલ બતાવશે
//                else {
//                    VStack(spacing: 12) {
//                        Spacer()
//                        Image(systemName: "person.slash")
//                            .font(.system(size: 40))
//                            .foregroundColor(.gray)
//                        
//                        Text("No Cast or Crew Available")
//                            .font(.system(size: 16, weight: .medium))
//                            .foregroundColor(.gray)
//                        Spacer()
//                    }
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//                }
                
            }
            .id(refreshID)
        }
        .defaultPage()
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) {_ in
            refreshID = UUID()
        }
    }
}

#Preview {
    CastCrewScreen()
}
