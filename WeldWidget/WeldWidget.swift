//
//  WeldWidget.swift
//  WeldWidget
//
//  Created by JWSScott777 on 5/11/21.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), items: [Item.example])
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), items: loadItems())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let entry = SimpleEntry(date: Date(), items: loadItems())
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
    func loadItems() -> [Item] {
        let dataController = DataController()
        let itemRequest = dataController.fetchRequestForTopItems(count: 1)
        return dataController.results(for: itemRequest)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let items: [Item]
}

struct WeldWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Up Next...")
                .font(.title)

            if let item = entry.items.first {
                Text(item.itemTitle)
            } else {
                Text("Nothing")
            }
        }
    }
}

@main
struct WeldWidget: Widget {
    let kind: String = "WeldWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WeldWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct WeldWidget_Previews: PreviewProvider {
    static var previews: some View {
        WeldWidgetEntryView(entry: SimpleEntry(date: Date(), items: [Item.example]))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
