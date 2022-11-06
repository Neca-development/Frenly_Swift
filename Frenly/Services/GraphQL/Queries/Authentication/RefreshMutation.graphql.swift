// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
import LensProtocol

public class RefreshMutation: GraphQLMutation {
  public static let operationName: String = "Refresh"
  public static let document: DocumentType = .notPersisted(
    definition: .init(
      """
      mutation Refresh($token: Jwt!) {
        refresh(request: {refreshToken: $token}) {
          __typename
          accessToken
          refreshToken
        }
      }
      """
    ))

  public var token: LensProtocol.Jwt

  public init(token: LensProtocol.Jwt) {
    self.token = token
  }

  public var __variables: Variables? { ["token": token] }

  public struct Data: LensProtocol.SelectionSet {
    public let __data: DataDict
    public init(data: DataDict) { __data = data }

    public static var __parentType: ParentType { LensProtocol.Objects.Mutation }
    public static var __selections: [Selection] { [
      .field("refresh", Refresh.self, arguments: ["request": ["refreshToken": .variable("token")]]),
    ] }

    public var refresh: Refresh { __data["refresh"] }

    /// Refresh
    ///
    /// Parent Type: `AuthenticationResult`
    public struct Refresh: LensProtocol.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ParentType { LensProtocol.Objects.AuthenticationResult }
      public static var __selections: [Selection] { [
        .field("accessToken", LensProtocol.Jwt.self),
        .field("refreshToken", LensProtocol.Jwt.self),
      ] }

      /// The access token
      public var accessToken: LensProtocol.Jwt { __data["accessToken"] }
      /// The refresh token
      public var refreshToken: LensProtocol.Jwt { __data["refreshToken"] }
    }
  }
}
