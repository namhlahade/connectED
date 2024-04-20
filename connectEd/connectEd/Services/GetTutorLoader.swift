//
//  GetTutorLoader.swift
//  connectEd
//
//  Created by Namh Lahade on 4/19/24.
//

import Foundation

@Observable
class GetTutorLoader {
    let apiClient = GetTutorAPI()
    private(set) var state: LoadingState = .idle
    
    enum LoadingState {
        case idle
        case loading
        case success(data: TutorsResponse)
        case failed(error: Error)
    }
    
    @MainActor
    func getAllTutorInfo() async {
        self.state = .loading
        do {
            let response = try await apiClient.getTutor()
            self.state = .success(data: response)
        } catch {
            self.state = .failed(error: error)
        }
    }
    
}
