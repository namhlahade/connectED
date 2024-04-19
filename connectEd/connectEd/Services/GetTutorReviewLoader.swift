//
//  AddTutorReviewLoader.swift
//  connectEd
//
//  Created by Namh Lahade on 4/19/24.
//

import Foundation

@Observable
class AddTutorReviewLoader {
    let apiClient = GetTutorReviewAPI()
    private(set) var state: LoadingState = .idle
    
    enum LoadingState {
        case idle
        case loading
        case success(data: ReviewResponse)
        case failed(error: Error)
    }
    
    @MainActor
    func getTutorInfo(email: EmailStruct) async {
        self.state = .loading
        do {
            let response = try await apiClient.getTutorReviews(email: email)
            self.state = .success(data: response)
        } catch {
            self.state = .failed(error: error)
        }
    }
}
