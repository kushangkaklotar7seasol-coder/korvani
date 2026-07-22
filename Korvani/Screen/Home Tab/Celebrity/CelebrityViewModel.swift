//
//  CelebrityViewModel.swift
//  Korvani
//
//  Created by Kushang kaklotar on 11/07/26.
//

import Foundation
internal import Combine

class CelebrityViewModel : ObservableObject {
    @Published var celebrity: CelebrityResponse?
    @Published var isLoading = false
    @Published var isShowCelebrityDetail = false
    @Published var celebritySelectedId = 0
    
    init(celebrity: CelebrityResponse? = nil) {
        self.celebrity = celebrity
        self.celebrityAPI()
    }
    
    func celebrityAPI() {
        if Utility.isInternetAvailable() {
            self.isLoading = true
            HomeServices.shared.celecrityAPI(page: (celebrity?.page ?? 1) + 1) { statusCode, response in
                self.isLoading = false
                for i in response.results {
                    self.celebrity?.results.append(i)
                }
                self.celebrity?.page += 1
            } failure: { error in
                print(error)
                self.isLoading = false
            }
        } else {
            Toast.shared.show(message: noInternet, type: .error)
        }
    }
}
