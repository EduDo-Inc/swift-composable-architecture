import ComposableArchitecture
import Foundation

public struct LoginRequest {
  public var email: String
  public var password: String

  public init(
    email: String,
    password: String
  ) {
    self.email = email
    self.password = password
  }
}

public struct TwoFactorRequest {
  public var code: String
  public var token: String

  public init(
    code: String,
    token: String
  ) {
    self.code = code
    self.token = token
  }
}

public struct AuthenticationResponse: Equatable {
  public var token: String
  public var twoFactorRequired: Bool

  public init(
    token: String,
    twoFactorRequired: Bool
  ) {
    self.token = token
    self.twoFactorRequired = twoFactorRequired
  }
}

public enum AuthenticationError: Equatable, LocalizedError {
  case invalidUserPassword
  case invalidTwoFactor
  case invalidIntermediateToken

  public var errorDescription: String? {
    switch self {
    case .invalidUserPassword:
      return "Unknown user or invalid password."
    case .invalidTwoFactor:
      return "Invalid second factor (try 1234)"
    case .invalidIntermediateToken:
      return "404!! What happened to your token there bud?!?!"
    }
  }
}

public struct AuthenticationClient {
  public var login: (LoginRequest) async throws -> AuthenticationResponse
  public var twoFactor: (TwoFactorRequest) async throws -> AuthenticationResponse

  public init(
    login: @escaping (LoginRequest) async throws -> AuthenticationResponse,
    twoFactor: @escaping (TwoFactorRequest) async throws -> AuthenticationResponse
  ) {
    self.login = login
    self.twoFactor = twoFactor
  }
}

#if DEBUG
  extension AuthenticationClient {
    private struct Unimplemented: Error {
      let description: String
    }

    public static let failing = Self(
      login: { _ in throw Unimplemented(description: "login") },
      twoFactor: { _ in throw Unimplemented(description: "twoFactor") }
    )
  }
#endif