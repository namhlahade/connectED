import Foundation

@Observable
class AddAvailablityLoader {
    let apiClient = AddAvailabilityAPI()
    private(set) var state: LoadingState = .idle
    
    enum LoadingState {
        case idle
        case loading
        case success(data: AddAPIResponse)
        case failed(error: Error)
    }
    
    @MainActor
    func addTutorInfo(availabilityInput: AddAvalabilityInput) async {
        self.state = .loading
        do {
            let response = try await apiClient.addAvailability(availabilityInput: availabilityInput)
            self.state = .success(data: response)
        } catch {
            self.state = .failed(error: error)
        }
    }
}
