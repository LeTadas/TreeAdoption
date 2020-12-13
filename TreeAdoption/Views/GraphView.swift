import SwiftUI

struct GraphView: View {
    let data: [Point]

    init(data: [Point]) {
        if data.isEmpty {
            self.data = [Point(x: 0.0, y: 0.5), Point(x: 1, y: 0.5)]
        } else {
            self.data = data
        }
    }

    var body: some View {
        ZStack {
            graphBackground
            graphBody
        }
    }

    private var graphBody: some View {
        GeometryReader { geometry in
            Path { path in

                path.move(to: .init(x: 0, y: (1 - data.first!.y) * geometry.size.height))

                self.data.forEach { point in
                    let x = point.x * geometry.size.width
                    let y = (1 - point.y) * geometry.size.height

                    path.addLine(to: .init(x: x, y: y))
                }

                path.addLine(to: .init(x: geometry.size.width, y: (1 - data.last!.y) * geometry.size.height))
            }
            .stroke(
                Color.primaryColor,
                style: StrokeStyle(lineWidth: 2)
            )
        }
    }

    private var graphBackground: some View {
        GeometryReader { geometry in
            Path { path in

                path.move(to: .init(x: 0, y: 0))
                path.addLine(to: .init(x: 0, y: (1 - data.first!.y) * geometry.size.height))

                self.data.forEach { point in
                    let x = point.x * geometry.size.width
                    let y = (1 - point.y) * geometry.size.height

                    path.addLine(to: .init(x: x, y: y))
                }

                path.addLine(to: .init(x: geometry.size.width, y: geometry.size.height))
                path.addLine(to: .init(x: 0, y: geometry.size.height))
            }
            .fill(
                LinearGradient(
                    gradient:
                    Gradient(
                        colors: [
                            Color.primaryColor.opacity(0.1),
                            .white
                        ]
                    ),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        }
    }
}

struct GraphViewPreviews: PreviewProvider {
    static var previews: some View {
        GraphView(
            data: [
                Point(x: 0, y: 0.1),
                Point(x: 0.25, y: 0.4),
                Point(x: 0.5, y: 0.5),
                Point(x: 0.75, y: 0.7),
                Point(x: 1, y: 0.4)
            ]
        )
    }
}

struct Point {
    let x: CGFloat
    let y: CGFloat
}
