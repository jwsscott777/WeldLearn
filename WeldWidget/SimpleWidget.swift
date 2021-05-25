//
//  SimpleWidget.swift
//  WeldWidgetExtension
//
//  Created by JWSScott777 on 5/25/21.
//

import SwiftUI
import WidgetKit

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

struct SimpleWeldWidget: Widget {
    let kind: String = "SimpleWeldWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WeldWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Up Next")
        .description("The main priority item.")
        .supportedFamilies([.systemSmall])
    }
}

struct WeldWidget_Previews: PreviewProvider {
    static var previews: some View {
        WeldWidgetEntryView(entry: SimpleEntry(date: Date(), items: [Item.example]))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
