import SwiftUI
import MapKit
import MessageUI
import EventKit
import CoreLocation

struct TutorDetails: View {
    let eventService = EventService()
    @State private var conceptsToCover = ""
    @State private var sessionDuration = 1
    @State private var price = 0.0
    @State private var selectedLocation: CLLocationCoordinate2D?
    @State var searchResults: [MKMapItem] = []
    @State private var visibleRegion: MKCoordinateRegion = .duke
    
    var body: some View {
        Form {
            Section(header: Text("Concepts to Cover")) {
                TextField("Concepts", text: $conceptsToCover)
            }
            
            Section(header: Text("Session Duration")) {
                Calendar()
            }
            
            Section(header: Text("Price")) {
                Slider(value: $price, in: 0...100, step: 1) {
                    Text("Price: $\(price, specifier: "%.2f")")
                }
            }
            
            Section(header: Text("Meeting Location")) {
                Navigator()
            }
            
            Button(action: {
                self.submit()
            }) {
                Text("Submit")
            }
            .disabled(conceptsToCover.isEmpty) /*|| selectedLocation == nil)*/
        }
        .navigationBarTitle("Tutor Details")
       
    }
    
    private func submit() {
        
    }
    
    func dateDisplay(for event: EKEvent) -> String {
      DateFormatters.mediumDate(event.startDate)
    }

    func timeDisplay(for event: EKEvent) -> String {
      DateFormatters.timeRange(event.startDate, event.endDate)
    }
}

#Preview {
    TutorDetails()
}
