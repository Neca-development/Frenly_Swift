// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
import LensProtocol

public class CreatePostTypedDataMutation: GraphQLMutation {
  public static let operationName: String = "CreatePostTypedData"
  public static let document: DocumentType = .notPersisted(
    definition: .init(
      """
      mutation CreatePostTypedData($profileId: ProfileId!, $contentURI: Url!) {
        createPostTypedData(
          request: {profileId: $profileId, contentURI: $contentURI, collectModule: {revertCollectModule: true}, referenceModule: {followerOnlyReferenceModule: false}}
        ) {
          __typename
          id
          expiresAt
          typedData {
            __typename
            types {
              __typename
              PostWithSig {
                __typename
                name
                type
              }
            }
            domain {
              __typename
              name
              chainId
              version
              verifyingContract
            }
            value {
              __typename
              nonce
              deadline
              profileId
              contentURI
              collectModule
              collectModuleInitData
              referenceModule
              referenceModuleInitData
            }
          }
        }
      }
      """
    ))

  public var profileId: LensProtocol.ProfileId
  public var contentURI: LensProtocol.Url

  public init(
    profileId: LensProtocol.ProfileId,
    contentURI: LensProtocol.Url
  ) {
    self.profileId = profileId
    self.contentURI = contentURI
  }

  public var __variables: Variables? { [
    "profileId": profileId,
    "contentURI": contentURI
  ] }

  public struct Data: LensProtocol.SelectionSet {
    public let __data: DataDict
    public init(data: DataDict) { __data = data }

    public static var __parentType: ParentType { LensProtocol.Objects.Mutation }
    public static var __selections: [Selection] { [
      .field("createPostTypedData", CreatePostTypedData.self, arguments: ["request": [
        "profileId": .variable("profileId"),
        "contentURI": .variable("contentURI"),
        "collectModule": ["revertCollectModule": true],
        "referenceModule": ["followerOnlyReferenceModule": false]
      ]]),
    ] }

    public var createPostTypedData: CreatePostTypedData { __data["createPostTypedData"] }

    /// CreatePostTypedData
    ///
    /// Parent Type: `CreatePostBroadcastItemResult`
    public struct CreatePostTypedData: LensProtocol.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ParentType { LensProtocol.Objects.CreatePostBroadcastItemResult }
      public static var __selections: [Selection] { [
        .field("id", LensProtocol.BroadcastId.self),
        .field("expiresAt", LensProtocol.DateTime.self),
        .field("typedData", TypedData.self),
      ] }

      /// This broadcast item ID
      public var id: LensProtocol.BroadcastId { __data["id"] }
      /// The date the broadcast item expiries
      public var expiresAt: LensProtocol.DateTime { __data["expiresAt"] }
      /// The typed data
      public var typedData: TypedData { __data["typedData"] }

      /// CreatePostTypedData.TypedData
      ///
      /// Parent Type: `CreatePostEIP712TypedData`
      public struct TypedData: LensProtocol.SelectionSet {
        public let __data: DataDict
        public init(data: DataDict) { __data = data }

        public static var __parentType: ParentType { LensProtocol.Objects.CreatePostEIP712TypedData }
        public static var __selections: [Selection] { [
          .field("types", Types.self),
          .field("domain", Domain.self),
          .field("value", Value.self),
        ] }

        /// The types
        public var types: Types { __data["types"] }
        /// The typed data domain
        public var domain: Domain { __data["domain"] }
        /// The values
        public var value: Value { __data["value"] }

        /// CreatePostTypedData.TypedData.Types
        ///
        /// Parent Type: `CreatePostEIP712TypedDataTypes`
        public struct Types: LensProtocol.SelectionSet {
          public let __data: DataDict
          public init(data: DataDict) { __data = data }

          public static var __parentType: ParentType { LensProtocol.Objects.CreatePostEIP712TypedDataTypes }
          public static var __selections: [Selection] { [
            .field("PostWithSig", [PostWithSig].self),
          ] }

          public var postWithSig: [PostWithSig] { __data["PostWithSig"] }

          /// CreatePostTypedData.TypedData.Types.PostWithSig
          ///
          /// Parent Type: `EIP712TypedDataField`
          public struct PostWithSig: LensProtocol.SelectionSet {
            public let __data: DataDict
            public init(data: DataDict) { __data = data }

            public static var __parentType: ParentType { LensProtocol.Objects.EIP712TypedDataField }
            public static var __selections: [Selection] { [
              .field("name", String.self),
              .field("type", String.self),
            ] }

            /// The name of the typed data field
            public var name: String { __data["name"] }
            /// The type of the typed data field
            public var type: String { __data["type"] }
          }
        }

        /// CreatePostTypedData.TypedData.Domain
        ///
        /// Parent Type: `EIP712TypedDataDomain`
        public struct Domain: LensProtocol.SelectionSet {
          public let __data: DataDict
          public init(data: DataDict) { __data = data }

          public static var __parentType: ParentType { LensProtocol.Objects.EIP712TypedDataDomain }
          public static var __selections: [Selection] { [
            .field("name", String.self),
            .field("chainId", LensProtocol.ChainId.self),
            .field("version", String.self),
            .field("verifyingContract", LensProtocol.ContractAddress.self),
          ] }

          /// The name of the typed data domain
          public var name: String { __data["name"] }
          /// The chainId
          public var chainId: LensProtocol.ChainId { __data["chainId"] }
          /// The version
          public var version: String { __data["version"] }
          /// The verifying contract
          public var verifyingContract: LensProtocol.ContractAddress { __data["verifyingContract"] }
        }

        /// CreatePostTypedData.TypedData.Value
        ///
        /// Parent Type: `CreatePostEIP712TypedDataValue`
        public struct Value: LensProtocol.SelectionSet {
          public let __data: DataDict
          public init(data: DataDict) { __data = data }

          public static var __parentType: ParentType { LensProtocol.Objects.CreatePostEIP712TypedDataValue }
          public static var __selections: [Selection] { [
            .field("nonce", LensProtocol.Nonce.self),
            .field("deadline", LensProtocol.UnixTimestamp.self),
            .field("profileId", LensProtocol.ProfileId.self),
            .field("contentURI", LensProtocol.PublicationUrl.self),
            .field("collectModule", LensProtocol.ContractAddress.self),
            .field("collectModuleInitData", LensProtocol.CollectModuleData.self),
            .field("referenceModule", LensProtocol.ContractAddress.self),
            .field("referenceModuleInitData", LensProtocol.ReferenceModuleData.self),
          ] }

          public var nonce: LensProtocol.Nonce { __data["nonce"] }
          public var deadline: LensProtocol.UnixTimestamp { __data["deadline"] }
          public var profileId: LensProtocol.ProfileId { __data["profileId"] }
          public var contentURI: LensProtocol.PublicationUrl { __data["contentURI"] }
          public var collectModule: LensProtocol.ContractAddress { __data["collectModule"] }
          public var collectModuleInitData: LensProtocol.CollectModuleData { __data["collectModuleInitData"] }
          public var referenceModule: LensProtocol.ContractAddress { __data["referenceModule"] }
          public var referenceModuleInitData: LensProtocol.ReferenceModuleData { __data["referenceModuleInitData"] }
        }
      }
    }
  }
}
