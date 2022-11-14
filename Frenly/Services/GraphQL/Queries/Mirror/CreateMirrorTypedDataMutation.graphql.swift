// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
import LensProtocol

public class CreateMirrorTypedDataMutation: GraphQLMutation {
  public static let operationName: String = "CreateMirrorTypedData"
  public static let document: DocumentType = .notPersisted(
    definition: .init(
      """
      mutation CreateMirrorTypedData($profileId: ProfileId!, $publicationId: InternalPublicationId!) {
        createMirrorTypedData(
          request: {profileId: $profileId, publicationId: $publicationId, referenceModule: {followerOnlyReferenceModule: false}}
        ) {
          __typename
          id
          expiresAt
          typedData {
            __typename
            types {
              __typename
              MirrorWithSig {
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
              profileIdPointed
              pubIdPointed
              referenceModule
              referenceModuleData
              referenceModuleInitData
            }
          }
        }
      }
      """
    ))

  public var profileId: LensProtocol.ProfileId
  public var publicationId: LensProtocol.InternalPublicationId

  public init(
    profileId: LensProtocol.ProfileId,
    publicationId: LensProtocol.InternalPublicationId
  ) {
    self.profileId = profileId
    self.publicationId = publicationId
  }

  public var __variables: Variables? { [
    "profileId": profileId,
    "publicationId": publicationId
  ] }

  public struct Data: LensProtocol.SelectionSet {
    public let __data: DataDict
    public init(data: DataDict) { __data = data }

    public static var __parentType: ParentType { LensProtocol.Objects.Mutation }
    public static var __selections: [Selection] { [
      .field("createMirrorTypedData", CreateMirrorTypedData.self, arguments: ["request": [
        "profileId": .variable("profileId"),
        "publicationId": .variable("publicationId"),
        "referenceModule": ["followerOnlyReferenceModule": false]
      ]]),
    ] }

    public var createMirrorTypedData: CreateMirrorTypedData { __data["createMirrorTypedData"] }

    /// CreateMirrorTypedData
    ///
    /// Parent Type: `CreateMirrorBroadcastItemResult`
    public struct CreateMirrorTypedData: LensProtocol.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ParentType { LensProtocol.Objects.CreateMirrorBroadcastItemResult }
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

      /// CreateMirrorTypedData.TypedData
      ///
      /// Parent Type: `CreateMirrorEIP712TypedData`
      public struct TypedData: LensProtocol.SelectionSet {
        public let __data: DataDict
        public init(data: DataDict) { __data = data }

        public static var __parentType: ParentType { LensProtocol.Objects.CreateMirrorEIP712TypedData }
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

        /// CreateMirrorTypedData.TypedData.Types
        ///
        /// Parent Type: `CreateMirrorEIP712TypedDataTypes`
        public struct Types: LensProtocol.SelectionSet {
          public let __data: DataDict
          public init(data: DataDict) { __data = data }

          public static var __parentType: ParentType { LensProtocol.Objects.CreateMirrorEIP712TypedDataTypes }
          public static var __selections: [Selection] { [
            .field("MirrorWithSig", [MirrorWithSig].self),
          ] }

          public var mirrorWithSig: [MirrorWithSig] { __data["MirrorWithSig"] }

          /// CreateMirrorTypedData.TypedData.Types.MirrorWithSig
          ///
          /// Parent Type: `EIP712TypedDataField`
          public struct MirrorWithSig: LensProtocol.SelectionSet {
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

        /// CreateMirrorTypedData.TypedData.Domain
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

        /// CreateMirrorTypedData.TypedData.Value
        ///
        /// Parent Type: `CreateMirrorEIP712TypedDataValue`
        public struct Value: LensProtocol.SelectionSet {
          public let __data: DataDict
          public init(data: DataDict) { __data = data }

          public static var __parentType: ParentType { LensProtocol.Objects.CreateMirrorEIP712TypedDataValue }
          public static var __selections: [Selection] { [
            .field("nonce", LensProtocol.Nonce.self),
            .field("deadline", LensProtocol.UnixTimestamp.self),
            .field("profileId", LensProtocol.ProfileId.self),
            .field("profileIdPointed", LensProtocol.ProfileId.self),
            .field("pubIdPointed", LensProtocol.PublicationId.self),
            .field("referenceModule", LensProtocol.ContractAddress.self),
            .field("referenceModuleData", LensProtocol.ReferenceModuleData.self),
            .field("referenceModuleInitData", LensProtocol.ReferenceModuleData.self),
          ] }

          public var nonce: LensProtocol.Nonce { __data["nonce"] }
          public var deadline: LensProtocol.UnixTimestamp { __data["deadline"] }
          public var profileId: LensProtocol.ProfileId { __data["profileId"] }
          public var profileIdPointed: LensProtocol.ProfileId { __data["profileIdPointed"] }
          public var pubIdPointed: LensProtocol.PublicationId { __data["pubIdPointed"] }
          public var referenceModule: LensProtocol.ContractAddress { __data["referenceModule"] }
          public var referenceModuleData: LensProtocol.ReferenceModuleData { __data["referenceModuleData"] }
          public var referenceModuleInitData: LensProtocol.ReferenceModuleData { __data["referenceModuleInitData"] }
        }
      }
    }
  }
}
