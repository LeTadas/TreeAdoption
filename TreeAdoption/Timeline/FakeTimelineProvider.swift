import Combine
import Foundation

protocol TimelineProvider {
    func getTimeline() -> AnyPublisher<Result<[TimelineItemType], RequestError>, Never>
}

class FakeTimelineProvider: TimelineProvider {
    func getTimeline() -> AnyPublisher<Result<[TimelineItemType], RequestError>, Never> {
        return Just(
            Result.success(
                [
                    .label("DEC"),
                    .image(
                        TimelineImageItem(
                            title: "New image",
                            description: "Added new tree picture",
                            imageUrl: "https://images.pexels.com/photos/216695/pexels-photo-216695.jpeg?cs=srgb&dl=pexels-iconcom-216695.jpg&fm=jpg",
                            date: parseDate(string: "13-12-2020")
                        )
                    ),
                    .health(
                        TimelineHealthItem(
                            title: "Health update",
                            description: "Tree is doing better now",
                            severityFraction: 0.38,
                            date: parseDate(string: "09-12-2020")
                        )
                    ),
                    .label("NOV"),
                    .image(
                        TimelineImageItem(
                            title: "New image",
                            description: "Today was freezing in the morning I had to capture this awesome view",
                            imageUrl: "https://images.pexels.com/photos/3732527/pexels-photo-3732527.jpeg?cs=srgb&dl=pexels-simon-matzinger-3732527.jpg&fm=jpg",
                            date: parseDate(string: "24-11-2020")
                        )
                    ),
                    .image(
                        TimelineImageItem(
                            title: "New image",
                            description: "New tree image was uploaded today",
                            imageUrl: "https://images.pexels.com/photos/802127/pexels-photo-802127.jpeg?cs=srgb&dl=pexels-nashrodin-aratuc-802127.jpg&fm=jpg",
                            date: parseDate(string: "01-11-2020")
                        )
                    )
                ]
            )
        )
        .receive(on: DispatchQueue.main)
        .delay(for: 2, scheduler: RunLoop.main)
        .eraseToAnyPublisher()
    }

    private func parseDate(string: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter.date(from: string) ?? Date()
    }
}
