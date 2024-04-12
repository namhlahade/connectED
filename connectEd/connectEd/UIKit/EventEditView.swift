import SwiftUI
import EventKitUI

struct EventEditView: UIViewControllerRepresentable {
  func makeCoordinator() -> Coordinator {
    return Coordinator(self)
  }

  @Environment(\.presentationMode) var presentationMode
  let eventService: EventService
  let event: EKEvent?

  class Coordinator: NSObject, EKEventEditViewDelegate {
    let parent: EventEditView
    
    init(_ parent: EventEditView) {
      self.parent = parent
    }

    @MainActor
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
      parent.presentationMode.wrappedValue.dismiss()
      parent.eventService.reloadEvents()
    }
  }

  func makeUIViewController(context: UIViewControllerRepresentableContext<EventEditView>) -> EKEventEditViewController {

    let eventEditViewController = EKEventEditViewController()
    eventEditViewController.eventStore = eventService.eventStore

    if let event = event {
      eventEditViewController.event = event // when set to nil the controller would not display anything
    }
    eventEditViewController.editViewDelegate = context.coordinator

    return eventEditViewController
  }

  func updateUIViewController(_ uiViewController: EKEventEditViewController, context: UIViewControllerRepresentableContext<EventEditView>) {

  }

}
