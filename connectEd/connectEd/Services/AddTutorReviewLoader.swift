import Foundation

@Observable
class AddTutorReviewLoader {
    let apiClient = AddTutorReviewAPI()
    private(set) var state: LoadingState = .idle
    
    enum LoadingState {
        case idle
        case loading
        case success(data: AddAPIResponse)
        case failed(error: Error)
    }
    
    @MainActor
    func addTutorReview(tutorReviewInput: TutorReviewInputStruct) async {
        self.state = .loading
        do {
            let response = try await apiClient.addTutorReview(tutorReviewInput: tutorReviewInput)
            self.state = .success(data: response)
        } catch {
            self.state = .failed(error: error)
        }
    }
}
