import EventKit
import SwiftUI

@Observable
class EventService {
  let eventStore = EKEventStore()
  var timeInterval: TimeInterval = (24 * 60 * 60 * 7)

  var eventStoreAccessDenied: Bool = false
  var events: [EKEvent] = []
  var currentCalendar: EKCalendar?
  var calendars: Set<EKCalendar>?

  func confirmCalendarAuthorization(onGranted: @escaping () -> ()) {
    eventStore.requestFullAccessToEvents { (granted, error) in
      if granted {
        onGranted()
      } else {
        self.eventStoreAccessDenied = true
      }
    }
  }
  
  @MainActor
  func loadEvents(timeInterval: TimeInterval) {
    confirmCalendarAuthorization {
      self.timeInterval = timeInterval
      let weekFromNow = Date().advanced(by: timeInterval)
      if let activeCalendar = self.currentCalendar ?? self.eventStore.defaultCalendarForNewEvents {
        let predicate = self.eventStore.predicateForEvents(withStart: Date(), end: weekFromNow, calendars: [activeCalendar])
        self.events = self.eventStore.events(matching: predicate)
      }
    }
  }

  @MainActor
  func reloadEvents() {
    loadEvents(timeInterval: timeInterval)
  }

}
