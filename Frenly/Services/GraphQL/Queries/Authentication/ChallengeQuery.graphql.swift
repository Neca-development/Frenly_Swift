// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
import LensProtocol

public class ChallengeQuery: GraphQLQuery {
  public static let operationName: String = "Challenge"
  public static let document: DocumentType = .notPersisted(
    definition: .init(
      """
      query Challenge($address: EthereumAddress!) {
        challenge(request: {address: $address}) {
          __typename
          text
        }
      }
      """
    ))

  public var address: LensProtocol.EthereumAddress

  public init(address: LensProtocol.EthereumAddress) {
    self.address = address
  }

  public var __variables: Variables? { ["address": address] }

  public struct Data: LensProtocol.SelectionSet {
    public let __data: DataDict
    public init(data: DataDict) { __data = data }

    public static var __parentType: ParentType { LensProtocol.Objects.Query }
    public static var __selections: [Selection] { [
      .field("challenge", Challenge.self, arguments: ["request": ["address": .variable("address")]]),
    ] }

    public var challenge: Challenge { __data["challenge"] }

    /// Challenge
    ///
    /// Parent Type: `AuthChallengeResult`
    public struct Challenge: LensProtocol.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ParentType { LensProtocol.Objects.AuthChallengeResult }
      public static var __selections: [Selection] { [
        .field("text", String.self),
      ] }

      /// The text to sign
      public var text: String { __data["text"] }
    }
  }
}
