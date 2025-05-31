//
//  AllexWidget.swift
//  AllexWidget
//
//  Created by youngkyun park on 4/23/25.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    // 위젯 최초 렌더링시 보여주는 화면
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), userName : "Allex", latestGrade: "V9", successRate: "77", totalExTime: "09:41")
    }

    // 위젯 갤러리 미리보기 화면
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), userName : "Allex", latestGrade: "V9", successRate: "77", totalExTime: "09:41")
        completion(entry)
    }
    // 위젯 상태 변경 시점
    // 미리 위젯 뷰를 그리고 있다가 시간에 맞춰 뷰를 업데이트하고, TimeLineEnry를 통해 특정 시간에 위젯을 업데이트 할 수 있도록 도와줌
    // 위젯 뷰의 새로운 렌더링으로 업데이트 할 시기를 위젯킷에게 알려줌
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        
        let userName = UserDefaultManager.nickname
        let latestGrade = UserDefaultManager.latestGrade
        
        let successRate = UserDefaultManager.successRate
        let totalMonthTime = UserDefaultManager.totalExTime
         

        let entry =  SimpleEntry(date: currentDate, userName: userName, latestGrade: latestGrade, successRate: successRate, totalExTime: totalMonthTime)
        entries.append(entry)
        
        

        // 타임라인 정책
        let nextUpdateDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        
        // .after의 기준은 리로드 시점 기준
        let timeline = Timeline(entries: entries, policy: .after(nextUpdateDate))
        completion(timeline)
    }

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

//실제 위젯 구성시 필요한 데이터
struct SimpleEntry: TimelineEntry {
    var date: Date
    let userName: String
    let latestGrade: String // 최신 기준
    let successRate: String // 최신 기준
    let totalExTime: String // 최신 기준
}

// 실제 위젯 화면
struct AllexWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            
            VStack(spacing: 12) {
                Text("🧗‍♀️ Hi, " + entry.userName)
                    .font(.system(size: 10))
                    .bold()
                    .foregroundColor(.primary)

                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
                    .frame(width: 130, height: 80)
                    .overlay(
                        VStack(alignment: .center, spacing: 4) {
                            Text(LocalizedKey.Widget_BestRecord.rawValue.localized(with: "") + entry.latestGrade)
                                .asSmallWidgetText()
                                
                            
                            Text(LocalizedKey.Widget_SuccessRate.rawValue.localized(with: "") + entry.successRate)
                                .asSmallWidgetText()
                                
                            
                            Text(LocalizedKey.Widget_ExTime.rawValue.localized(with: "") + entry.totalExTime)
                                .asSmallWidgetText()
                        }
                    
                    )
                    .shadow(color: .black.opacity(0.2), radius: 8, x: 4, y: 4)
            }
            .padding()
        }
        
    }
}

// Widget 프로토콜을 채택하는 것은, 최종적으로 구성되는 WidgetCongifuration
struct AllexWidget: Widget {
    let kind: String = "AllexWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                AllexWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                AllexWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Allex")
        .description("The latest Climbing record")
        .supportedFamilies([.systemSmall])
    }
}

#Preview(as: .systemSmall) {
    AllexWidget()
} timeline: {
    SimpleEntry(date: Date(), userName : "Allex", latestGrade: "V9", successRate: "77", totalExTime: "09:41")
}
