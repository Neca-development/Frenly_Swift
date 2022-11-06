// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
import LensProtocol

public class AuthenticateMutation: GraphQLMutation {
  public static let operationName: String = "Authenticate"
  public static let document: DocumentType = .notPersisted(
    definition: .init(
      """
      mutation Authenticate($address: EthereumAddress!, $signature: Signature!) {
        authenticate(request: {address: $address, signature: $signature}) {
          __typename
          accessToken
          refreshToken
        }
      }
      """
    ))

  public var address: LensProtocol.EthereumAddress
  public var signature: LensProtocol.Signature

  public init(
    address: LensProtocol.EthereumAddress,
    signature: LensProtocol.Signature
  ) {
    self.address = address
    self.signature = signature
  }

  public var __variables: Variables? { [
    "address": address,
    "signature": signature
  ] }

  public struct Data: LensProtocol.SelectionSet {
    public let __data: DataDict
    public init(data: DataDict) { __data = data }

    public static var __parentType: ParentType { LensProtocol.Objects.Mutation }
    public static var __selections: [Selection] { [
      .field("authenticate", Authenticate.self, arguments: ["request": [
        "address": .variable("address"),
        "signature": .variable("signature")
      ]]),
    ] }

    public var authenticate: Authenticate { __data["authenticate"] }

    /// Authenticate
    ///
    /// Parent Type: `AuthenticationResult`
    public struct Authenticate: LensProtocol.SelectionSet {
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
