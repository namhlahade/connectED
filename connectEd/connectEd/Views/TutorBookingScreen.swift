import SwiftUI
import MapKit
import MessageUI
import EventKit
import CoreLocation

struct TutorBookingScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @Bindable var tutor: Tutor
    @State private var sessionDuration = 1
    @State var selectedCourse: String = ""
    @State private var price = 0.0
    @State private var selectedLocation: CLLocationCoordinate2D?
    @State var searchResults: [MKMapItem] = []
    @State private var visibleRegion: MKCoordinateRegion = .duke
    @State private var selectedOptionIndex = 0
    @State private var isPresentingNavigator: Bool = false
    @State private var selectedMeetingTime: String = ""
    
    @State var eventService = EventService()
    
    var body: some View {
        Form {
            Section(header: Text("Select a Course:")) {
                if tutor.courses.isEmpty {
                    Text("No available courses to select")
                }
                else {
                    Picker(selection: $selectedCourse, label: Text("")) {
                        ForEach(tutor.courses) { course in
                            Text("\(course.subject.rawValue.uppercased()) \(course.code)").frame(maxWidth: .infinity, alignment: .center).tag("\(course.subject.rawValue.uppercased()) \(course.code)")
                            
                        }
                    }.labelsHidden()
                }
            }
            
            Section(header: Text("Pick a Time")) {
                if tutor.availability.isEmpty {
                    Text("No availability provided")
                }
                else {
                    Picker(selection: $selectedMeetingTime, label: Text("")) {
                        ForEach(tutor.availability) { time in
                            Text(printAvailability(availability: [time])).tag(printAvailability(availability: [time]))
                        }
                    }
                    .pickerStyle(.menu)
                    .labelsHidden()
                }
            }
            
            
            Section(header: Text("Meeting Location")) {
                Button("Edit") {
                    isPresentingNavigator.toggle()
                }
            }
            
            NavigationLink(destination: EventEditView(eventService: eventService, event: nil)) {
                Text("Add Meeting To Your Calendar!").frame(maxWidth: .infinity, alignment: .center)
            }
            .disabled(selectedCourse == "" || selectedMeetingTime == "")
        }
        .navigationTitle("Meet with \(tutor.name)!")
        .navigationBarTitleDisplayMode(.inline).frame(alignment: .center)

        .sheet(isPresented: $isPresentingNavigator){
            
            NavigationStack {
                Navigator()
            }
        }
    }
    func dateDisplay(for event: EKEvent) -> String {
        DateFormatters.mediumDate(event.startDate)
    }
    
    func timeDisplay(for event: EKEvent) -> String {
        DateFormatters.timeRange(event.startDate, event.endDate)
    }
}

#Preview {
    TutorBookingScreen(tutor: Tutor.previewData[4])
}
