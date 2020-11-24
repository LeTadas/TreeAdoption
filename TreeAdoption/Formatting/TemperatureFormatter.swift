import Foundation

class TemperatureFormatter {
    class func format(temperature: Double) -> String {
        let measureFormatter = MeasurementFormatter()
        measureFormatter.locale = Locale(identifier: "nl_NL")
        let measurement = Measurement(value: temperature, unit: UnitTemperature.celsius)
        return measureFormatter.string(from: measurement)
    }
}
