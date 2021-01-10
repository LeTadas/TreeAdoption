import Foundation

enum NetworkError: Int, Error {
    enum ResponseType {
        case clientError
        case serverError
        case undefined
    }

    //
    // Client Error - 4xx
    //

    case badRequest = 400
    case unauthorised = 401
    case paymentRequired = 402
    case forbidden = 403
    case notFound = 404
    case methodNotAllowed = 405
    case notAcceptable = 406
    case proxyAuthenticationRequired = 407
    case requestTimeout = 408
    case conflict = 409
    case gone = 410
    case lengthRequired = 411
    case preconditionFailed = 412
    case payloadTooLarge = 413
    case URITooLong = 414
    case unsupportedMediaType = 415
    case rangeNotSatisfiable = 416
    case expectationFailed = 417
    case teapot = 418
    case misdirectedRequest = 421
    case unprocessableEntity = 422
    case locked = 423
    case failedDependency = 424
    case upgradeRequired = 426
    case preconditionRequired = 428
    case tooManyRequests = 429
    case requestHeaderFieldsTooLarge = 431
    case noResponse = 444
    case unavailableForLegalReasons = 451
    case SSLCertificateError = 495
    case SSLCertificateRequired = 496
    case HTTPRequestSentToHTTPSPort = 497
    case clientClosedRequest = 499

    //
    // Server Error - 5xx
    //

    case internalServerError = 500
    case notImplemented = 501
    case badGateway = 502
    case serviceUnavailable = 503
    case gatewayTimeout = 504
    case HTTPVersionNotSupported = 505
    case variantAlsoNegotiates = 506
    case insufficientStorage = 507
    case loopDetected = 508
    case notExtended = 510
    case networkAuthenticationRequired = 511

    var responseType: ResponseType {
        switch rawValue {
            case 400 ..< 500:
                return .clientError

            case 500 ..< 600:
                return .serverError

            default:
                return .undefined
        }
    }
}

extension HTTPURLResponse {
    var error: NetworkError? {
        return NetworkError(rawValue: statusCode)
    }
}
