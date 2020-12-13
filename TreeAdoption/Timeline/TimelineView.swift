import SDWebImageSwiftUI
import SwiftUI

struct TimelineView: View {
    @ObservedObject var viewModel: TimelineViewModel
    @Binding var isPresented: Bool

    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundGray
                    .ignoresSafeArea()
                switch viewModel.state {
                    case .loading:
                        DefaultLoadingView()
                    case let .loaded(result):
                        TimelineScrollView(items: result)
                    case .error:
                        DefaultErrorView(
                            titleKey: "timeline_view_network_error_title",
                            messageKey: "timeline_view_network_error_description"
                        )
                }
            }
            .navigationBarTitle("timeline_view_title", displayMode: .inline)
            .navigationBarItems(
                trailing: Button(
                    action: { isPresented = false }
                ) {
                    Text("timeline_view_done_button_title")
                        .foregroundColor(.primaryColor)
                }
            )
            .onAppear(perform: viewModel.onAppear)
        }
    }
}

struct TimelineScrollView: View {
    let items: [TimelineItemType]

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(items.indices) { index in
                    let item = items[index]
                    switch item {
                        case let .label(label):
                            TimelineLabelView(label: label)
                        case let .image(item):
                            TimelineImageView(item: item)
                        case let .health(item):
                            TimelineHealthView(item: item)
                    }
                }
            }
            .padding(.top, 24)
            .padding(.bottom, 24)
        }
    }
}

struct TimelineLabelView: View {
    let label: String

    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(Color.white)
                .frame(width: 90, height: 50)
                .background(
                    Rectangle()
                        .fill(Color.primaryColor)
                        .cornerRadius(25, corners: [.topRight, .bottomRight])
                )
            Spacer()
        }
    }
}

struct TimelineImageView: View {
    let item: TimelineImageItem

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            DateView(date: item.date)
            WebImage(
                url: URL(
                    string: item.imageUrl
                )
            )
            .resizable()
            .placeholder {
                Rectangle().foregroundColor(.primaryGray)
            }
            .scaledToFill()
            .frame(maxWidth: 96, maxHeight: .infinity)
            .clipped()
            .cornerRadius(20)
            .transition(.fade(duration: 0.5))
            VStack {
                Text(item.title)
                    .font(.system(size: 16, weight: .heavy))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(item.description)
                    .font(.system(size: 12, weight: .semibold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
            Spacer()
        }
        .padding(16)
        .background(CardBackground())
        .padding(.leading, 24)
        .padding(.trailing, 24)
        .padding(.top, 8)
        .padding(.bottom, 8)
    }
}

struct TimelineHealthView: View {
    let item: TimelineHealthItem

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            DateView(date: item.date)
            SeverityProgressView(fraction: item.severityFraction)
                .frame(width: 96, height: 96)
            VStack {
                Text(item.title)
                    .font(.system(size: 16, weight: .heavy))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(item.description)
                    .font(.system(size: 12, weight: .semibold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
            }
            Spacer()
        }
        .padding(16)
        .background(CardBackground())
        .padding(.leading, 24)
        .padding(.trailing, 24)
        .padding(.top, 8)
        .padding(.bottom, 8)
    }
}

struct SeverityProgressView: View {
    let fraction: Double

    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 10)
                .foregroundColor(.backgroundGray)
            Circle()
                .trim(from: 0, to: CGFloat(min(fraction, 1)))
                .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                .foregroundColor(SeverityColorProvider.severityColor(fraction))
                .rotationEffect(Angle(degrees: 270))
                .animation(.linear)
        }
    }
}

struct DateView: View {
    let date: Date

    var body: some View {
        VStack {
            Text(formattedDay())
                .font(.system(size: 16, weight: .heavy))
                .foregroundColor(Color.textPrimary)
            Text(formattedWeekDay())
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Color.primaryGray)
        }
    }

    func formattedDay() -> String {
        return DateFormatter.dayTime.string(from: date)
    }

    func formattedWeekDay() -> String {
        return DateFormatter.weekDayTime.string(from: date)
    }
}

struct TimelineViewPreviews: PreviewProvider {
    static var previews: some View {
        TimelineView(
            viewModel: TimelineViewModel(
                FakeTimelineProvider()
            ),
            isPresented: .constant(true)
        )
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
