// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
import LensProtocol

public class UserPostsByLensIdQuery: GraphQLQuery {
  public static let operationName: String = "UserPostsByLensId"
  public static let document: DocumentType = .notPersisted(
    definition: .init(
      """
      query UserPostsByLensId($profileId: ProfileId!, $cursor: Cursor) {
        publications(request: {profileId: $profileId, cursor: $cursor, limit: 50}) {
          __typename
          items {
            __typename
            ... on Post {
              id
              stats {
                __typename
                totalUpvotes
                totalAmountOfComments
                totalAmountOfMirrors
              }
              metadata {
                __typename
                image
                attributes {
                  __typename
                  traitType
                  value
                }
              }
              createdAt
            }
            ... on Mirror {
              mirrorOf {
                __typename
                ... on Post {
                  profile {
                    __typename
                    ownedBy
                  }
                  metadata {
                    __typename
                    content
                    attributes {
                      __typename
                      traitType
                      value
                    }
                  }
                }
              }
              stats {
                __typename
                totalAmountOfMirrors
                totalAmountOfComments
                totalUpvotes
              }
              id
              createdAt
            }
          }
          pageInfo {
            __typename
            next
          }
        }
      }
      """
    ))

  public var profileId: LensProtocol.ProfileId
  public var cursor: GraphQLNullable<LensProtocol.Cursor>

  public init(
    profileId: LensProtocol.ProfileId,
    cursor: GraphQLNullable<LensProtocol.Cursor>
  ) {
    self.profileId = profileId
    self.cursor = cursor
  }

  public var __variables: Variables? { [
    "profileId": profileId,
    "cursor": cursor
  ] }

  public struct Data: LensProtocol.SelectionSet {
    public let __data: DataDict
    public init(data: DataDict) { __data = data }

    public static var __parentType: ParentType { LensProtocol.Objects.Query }
    public static var __selections: [Selection] { [
      .field("publications", Publications.self, arguments: ["request": [
        "profileId": .variable("profileId"),
        "cursor": .variable("cursor"),
        "limit": 50
      ]]),
    ] }

    public var publications: Publications { __data["publications"] }

    /// Publications
    ///
    /// Parent Type: `PaginatedPublicationResult`
    public struct Publications: LensProtocol.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ParentType { LensProtocol.Objects.PaginatedPublicationResult }
      public static var __selections: [Selection] { [
        .field("items", [Item].self),
        .field("pageInfo", PageInfo.self),
      ] }

      public var items: [Item] { __data["items"] }
      public var pageInfo: PageInfo { __data["pageInfo"] }

      /// Publications.Item
      ///
      /// Parent Type: `Publication`
      public struct Item: LensProtocol.SelectionSet {
        public let __data: DataDict
        public init(data: DataDict) { __data = data }

        public static var __parentType: ParentType { LensProtocol.Unions.Publication }
        public static var __selections: [Selection] { [
          .inlineFragment(AsPost.self),
          .inlineFragment(AsMirror.self),
        ] }

        public var asPost: AsPost? { _asInlineFragment() }
        public var asMirror: AsMirror? { _asInlineFragment() }

        /// Publications.Item.AsPost
        ///
        /// Parent Type: `Post`
        public struct AsPost: LensProtocol.InlineFragment {
          public let __data: DataDict
          public init(data: DataDict) { __data = data }

          public static var __parentType: ParentType { LensProtocol.Objects.Post }
          public static var __selections: [Selection] { [
            .field("id", LensProtocol.InternalPublicationId.self),
            .field("stats", Stats.self),
            .field("metadata", Metadata.self),
            .field("createdAt", LensProtocol.DateTime.self),
          ] }

          /// The internal publication id
          public var id: LensProtocol.InternalPublicationId { __data["id"] }
          /// The publication stats
          public var stats: Stats { __data["stats"] }
          /// The metadata for the post
          public var metadata: Metadata { __data["metadata"] }
          /// The date the post was created on
          public var createdAt: LensProtocol.DateTime { __data["createdAt"] }

          /// Publications.Item.AsPost.Stats
          ///
          /// Parent Type: `PublicationStats`
          public struct Stats: LensProtocol.SelectionSet {
            public let __data: DataDict
            public init(data: DataDict) { __data = data }

            public static var __parentType: ParentType { LensProtocol.Objects.PublicationStats }
            public static var __selections: [Selection] { [
              .field("totalUpvotes", Int.self),
              .field("totalAmountOfComments", Int.self),
              .field("totalAmountOfMirrors", Int.self),
            ] }

            /// The total amount of downvotes
            public var totalUpvotes: Int { __data["totalUpvotes"] }
            /// The total amount of comments
            public var totalAmountOfComments: Int { __data["totalAmountOfComments"] }
            /// The total amount of mirrors
            public var totalAmountOfMirrors: Int { __data["totalAmountOfMirrors"] }
          }

          /// Publications.Item.AsPost.Metadata
          ///
          /// Parent Type: `MetadataOutput`
          public struct Metadata: LensProtocol.SelectionSet {
            public let __data: DataDict
            public init(data: DataDict) { __data = data }

            public static var __parentType: ParentType { LensProtocol.Objects.MetadataOutput }
            public static var __selections: [Selection] { [
              .field("image", LensProtocol.Url?.self),
              .field("attributes", [Attribute].self),
            ] }

            /// This is the image attached to the metadata and the property used to show the NFT!
            public var image: LensProtocol.Url? { __data["image"] }
            /// The attributes
            public var attributes: [Attribute] { __data["attributes"] }

            /// Publications.Item.AsPost.Metadata.Attribute
            ///
            /// Parent Type: `MetadataAttributeOutput`
            public struct Attribute: LensProtocol.SelectionSet {
              public let __data: DataDict
              public init(data: DataDict) { __data = data }

              public static var __parentType: ParentType { LensProtocol.Objects.MetadataAttributeOutput }
              public static var __selections: [Selection] { [
                .field("traitType", String?.self),
                .field("value", String?.self),
              ] }

              /// The trait type - can be anything its the name it will render so include spaces
              public var traitType: String? { __data["traitType"] }
              /// The value
              public var value: String? { __data["value"] }
            }
          }
        }

        /// Publications.Item.AsMirror
        ///
        /// Parent Type: `Mirror`
        public struct AsMirror: LensProtocol.InlineFragment {
          public let __data: DataDict
          public init(data: DataDict) { __data = data }

          public static var __parentType: ParentType { LensProtocol.Objects.Mirror }
          public static var __selections: [Selection] { [
            .field("mirrorOf", MirrorOf.self),
            .field("stats", Stats.self),
            .field("id", LensProtocol.InternalPublicationId.self),
            .field("createdAt", LensProtocol.DateTime.self),
          ] }

          /// The mirror publication
          public var mirrorOf: MirrorOf { __data["mirrorOf"] }
          /// The publication stats
          public var stats: Stats { __data["stats"] }
          /// The internal publication id
          public var id: LensProtocol.InternalPublicationId { __data["id"] }
          /// The date the post was created on
          public var createdAt: LensProtocol.DateTime { __data["createdAt"] }

          /// Publications.Item.AsMirror.MirrorOf
          ///
          /// Parent Type: `MirrorablePublication`
          public struct MirrorOf: LensProtocol.SelectionSet {
            public let __data: DataDict
            public init(data: DataDict) { __data = data }

            public static var __parentType: ParentType { LensProtocol.Unions.MirrorablePublication }
            public static var __selections: [Selection] { [
              .inlineFragment(AsPost.self),
            ] }

            public var asPost: AsPost? { _asInlineFragment() }

            /// Publications.Item.AsMirror.MirrorOf.AsPost
            ///
            /// Parent Type: `Post`
            public struct AsPost: LensProtocol.InlineFragment {
              public let __data: DataDict
              public init(data: DataDict) { __data = data }

              public static var __parentType: ParentType { LensProtocol.Objects.Post }
              public static var __selections: [Selection] { [
                .field("profile", Profile.self),
                .field("metadata", Metadata.self),
              ] }

              /// The profile ref
              public var profile: Profile { __data["profile"] }
              /// The metadata for the post
              public var metadata: Metadata { __data["metadata"] }

              /// Publications.Item.AsMirror.MirrorOf.AsPost.Profile
              ///
              /// Parent Type: `Profile`
              public struct Profile: LensProtocol.SelectionSet {
                public let __data: DataDict
                public init(data: DataDict) { __data = data }

                public static var __parentType: ParentType { LensProtocol.Objects.Profile }
                public static var __selections: [Selection] { [
                  .field("ownedBy", LensProtocol.EthereumAddress.self),
                ] }

                /// Who owns the profile
                public var ownedBy: LensProtocol.EthereumAddress { __data["ownedBy"] }
              }

              /// Publications.Item.AsMirror.MirrorOf.AsPost.Metadata
              ///
              /// Parent Type: `MetadataOutput`
              public struct Metadata: LensProtocol.SelectionSet {
                public let __data: DataDict
                public init(data: DataDict) { __data = data }

                public static var __parentType: ParentType { LensProtocol.Objects.MetadataOutput }
                public static var __selections: [Selection] { [
                  .field("content", LensProtocol.Markdown?.self),
                  .field("attributes", [Attribute].self),
                ] }

                /// This is the metadata content for the publication, should be markdown
                public var content: LensProtocol.Markdown? { __data["content"] }
                /// The attributes
                public var attributes: [Attribute] { __data["attributes"] }

                /// Publications.Item.AsMirror.MirrorOf.AsPost.Metadata.Attribute
                ///
                /// Parent Type: `MetadataAttributeOutput`
                public struct Attribute: LensProtocol.SelectionSet {
                  public let __data: DataDict
                  public init(data: DataDict) { __data = data }

                  public static var __parentType: ParentType { LensProtocol.Objects.MetadataAttributeOutput }
                  public static var __selections: [Selection] { [
                    .field("traitType", String?.self),
                    .field("value", String?.self),
                  ] }

                  /// The trait type - can be anything its the name it will render so include spaces
                  public var traitType: String? { __data["traitType"] }
                  /// The value
                  public var value: String? { __data["value"] }
                }
              }
            }
          }

          /// Publications.Item.AsMirror.Stats
          ///
          /// Parent Type: `PublicationStats`
          public struct Stats: LensProtocol.SelectionSet {
            public let __data: DataDict
            public init(data: DataDict) { __data = data }

            public static var __parentType: ParentType { LensProtocol.Objects.PublicationStats }
            public static var __selections: [Selection] { [
              .field("totalAmountOfMirrors", Int.self),
              .field("totalAmountOfComments", Int.self),
              .field("totalUpvotes", Int.self),
            ] }

            /// The total amount of mirrors
            public var totalAmountOfMirrors: Int { __data["totalAmountOfMirrors"] }
            /// The total amount of comments
            public var totalAmountOfComments: Int { __data["totalAmountOfComments"] }
            /// The total amount of downvotes
            public var totalUpvotes: Int { __data["totalUpvotes"] }
          }
        }
      }

      /// Publications.PageInfo
      ///
      /// Parent Type: `PaginatedResultInfo`
      public struct PageInfo: LensProtocol.SelectionSet {
        public let __data: DataDict
        public init(data: DataDict) { __data = data }

        public static var __parentType: ParentType { LensProtocol.Objects.PaginatedResultInfo }
        public static var __selections: [Selection] { [
          .field("next", LensProtocol.Cursor?.self),
        ] }

        /// Cursor to query next results
        public var next: LensProtocol.Cursor? { __data["next"] }
      }
    }
  }
}
