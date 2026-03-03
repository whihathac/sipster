import SwiftUI
import Charts

public struct WeeklyChartView: View {
    public let records: [DayRecord]
    public let goal: Int
    public let weekDates: [Date]
    public let caffeineLimitMG: Int

    public init(records: [DayRecord], goal: Int, weekDates: [Date], caffeineLimitMG: Int = 400) {
        self.records = records
        self.goal = goal
        self.weekDates = weekDates
        self.caffeineLimitMG = caffeineLimitMG
    }

    private var chartData: [ChartDataPoint] {
        weekDates.map { date in
            let startOfDay = Calendar.current.startOfDay(for: date)
            let record = records.first { Calendar.current.isDate($0.date, inSameDayAs: startOfDay) }
            return ChartDataPoint(
                date: startOfDay,
                glasses: record?.glassCount ?? 0,
                caffeineMG: record?.totalCaffeineMG ?? 0,
                metGoal: (record?.glassCount ?? 0) >= Double(goal)
            )
        }
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Weekly Overview")
                .font(.headline)

            HStack(alignment: .top, spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Label("Water", systemImage: "drop.fill")
                        .font(.caption)
                        .foregroundStyle(.blue)
                    waterChart
                }

                VStack(alignment: .leading, spacing: 4) {
                    Label("Caffeine", systemImage: "cup.and.saucer.fill")
                        .font(.caption)
                        .foregroundStyle(.brown)
                    caffeineChart
                }
            }
        }
    }

    private var waterChart: some View {
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
        .frame(maxWidth: .infinity)
        .frame(height: 130)
    }

    private var caffeineChart: some View {
        Chart {
            ForEach(chartData, id: \.date) { point in
                BarMark(
                    x: .value("Day", point.date, unit: .day),
                    y: .value("mg", point.caffeineMG)
                )
                .foregroundStyle(point.caffeineMG > caffeineLimitMG ? Color.red.opacity(0.7) : Color.brown.opacity(0.7))
                .cornerRadius(4)
            }

            RuleMark(y: .value("Limit", caffeineLimitMG))
                .lineStyle(StrokeStyle(lineWidth: 1, dash: [5, 5]))
                .foregroundStyle(.red.opacity(0.5))
                .annotation(position: .trailing, alignment: .leading) {
                    Text("Limit")
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
        .frame(maxWidth: .infinity)
        .frame(height: 130)
    }
}

private struct ChartDataPoint {
    let date: Date
    let glasses: Double
    let caffeineMG: Int
    let metGoal: Bool
}
