import Foundation

struct DateFormatters {
  static func shortDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    return formatter.string(from: date)
  }
  static func shortDateAndTime(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter.string(from: date)
  }
  static func mediumDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter.string(from: date)
  }
  static func dateRange(_ startsAt: Date, _ endsAt: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    return "\(formatter.string(from: startsAt)) - \(formatter.string(from: endsAt))"
  }

  static func timeRange(_ startsAt: Date, _ endsAt: Date) -> String {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    return "\(formatter.string(from: startsAt)) - \(formatter.string(from: endsAt))"
  }
}
