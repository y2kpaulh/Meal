//
//  MealWidget.swift
//  MealWidget
//
//  Created by Inpyo Hong on 2021/08/05.
//

import WidgetKit
import SwiftUI
import Combine

struct Provider: TimelineProvider {
  var planNotiService = PlanNotiService()

  let samplePlan = NotiPlan(day: "2021-01-01",
                            book: "창",
                            fChap: 1,
                            fVer: 1,
                            lChap: 1,
                            lVer: 5,
                            verses: ["태초에 하나님이 천지를 창조하시니라", "그 땅이 혼돈하고 공허하며 흑암이 깊음 위에 있고 하나님의 영은 수면 위에 운행하시니라", "하나님이 이르시되 빛이 있으라 하시니 빛이 있었고 ", "그 빛이 하나님이 보시기에 좋았더라 하나님이 빛과 어둠을 나누사", "하나님이 빛을 낮이라 부르시고 어둠을 밤이라 부르시니라 저녁이 되고 아침이 되니 이는 첫째 날이니라"])

  func readWidgtPlan() -> [NotiPlan] {
    var widgetPlan: [NotiPlan] = []
    let archiveURL = FileManager.sharedContainerURL()
      .appendingPathComponent("widgetPlan.json")
    print(">>> \(archiveURL)")

    if let codeData = try? Data(contentsOf: archiveURL) {
      do {
        widgetPlan = try JSONDecoder().decode(
          [NotiPlan].self,
          from: codeData)
      } catch {
        print("Error: Can't decode contents")
      }
    }
    return widgetPlan
  }

  func placeholder(in context: Context) -> PlanEntry {
    PlanEntry(date: Date(), plan: samplePlan)
  }

  func getSnapshot(in context: Context, completion: @escaping (PlanEntry) -> Void) {
    let entry = PlanEntry(date: Date(), plan: samplePlan)
    completion(entry)
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
    var entries: [PlanEntry] = []

    planNotiService.fetchPlanList {
      let plan = $0.filter { $0.day == PlanStore().getDateStr(date: Date()) }[0]
      let planData = PlanStore().getPlanData(plan)
      let nextPlan = NotiPlan(day: plan.day,
                              book: plan.book,
                              fChap: plan.fChap,
                              fVer: plan.fVer,
                              lChap: plan.lChap,
                              lVer: plan.lVer,
                              verses: planData.verses)

      let nextUpdate = Calendar
        .autoupdatingCurrent
        .date(
          byAdding: .day,
          value: 1,
          to: Calendar.autoupdatingCurrent.startOfDay(for: Date()))!

      let entry = PlanEntry(
        date: nextUpdate,
        plan: nextPlan)

      entries = [entry]

      let timeline = Timeline(entries: entries, policy: .atEnd)
      completion(timeline)
    }
  }
}

struct PlanEntry: TimelineEntry {
  let date: Date
  let plan: NotiPlan
}

struct MealWidgetEntryView: View {
  @Environment(\.widgetFamily) var family
  var entry: Provider.Entry

  var body: some View {
    ZStack {
      VStack(alignment: .leading, spacing: -4) {
        HStack(alignment: .center, spacing: -4) {

          if family != .systemSmall {
            MealIconView()
          }

          VStack(alignment: .leading, spacing: -4) {
            if family == .systemSmall {
              VStack(alignment: .center, spacing: 10) {
                VStack(spacing: 10) {
                  MealIconView()
                  WidgetDateView(entry: entry, plan: entry.plan)
                }
                NotiPlanLabelView(entry: entry, plan: entry.plan)
              }
            } else {
              HStack {
                MealTitleLabel(size: 34, textColor: Color(UIColor.label))
                WidgetDateView(entry: entry, plan: entry.plan)
              }

              NotiPlanLabelView(entry: entry, plan: entry.plan)
                .padding(.top, -4)
            }
          }
          .foregroundColor(Color(UIColor.systemGray))
        }

        if family != .systemSmall {
          Text(PlanStore().getBibleSummary(verses: entry.plan.verses))
            .font(.custom("NanumMyeongjoOTF", size: 15))
            .lineLimit(2)
            .lineSpacing(6.0)
            .font(.footnote)
            .foregroundColor(Color(UIColor.label))
            .padding(.top, 10)
            .padding(.bottom, 2)
        }
      }
      .widgetURL(AppSettings.widgetDeepLinkURL)
      .padding(10)
    }
    .widgetBackground(backgroundView: Color(UIColor.systemBackground))
  }
}

struct WidgetDateView: View {
  var entry: Provider.Entry
  var plan: NotiPlan

  var body: some View {
    Text("\(PlanStore().convertDateToStr(date: PlanStore().dateFormatter.date(from: plan.day)!))")
      .font(.footnote)
      .foregroundColor(Color(.gray))
      .bold()
  }
}

struct NotiPlanLabelView: View {
  var entry: Provider.Entry
  var plan: NotiPlan

  var body: some View {
    Text(PlanStore().getMealPlanStr(plan))
      .foregroundColor(Color(UIColor.label))
      .font(.custom("NanumMyeongjoOTFBold", size: 14))
      .bold()
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
    .supportedFamilies([.systemSmall, .systemMedium])
    .onBackgroundURLSessionEvents { identifier, completion in
      print("onBackgroundURLSessionEvents", identifier, completion)
    }
    //.contentMarginsDisabled()
    // Disable container background removal
    //.containerBackgroundRemovable(false)
  }
}

struct MealWidget_Previews: PreviewProvider {
  static var previews: some View {
    let view = MealWidgetEntryView(
      entry: PlanEntry(date: Date(),
                       plan: Provider().samplePlan))
    // .colorScheme(.dark)
    view.previewContext(WidgetPreviewContext(family: .systemSmall))
    view.previewContext(WidgetPreviewContext(family: .systemMedium))
  }
}
