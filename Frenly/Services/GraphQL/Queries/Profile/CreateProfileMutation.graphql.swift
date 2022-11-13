// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
import LensProtocol

public class CreateProfileMutation: GraphQLMutation {
  public static let operationName: String = "CreateProfile"
  public static let document: DocumentType = .notPersisted(
    definition: .init(
      """
      mutation CreateProfile($profileName: CreateHandle!) {
        createProfile(
          request: {handle: $profileName, profilePictureUri: null, followNFTURI: null, followModule: null}
        ) {
          ... on RelayerResult {
            txHash
          }
          ... on RelayError {
            reason
          }
          __typename
        }
      }
      """
    ))

  public var profileName: LensProtocol.CreateHandle

  public init(profileName: LensProtocol.CreateHandle) {
    self.profileName = profileName
  }

  public var __variables: Variables? { ["profileName": profileName] }

  public struct Data: LensProtocol.SelectionSet {
    public let __data: DataDict
    public init(data: DataDict) { __data = data }

    public static var __parentType: ParentType { LensProtocol.Objects.Mutation }
    public static var __selections: [Selection] { [
      .field("createProfile", CreateProfile.self, arguments: ["request": [
        "handle": .variable("profileName"),
        "profilePictureUri": .null,
        "followNFTURI": .null,
        "followModule": .null
      ]]),
    ] }

    public var createProfile: CreateProfile { __data["createProfile"] }

    /// CreateProfile
    ///
    /// Parent Type: `RelayResult`
    public struct CreateProfile: LensProtocol.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ParentType { LensProtocol.Unions.RelayResult }
      public static var __selections: [Selection] { [
        .inlineFragment(AsRelayerResult.self),
        .inlineFragment(AsRelayError.self),
      ] }

      public var asRelayerResult: AsRelayerResult? { _asInlineFragment() }
      public var asRelayError: AsRelayError? { _asInlineFragment() }

      /// CreateProfile.AsRelayerResult
      ///
      /// Parent Type: `RelayerResult`
      public struct AsRelayerResult: LensProtocol.InlineFragment {
        public let __data: DataDict
        public init(data: DataDict) { __data = data }

        public static var __parentType: ParentType { LensProtocol.Objects.RelayerResult }
        public static var __selections: [Selection] { [
          .field("txHash", LensProtocol.TxHash.self),
        ] }

        /// The tx hash - you should use the `txId` as your identifier as gas prices can be upgraded meaning txHash will change
        public var txHash: LensProtocol.TxHash { __data["txHash"] }
      }

      /// CreateProfile.AsRelayError
      ///
      /// Parent Type: `RelayError`
      public struct AsRelayError: LensProtocol.InlineFragment {
        public let __data: DataDict
        public init(data: DataDict) { __data = data }

        public static var __parentType: ParentType { LensProtocol.Objects.RelayError }
        public static var __selections: [Selection] { [
          .field("reason", GraphQLEnum<LensProtocol.RelayErrorReasons>.self),
        ] }

        public var reason: GraphQLEnum<LensProtocol.RelayErrorReasons> { __data["reason"] }
      }
    }
  }
}
