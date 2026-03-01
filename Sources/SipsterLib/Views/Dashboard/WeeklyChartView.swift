import SwiftUI
import Charts

public struct WeeklyChartView: View {
    public let records: [DayRecord]
    public let goal: Int
    public let weekDates: [Date]

    public init(records: [DayRecord], goal: Int, weekDates: [Date]) {
        self.records = records
        self.goal = goal
        self.weekDates = weekDates
    }

    private var chartData: [ChartDataPoint] {
        weekDates.map { date in
            let startOfDay = Calendar.current.startOfDay(for: date)
            let record = records.first { Calendar.current.isDate($0.date, inSameDayAs: startOfDay) }
            return ChartDataPoint(
                date: startOfDay,
                glasses: record?.glassCount ?? 0,
                metGoal: (record?.glassCount ?? 0) >= Double(goal)
            )
        }
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Weekly Overview")
                .font(.headline)

            Chart {
                ForEach(chartData, id: \.date) { point in
                    BarMark(
                        x: .value("Day", point.date, unit: .day),
                        y: .value("Glasses", point.glasses)
                    )
                    .foregroundStyle(point.metGoal ? Color.blue : Color.blue.opacity(0.4))
                    .cornerRadius(4)
                }

                RuleMark(y: .value("Goal", goal))
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [5, 5]))
                    .foregroundStyle(.red.opacity(0.5))
                    .annotation(position: .trailing, alignment: .leading) {
                        Text("Goal")
                            .font(.caption2)
                            .foregroundStyle(.red.opacity(0.5))
                    }
            }
            .chartYAxis {
                AxisMarks(position: .leading)
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .day)) { _ in
                    AxisValueLabel(format: .dateTime.weekday(.abbreviated))
                }
            }
            .frame(height: 160)
        }
    }
}

private struct ChartDataPoint {
    let date: Date
    let glasses: Double
    let metGoal: Bool
}
