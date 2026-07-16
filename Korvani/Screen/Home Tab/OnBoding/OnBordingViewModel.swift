//
//  OnBordingViewModel.swift
//  Korvani
//
//  Created by Kushang kaklotar on 09/07/26.
//

import Foundation
internal import Combine

class OnBordingViewModel : ObservableObject {
    @Published var selectedTab = 0
    @Published var information: [OnBordingInfo] = [OnBordingInfo(id: 0, image: "img_onbording0", name: Strings.page1Title, info: Strings.page1Info),
                                                   OnBordingInfo(id: 1, image: "img_onbording1", name: Strings.page2Title, info: Strings.page2Info),
                                                   OnBordingInfo(id: 2, image: "img_onbording2", name: Strings.page3Title, info: Strings.page3Info),
                                                   OnBordingInfo(id: 3, image: "img_onbording3", name: Strings.page4Title, info: Strings.page4Info, moreInfo: Strings.page4MoreInfo)]
    @Published var isShowHome = false
}
