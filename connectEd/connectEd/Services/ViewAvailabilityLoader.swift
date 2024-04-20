import Foundation

@Observable
class ViewAvailabilityLoader {
    let apiClient = ViewAvailabilityAPI()
    private(set) var state: LoadingState = .idle
    
    enum LoadingState {
        case idle
        case loading
        case success(data: ViewAvailabilityResponse)
        case failed(error: Error)
    }
    
    @MainActor
    func viewTutorAvailability(emailInput: EmailStruct) async {
        self.state = .loading
        do {
            let response = try await apiClient.viewAvailability(emailInput: emailInput)
            self.state = .success(data: response)
        } catch {
            self.state = .failed(error: error)
        }
    }
}
