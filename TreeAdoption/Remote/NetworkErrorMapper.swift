import Foundation

class NetworkErrorMapper {
    static func mapError(response: URLResponse?) -> Error? {
        guard let httpResponse = response as? HTTPURLResponse else {
            return nil
        }

        if (400 ... 600).contains(httpResponse.statusCode) {
            return httpResponse.error
        }

        return nil
    }
}
