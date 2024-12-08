import WidgetKit
import SwiftUI

// Structure to hold prayer times for each day
struct DayPrayerTimes: Codable, Hashable {
    let date: String
    let fajrAzan: String
    let fajrIqama: String
    let sunrise: String
    let dhuhrAzan: String
    let dhuhrIqama: String
    let asrAzan: String
    let asrIqama: String
    let magribAzan: String
    let magribIqama: String
    let ishaAzan: String
    let ishaIqama: String
}

// Structure to hold widget data
struct WidgetData: Codable, Hashable {
    let prayerTimes: [DayPrayerTimes]
}

// SimpleEntry for the widget timeline
struct SimpleEntry: TimelineEntry {
    let date: Date
    let widgetData: WidgetData?
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), widgetData: loadSamplePrayerTimes())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let sampleData = loadSamplePrayerTimes()
        let entry = SimpleEntry(date: Date(), widgetData: sampleData)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        // Fetch data from UserDefaults with the app group
        let sharedDefaults = UserDefaults(suiteName: "group.tawheedwidget")
        let jsonData = sharedDefaults?.string(forKey: "widgetData")?.data(using: .utf8)
        let widgetData = try? JSONDecoder().decode(WidgetData.self, from: jsonData ?? Data())
        let currentDate = Date()

        let entry = SimpleEntry(date: currentDate, widgetData: widgetData)

        // Determine the next update date
        let nextUpdateDate = determineNextUpdateDate(widgetData: widgetData, currentDate: currentDate)

        let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
        completion(timeline)
    }

    func determineNextUpdateDate(widgetData: WidgetData?, currentDate: Date) -> Date {
        guard let widgetData = widgetData else {
            // If no data, default to update in an hour
            return Calendar.current.date(byAdding: .hour, value: 1, to: currentDate)!
        }

        var prayerTimes: [Date] = []

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd h:mm a"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone.current

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")

        let todayStart = Calendar.current.startOfDay(for: currentDate)

        for dayPrayerTimes in widgetData.prayerTimes {
            guard let dayDate = dateFormatter.date(from: dayPrayerTimes.date) else { continue }
            if dayDate < todayStart { continue } // Skip past days

            let dateString = dayPrayerTimes.date // yyyy-MM-dd

            let azanTimes = [("Fajr Azan", dayPrayerTimes.fajrAzan),
                             ("Sunrise", dayPrayerTimes.sunrise),
                             ("Dhuhr Azan", dayPrayerTimes.dhuhrAzan),
                             ("Asr Azan", dayPrayerTimes.asrAzan),
                             ("Maghrib Azan", dayPrayerTimes.magribAzan),
                             ("Isha Azan", dayPrayerTimes.ishaAzan)]

            for (_, timeString) in azanTimes {
                let dateTimeString = "\(dateString) \(timeString)"
                if let dateTime = formatter.date(from: dateTimeString) {
                    prayerTimes.append(dateTime)
                }
            }
        }

        // Find the next prayer time after the current date
        let nextPrayerTime = prayerTimes.sorted().first(where: { $0 > currentDate })

        return nextPrayerTime ?? Calendar.current.date(byAdding: .hour, value: 1, to: currentDate)!
    }
}

struct tawheed_widget_6EntryView: View {
    var entry: Provider.Entry

    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .systemSmall:
            SmallWidgetView(entry: entry)
        case .systemMedium:
            MediumWidgetView(entry: entry)
        case .systemLarge:
            LargeWidgetView(entry: entry)
        default:
            SmallWidgetView(entry: entry)
        }
    }
}

// MARK: - Small Widget View

struct SmallWidgetView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(formattedDay(currentDate: Date())) // Use Date() instead of entry.date
                .font(.headline)
                .fontWeight(.bold)

            Text(formattedDateDisplay(currentDate: Date())) // Use Date() instead of entry.date
                .font(.subheadline)
                .foregroundColor(.secondary)

            Spacer()

            let nextPrayer = nextPrayerTime(from: entry, currentDate: Date()) // Use Date() instead of entry.date

            if let nextPrayerTime = nextPrayer.time {
                // Combine all into one Text
                (Text("\(nextPrayer.name) in ") + Text(nextPrayerTime, style: .relative))
                    .font(.footnote)
                    .foregroundColor(.orange)
                    .multilineTextAlignment(.leading)
            } else {
                Text("No upcoming prayer")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
        }
        .padding()
    }
}

// MARK: - Medium Widget View

struct MediumWidgetView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            // Header with date, next prayer, and countdown
            HStack(spacing: 5) {
                // Display only the date on a single line
                Text(formattedDateDisplay2(currentDate: Date())) // Use Date() instead of entry.date
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)

                // Separator dot
                Text("•")
                    .font(.footnote)
                    .foregroundColor(.secondary)

                // Next prayer name and countdown
                let nextPrayer = nextPrayerTime(from: entry, currentDate: Date()) // Use Date() instead of entry.date

                if let nextPrayerTime = nextPrayer.time {
                    (Text("\(nextPrayer.name) in ") + Text(nextPrayerTime, style: .relative))
                        .font(.footnote)
                        .foregroundColor(.orange)
                } else {
                    Text("No upcoming prayer")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
            }
            .padding(.bottom, 5)

            // Display prayer times in a compact layout
            if let prayerTimes = getPrayerTimesForToday(entry: entry, currentDate: Date()) { // Use Date() instead of entry.date
                let currentPrayerName = getCurrentPrayer(prayerTimes: prayerTimes, currentDate: Date()) // Use Date() instead of entry.date

                VStack(alignment: .leading, spacing: 1) { // Reduced spacing for compactness
                    CompactPrayerTimeRow(prayerName: "Fajr", azanTime: prayerTimes.fajrAzan, iqamaTime: prayerTimes.fajrIqama, currentPrayerName: currentPrayerName)
                    CompactPrayerTimeRow(prayerName: "Dhuhr", azanTime: prayerTimes.dhuhrAzan, iqamaTime: prayerTimes.dhuhrIqama, currentPrayerName: currentPrayerName)
                    CompactPrayerTimeRow(prayerName: "Asr", azanTime: prayerTimes.asrAzan, iqamaTime: prayerTimes.asrIqama, currentPrayerName: currentPrayerName)
                    CompactPrayerTimeRow(prayerName: "Maghrib", azanTime: prayerTimes.magribAzan, iqamaTime: prayerTimes.magribIqama, currentPrayerName: currentPrayerName)
                    CompactPrayerTimeRow(prayerName: "Isha", azanTime: prayerTimes.ishaAzan, iqamaTime: prayerTimes.ishaIqama, currentPrayerName: currentPrayerName)
                }
            } else {
                Text("No prayer times available for today.")
                    .font(.caption)
            }
        }
        .padding(8) // Adjust padding to better fit content
    }
}

// MARK: - Large Widget View

struct LargeWidgetView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {

            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 0) {
                    Text(formattedDay(currentDate: Date())) // Use Date() instead of entry.date
                        .font(.title2)
                        .fontWeight(.bold)

                    Text(formattedDateDisplay(currentDate: Date())) // Use Date() instead of entry.date
                        .font(.title3)
                        .foregroundColor(.secondary)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 0) {
                    let nextPrayer = nextPrayerTime(from: entry, currentDate: Date()) // Use Date() instead of entry.date

                    if let nextPrayerTime = nextPrayer.time {
                        // Combine all into one Text
                        (Text("\(nextPrayer.name) in ") + Text(nextPrayerTime, style: .relative))
                            .font(.footnote)
                            .foregroundColor(.orange)
                            .multilineTextAlignment(.trailing)
                    } else {
                        Text("No upcoming prayer")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.bottom, 10)

            // Header row with "Prayer", "Adhan", and "Iqama" labels
            HStack {
                Text("Prayer")
                    .font(.headline)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text("Adhan")
                    .font(.headline)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .center)

                Text("Iqama")
                    .font(.headline)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(.bottom, 5)

            if let prayerTimes = getPrayerTimesForToday(entry: entry, currentDate: Date()) { // Use Date() instead of entry.date
                let currentPrayerName = getCurrentPrayer(prayerTimes: prayerTimes, currentDate: Date()) // Use Date() instead of entry.date

                VStack(alignment: .leading, spacing: 8) {
                    PrayerTimeRow(prayerName: "Fajr", azanTime: prayerTimes.fajrAzan, iqamaTime: prayerTimes.fajrIqama, currentPrayerName: currentPrayerName)
                    PrayerTimeRow(prayerName: "Sunrise", azanTime: prayerTimes.sunrise, iqamaTime: "", currentPrayerName: currentPrayerName)
                    PrayerTimeRow(prayerName: "Dhuhr", azanTime: prayerTimes.dhuhrAzan, iqamaTime: prayerTimes.dhuhrIqama, currentPrayerName: currentPrayerName)
                    PrayerTimeRow(prayerName: "Asr", azanTime: prayerTimes.asrAzan, iqamaTime: prayerTimes.asrIqama, currentPrayerName: currentPrayerName)
                    PrayerTimeRow(prayerName: "Maghrib", azanTime: prayerTimes.magribAzan, iqamaTime: prayerTimes.magribIqama, currentPrayerName: currentPrayerName)
                    PrayerTimeRow(prayerName: "Isha", azanTime: prayerTimes.ishaAzan, iqamaTime: prayerTimes.ishaIqama, currentPrayerName: currentPrayerName)
                }
            } else {
                Text("No prayer times available for today.")
                    .font(.subheadline)
            }
        }
        .padding()
    }
}

// MARK: - Helper Views and Functions

// Compact Prayer Time Row for Medium Widget
struct CompactPrayerTimeRow: View {
    let prayerName: String
    let azanTime: String
    let iqamaTime: String
    let currentPrayerName: String?

    var body: some View {
        HStack {
            Text(prayerName)
                .font(.caption)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(azanTime)
                .font(.caption)
                .frame(maxWidth: .infinity, alignment: .center)
            Text(iqamaTime)
                .font(.caption)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(4)
        .background(prayerName == currentPrayerName ? Color.green.opacity(0.3) : Color.clear)
        .cornerRadius(5)
    }
}

// Prayer Time Row for Large Widget
struct PrayerTimeRow: View {
    let prayerName: String
    let azanTime: String
    let iqamaTime: String
    let currentPrayerName: String?

    var body: some View {
        HStack {
            Text(prayerName)
                .font(.body)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(azanTime)
                .font(.body)
                .frame(maxWidth: .infinity, alignment: .center)
            Text(iqamaTime)
                .font(.body)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(4)
        .background(prayerName == currentPrayerName ? Color.green.opacity(0.3) : Color.clear)
        .cornerRadius(5)
    }
}

// Helper functions to get the current prayer name
func getCurrentPrayer(prayerTimes: DayPrayerTimes, currentDate: Date) -> String? {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd h:mm a"
    formatter.timeZone = TimeZone.current
    formatter.locale = Locale(identifier: "en_US_POSIX")

    let dateString = prayerTimes.date

    // List of prayers with their names and azan times
    let prayers = [("Fajr", prayerTimes.fajrAzan),
                   ("Sunrise", prayerTimes.sunrise),
                   ("Dhuhr", prayerTimes.dhuhrAzan),
                   ("Asr", prayerTimes.asrAzan),
                   ("Maghrib", prayerTimes.magribAzan),
                   ("Isha", prayerTimes.ishaAzan)]

    // Build array of prayer times with their dates
    var prayerDateTimes: [(name: String, date: Date)] = []
    for prayer in prayers {
        let dateTimeString = "\(dateString) \(prayer.1)"
        if let dateTime = formatter.date(from: dateTimeString) {
            prayerDateTimes.append((name: prayer.0, date: dateTime))
        }
    }

    // Sort the prayer times
    let sortedPrayers = prayerDateTimes.sorted(by: { $0.date < $1.date })

    // Find the current prayer
    for (index, prayer) in sortedPrayers.enumerated() {
        let nextPrayerDate = index + 1 < sortedPrayers.count ? sortedPrayers[index + 1].date : Calendar.current.startOfDay(for: currentDate).addingTimeInterval(24*60*60)

        if currentDate >= prayer.date && currentDate < nextPrayerDate {
            if prayer.name == "Isha" && currentDate >= nextPrayerDate {
                return nil
            }
            return prayer.name
        }
    }

    return nil
}

// Helper function to get next prayer time
func nextPrayerTime(from entry: Provider.Entry, currentDate: Date) -> (name: String, time: Date?) {
    guard let widgetData = entry.widgetData else {
        return (name: "", time: nil)
    }

    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd h:mm a"
    formatter.timeZone = TimeZone.current
    formatter.locale = Locale(identifier: "en_US_POSIX")

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    dateFormatter.timeZone = TimeZone.current
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")

    let todayStart = Calendar.current.startOfDay(for: currentDate)

    var prayerTimes: [(name: String, date: Date)] = []

    for dayPrayerTimes in widgetData.prayerTimes {
        guard let dayDate = dateFormatter.date(from: dayPrayerTimes.date) else { continue }
        if dayDate < todayStart { continue } // Skip past days

        let dateString = dayPrayerTimes.date

        let prayers = [("Fajr", dayPrayerTimes.fajrAzan),
                       ("Sunrise", dayPrayerTimes.sunrise),
                       ("Dhuhr", dayPrayerTimes.dhuhrAzan),
                       ("Asr", dayPrayerTimes.asrAzan),
                       ("Maghrib", dayPrayerTimes.magribAzan),
                       ("Isha", dayPrayerTimes.ishaAzan)]

        for (name, timeString) in prayers {
            let dateTimeString = "\(dateString) \(timeString)"
            if let dateTime = formatter.date(from: dateTimeString) {
                prayerTimes.append((name: name, date: dateTime))
            }
        }
    }

    // Sort the prayer times
    let sortedPrayers = prayerTimes.sorted(by: { $0.date < $1.date })

    // Find the next prayer
    if let nextPrayer = sortedPrayers.first(where: { $0.date > currentDate }) {
        return (name: nextPrayer.name, time: nextPrayer.date)
    }

    return (name: "", time: nil)
}

// Helper function to get today's prayer times
func getPrayerTimesForToday(entry: Provider.Entry, currentDate: Date) -> DayPrayerTimes? {
    guard let widgetData = entry.widgetData else {
        return nil
    }

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    dateFormatter.timeZone = TimeZone.current
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")

    let currentDateString = dateFormatter.string(from: currentDate)

    return widgetData.prayerTimes.first(where: { $0.date == currentDateString })
}

// Date formatting functions
func formattedDay(currentDate: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "EEEE"
    formatter.timeZone = TimeZone.current
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter.string(from: currentDate)
}

func formattedDateDisplay(currentDate: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM d"
    formatter.timeZone = TimeZone.current
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter.string(from: currentDate)
}

func formattedDateDisplay2(currentDate: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMM d"
    formatter.timeZone = TimeZone.current
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter.string(from: currentDate)
}

// Helper function to load sample data
func loadSamplePrayerTimes() -> WidgetData {
    let sampleDays = [
        DayPrayerTimes(
            date: "2024-11-24",
            fajrAzan: "06:12 am",
            fajrIqama: "06:45 am",
            sunrise: "07:32 am",
            dhuhrAzan: "12:20 pm",
            dhuhrIqama: "01:00 pm",
            asrAzan: "02:46 pm",
            asrIqama: "04:00 pm",
            magribAzan: "05:07 pm",
            magribIqama: "05:12 pm",
            ishaAzan: "06:29 pm",
            ishaIqama: "08:00 pm"
        ),
        DayPrayerTimes(
            date: "2024-11-25",
            fajrAzan: "06:13 am",
            fajrIqama: "06:50 am",
            sunrise: "07:34 am",
            dhuhrAzan: "12:20 pm",
            dhuhrIqama: "01:00 pm",
            asrAzan: "02:46 pm",
            asrIqama: "04:00 pm",
            magribAzan: "05:06 pm",
            magribIqama: "05:11 pm",
            ishaAzan: "06:28 pm",
            ishaIqama: "08:00 pm"
        ),
        // Add more days as needed
    ]
    return WidgetData(prayerTimes: sampleDays)
}

struct tawheed_widget_6: Widget {
    let kind: String = "tawheed_widget_6"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            tawheed_widget_6EntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
        .configurationDisplayName("Tawheed Prayer Times")
        .description("Displays daily prayer times.")
    }
}

