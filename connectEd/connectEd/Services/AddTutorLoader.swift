//
//  AddTutorLoader.swift
//  connectEd
//
//  Created by Namh Lahade on 4/19/24.
//

import Foundation

@Observable
class AddTutorLoader {
    let apiClient = AddTutorAPI()
    private(set) var state: LoadingState = .idle
    
    enum LoadingState {
        case idle
        case loading
        case success(data: AddAPIResponse)
        case failed(error: Error)
    }
    
    @MainActor
    func addTutorInfo(tutor: AddTutorStruct) async {
        self.state = .loading
        do {
            let response = try await apiClient.addTutor(tutor: tutor)
            self.state = .success(data: response)
        } catch {
            self.state = .failed(error: error)
        }
    }
}
