//
//  MealWidget.swift
//  MealWidget
//
//  Created by Inpyo Hong on 2021/08/05.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    let samplePlan = WidgetPlan(day: "2021-01-01",
                                book: "창",
                                fChap: 1,
                                fVer: 1,
                                lChap: 1,
                                lVer: 3,
                                verses: ["태초에 하나님이 천지를 창조하시니라","그 땅이 혼돈하고 공허하며 흑암이 깊음 위에 있고 하나님의 영은 수면 위에 운행하시니라","하나님이 이르시되 빛이 있으라 하시니 빛이 있었고 ", "그 빛이 하나님이 보시기에 좋았더라 하나님이 빛과 어둠을 나누사","하나님이 빛을 낮이라 부르시고 어둠을 밤이라 부르시니라 저녁이 되고 아침이 되니 이는 첫째 날이니라"])
    
    func readWidgtPlan() -> [WidgetPlan] {
        var widgetPlan: [WidgetPlan] = []
        let archiveURL = FileManager.sharedContainerURL()
            .appendingPathComponent("widgetPlan.json")
        print(">>> \(archiveURL)")
        
        if let codeData = try? Data(contentsOf: archiveURL) {
            do {
                widgetPlan = try JSONDecoder().decode(
                    [WidgetPlan].self,
                    from: codeData)
            } catch {
                print("Error: Can't decode contents")
            }
        }
        return widgetPlan
    }
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), plan: samplePlan)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), plan: samplePlan)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        let currentDate = Date()
        let plans = readWidgtPlan()
        
        for index in 0 ..< plans.count {
            let entryDate = Calendar.current.date(
                byAdding: .day,
                value: index,
                to: currentDate)!
            
            let entry = SimpleEntry(
                date: entryDate,
                plan: plans[index])
            
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let plan: WidgetPlan
}

struct MealWidgetEntryView : View {
    @Environment(\.widgetFamily) var family
    var entry: Provider.Entry
    let planStore = PlanStore()
    
    var body: some View {
        ZStack {
            Color(UIColor.systemBackground).edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading, spacing: -10) {
                HStack(alignment: .center, spacing: -14) {
                    Image(uiImage: UIImage(named: "riceBowlIcon")!)
                        .renderingMode(.template)
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color(UIColor.label))
                        .padding([.leading, .trailing], 20)
                        .unredacted()
                    
                    VStack(alignment: .leading, spacing: -4) {
                        if family == .systemSmall {
                            Text("끼니")
                                .font(.custom("NanumBrushOTF", size: 30))
                                .foregroundColor(Color(UIColor.label))
                                .font(.footnote)
                        }
                        else{
                            HStack{
                                Text("끼니")
                                    .font(.custom("NanumBrushOTF", size: 30))
                                    .foregroundColor(Color(UIColor.label))
                                    .bold()
                                
                                Text("\(planStore.convertDateToStr(date: planStore.dateFormatter.date(from: entry.plan.day)!))")
                                    .font(.footnote)
                                    .foregroundColor(Color(.gray))
                                    .bold()
                            }
                        }
                        
                        Text("\(planStore.getBookTitle(book: entry.plan.book) ?? entry.plan.book) \(entry.plan.fChap):\(entry.plan.fVer)-\(entry.plan.fChap != entry.plan.lChap ? "\(entry.plan.lChap):" : "" )\(entry.plan.lVer)")
                            .foregroundColor(Color(UIColor.label))
                            .font(.custom("NanumMyeongjoOTFBold", size: 16))
                            .bold()
                    }
                    .padding(.horizontal)
                    .foregroundColor(Color(UIColor.systemGray))
                }
                
                if family != .systemSmall {
                    Text(entry.plan.verses[0...2].joined(separator: " "))
                        .font(.custom("NanumMyeongjoOTF", size: 16))
                        .lineLimit(3)
                        //.font(.footnote)
                        .foregroundColor(Color(UIColor.label))
                        .padding([.top,.bottom], 20)
                        .padding([.leading,.trailing], 10)
                }
            }
            .padding(10)
            .background(Color.clear)
        }
    }
}

@main
struct MealWidget: Widget {
    let kind: String = "MealWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            MealWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("끼니")
        .description("오늘 날짜의 끼니 말씀을 확인할 수 있어요.")
        .supportedFamilies([.systemMedium])
    }
}

struct MealWidget_Previews: PreviewProvider {
    static var previews: some View {
        let view = MealWidgetEntryView(
            entry: SimpleEntry(date: Date(),
                               plan: Provider().samplePlan))
        // .colorScheme(.dark)
        view.previewContext(WidgetPreviewContext(family: .systemSmall))
        view.previewContext(WidgetPreviewContext(family: .systemMedium))
        view.previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}