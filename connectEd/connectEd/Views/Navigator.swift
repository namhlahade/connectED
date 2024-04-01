import SwiftUI
import MapKit
import CoreLocation

extension CLLocationCoordinate2D {
  static let grossHall = CLLocationCoordinate2D(latitude: 36.001312, longitude: -78.944745)
  static let lsrc = CLLocationCoordinate2D(latitude: 36.004556, longitude: -78.941755)
}

extension MKCoordinateRegion {
  static let duke = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 36.002250, longitude: -78.938638), span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
  static let sanJuan = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 18.388814, longitude: -66.062151), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
}

struct Location: Identifiable {
  let id: UUID = UUID()
  var name: String
  var coordinate: CLLocationCoordinate2D

  static let dukeCampus = [Location(name: "LSRC", coordinate: .lsrc), Location(name: "Gross Hall", coordinate: .grossHall)]
}

struct Navigator: View {
  let illRepute = CLLocationCoordinate2D(latitude: 36.001167, longitude: -78.909326)
  let locationManager = CLLocationManager()
  @State var position: MapCameraPosition = .userLocation(fallback: .automatic)
  @State var searchResults: [MKMapItem] = []
  @State private var visibleRegion: MKCoordinateRegion = .duke
  @State private var selectedMapItem: MKMapItem?
  @State private var route: MKRoute?

  var body: some View {
    Map(position: $position, selection: $selectedMapItem) {
      ForEach(searchResults, id: \.self) { mapItem in
        Marker(item: mapItem)
      }
      UserAnnotation()
      if let route {
        MapPolyline(route)
          .stroke(.blue, lineWidth: 5)
      }
      Marker("", systemImage: "flame", coordinate: illRepute)
                .tint(.orange)
      Annotation(coordinate: illRepute) {
        Image(systemName: "flame.fill")
          .font(.largeTitle)
         .foregroundStyle(.white)
          .background (Color.blue)
          .cornerRadius(4)
      } label: { Text("Shooters") }
    }
    .mapStyle(.hybrid)
    .onMapCameraChange { context in
      visibleRegion = context.region
    }
    .mapControls {
      MapUserLocationButton()
    }
    .safeAreaInset(edge: .top) {
      HStack {
        Spacer()
        SearchQuery(searchResults: $searchResults, region: visibleRegion)
        Spacer()
      }
      .background(.ultraThickMaterial)
    }
    .safeAreaInset(edge: .bottom) {
      VStack {
        if let selectedMapItem {
          Text(selectedMapItem.name ?? "No name")
          Button("Directions") { getDirections() }
        }
        HStack {
          Spacer()
          RegionButtons(position: $position)
            .padding(.top)
          Spacer()
        }
      }
      .background(.ultraThinMaterial)
    }
    .onAppear {
      locationManager.requestWhenInUseAuthorization()
    }

  }

  func getDirections() {
    route = nil
    guard let selectedMapItem else { return }
    let request = MKDirections.Request()
    request.source = MKMapItem(placemark: MKPlacemark(coordinate: .grossHall))
    request.destination = selectedMapItem

    Task {
      let directions = MKDirections(request: request)
      let response = try? await directions.calculate()
      route = response?.routes.first
    }
  }

}

struct SearchQuery: View {
  @Binding var searchResults: [MKMapItem]
  let region: MKCoordinateRegion
  @State var query: String = ""

  func search() {
    let request = MKLocalSearch.Request()
    request.naturalLanguageQuery = query
    request.resultTypes = .pointOfInterest
    request.region = region

    Task {
      let search = MKLocalSearch(request: request)
      let response = try? await search.start()
      searchResults = response?.mapItems ?? []
    }
  }

  var body: some View {
    TextField("Search", text: $query)
      .padding()
      .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color.gray, style: StrokeStyle(lineWidth: 1.0)))
      .padding()
      .onSubmit {
        search()
      }
  }
}

struct RegionButtons: View {
  @Binding var position: MapCameraPosition

  var body: some View {
    HStack {
      Button {
        position = .region(.duke)
      } label: {
        Label("Broke", systemImage: "book.and.wrench")
          .labelStyle(.titleAndIcon)
      }
      .buttonStyle(.bordered)
      Button {
        position = .region(.sanJuan)
      } label: {
        Label("Break", systemImage: "beach.umbrella")
          .labelStyle(.titleAndIcon)
      }
      .buttonStyle(.borderedProminent)
    }
    .labelStyle(.iconOnly)
  }
}


#Preview {
  Navigator()
}
