import SwiftUI
import EventKit

struct CalendarView: View {
  @Environment(\.openURL) var openURL
  let eventService = EventService()
  @State var isPresentingAddEvent: Bool = false
  @State var isPresentingCalendarChooser: Bool = false
  let twoWeekTimeInterval: Double = Double(14 * 24 * 60 * 60)
  
  var body: some View {
    VStack {
      if eventService.eventStoreAccessDenied {
        Button("Go to Settings") {
          openSettings()
        }
      } else {
        List(eventService.events, id: \.self) { event in
          HStack(alignment: .top) {
            Text(event.title)
            Spacer()
            VStack(alignment: .leading) {
              Text(dateDisplay(for: event))
              Text(timeDisplay(for: event))
                .font(.caption)
            }
            .frame(minWidth: 120, alignment: .leading)
          }
        }
        .sheet(isPresented: $isPresentingAddEvent) {
          EventEditView(eventService: eventService, event: nil)
        }
        .sheet(isPresented: $isPresentingCalendarChooser) {
          CalendarChooser(eventService: eventService)
        }
      }
    }
    .toolbar {
      ToolbarItem(placement: .primaryAction) {
        Button("Add") { presentAddEvent() }
      }
    }
    .toolbar {
      ToolbarItem(placement: .secondaryAction) {
        Button("Change") { presentChangeCalendar() }
      }
    }
    .task { eventService.loadEvents(timeInterval: twoWeekTimeInterval) }
  }

  func dateDisplay(for event: EKEvent) -> String {
    DateFormatters.mediumDate(event.startDate)
  }

  func timeDisplay(for event: EKEvent) -> String {
    DateFormatters.timeRange(event.startDate, event.endDate)
  }

  func presentAddEvent() {
    self.isPresentingAddEvent = true
  }

  func presentChangeCalendar() {
    self.isPresentingCalendarChooser = true
  }

  private func openSettings() {
      openURL(URL(string: UIApplication.openSettingsURLString)!)
  }
}
struct Calendar_Previews: PreviewProvider {
  static var previews: some View {
    CalendarView()
  }
}

