//
//  HomeViewModel.swift
//  Korvani
//
//  Created by Kushang kaklotar on 10/07/26.
//

import Foundation
internal import Combine

class HomeViewModel : ObservableObject {
    @Published var selectedTab = 0
    @Published var information: [OnBordingInfo] = [OnBordingInfo(id: 0, image: "", name: Strings.page1Title, info: Strings.page1Info),
                                                   OnBordingInfo(id: 1, image: "", name: Strings.page2Title, info: Strings.page2Info),
                                                   OnBordingInfo(id: 2, image: "", name: Strings.page3Title, info: Strings.page3Info),
                                                   OnBordingInfo(id: 3, image: "", name: Strings.page4Title, info: Strings.page4Info, moreInfo: Strings.page4MoreInfo)]
   
}
