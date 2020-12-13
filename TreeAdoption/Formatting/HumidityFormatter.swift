class HumidityFormatter {
    class func format(humidity: Double) -> String {
        return String(format: "%.0f%@", humidity, "%")
    }
}
