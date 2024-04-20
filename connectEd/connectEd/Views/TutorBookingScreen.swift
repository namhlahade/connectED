import SwiftUI
import MapKit
import MessageUI
import EventKit
import CoreLocation

struct TutorBookingScreen: View {
    @Bindable var tutor: Tutor
    @State private var selectedCourse = ""
    @State private var sessionDuration = 1
    @State private var price = 0.0
    @State private var selectedLocation: CLLocationCoordinate2D?
    @State var searchResults: [MKMapItem] = []
    @State private var visibleRegion: MKCoordinateRegion = .duke
    @State private var selectedOptionIndex = 0
    @State private var isPresentingNavigator: Bool = false
    
    var body: some View {
        Form {
        
            Section(header: Text("Select a Course:")) {
                if tutor.courses.isEmpty {
                    Text("No available courses to select")
                }
                else {
                    Picker(selection: $selectedCourse, label: Text("")) {
                        ForEach(tutor.courses) { course in
                            Text("\(course.subject.rawValue.uppercased()) \(course.code)").frame(maxWidth: .infinity, alignment: .center)
                            
                        }
                    }.labelsHidden()
                }
            }
            
            ProfileSection(title: "Meeting Time", sectionLabels: ["\(tutor.name)'s Availability"], sectionData: [tutor.availability.count == 0 ? "No availability provided" : printAvailability(availability: tutor.availability)])
            
            
            Section(header: Text("Meeting Location")) {
                Button("Edit") {
                    isPresentingNavigator.toggle()
                }
            }
            
            Button(action: {
                self.submit()
            }) {
                Text("Submit").frame(maxWidth: .infinity, alignment: .center)
                
            }
            .disabled(selectedCourse.isEmpty) /*|| selectedLocation == nil)*/
        }
        .navigationTitle("Meet with \(tutor.name)!").navigationBarTitleDisplayMode(.inline).frame(alignment: .center)
        .sheet(isPresented: $isPresentingNavigator){
            
            NavigationStack {
                Navigator()
            }
        }
    }
    
    private func submit() {
        // TODO: submit meeting form
    }
    
    func dateDisplay(for event: EKEvent) -> String {
        DateFormatters.mediumDate(event.startDate)
    }
    
    func timeDisplay(for event: EKEvent) -> String {
        DateFormatters.timeRange(event.startDate, event.endDate)
    }
}

#Preview {
    TutorBookingScreen(tutor: Tutor.previewData[3])
}
