// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
import LensProtocol

public class FeedPostsInfoQuery: GraphQLQuery {
  public static let operationName: String = "FeedPostsInfo"
  public static let document: DocumentType = .notPersisted(
    definition: .init(
      """
      query FeedPostsInfo($publicationIds: [InternalPublicationId!]) {
        publications(request: {publicationIds: $publicationIds}) {
          __typename
          items {
            __typename
            ... on Post {
              profile {
                __typename
                ownedBy
              }
              id
              stats {
                __typename
                totalUpvotes
                totalAmountOfComments
                totalAmountOfMirrors
              }
            }
            ... on Mirror {
              mirrorOf {
                __typename
                ... on Post {
                  profile {
                    __typename
                    ownedBy
                  }
                }
              }
              profile {
                __typename
                ownedBy
              }
              stats {
                __typename
                totalAmountOfMirrors
                totalAmountOfComments
                totalUpvotes
              }
              id
            }
          }
        }
      }
      """
    ))

  public var publicationIds: GraphQLNullable<[LensProtocol.InternalPublicationId]>

  public init(publicationIds: GraphQLNullable<[LensProtocol.InternalPublicationId]>) {
    self.publicationIds = publicationIds
  }

  public var __variables: Variables? { ["publicationIds": publicationIds] }

  public struct Data: LensProtocol.SelectionSet {
    public let __data: DataDict
    public init(data: DataDict) { __data = data }

    public static var __parentType: ParentType { LensProtocol.Objects.Query }
    public static var __selections: [Selection] { [
      .field("publications", Publications.self, arguments: ["request": ["publicationIds": .variable("publicationIds")]]),
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
      ] }

      public var items: [Item] { __data["items"] }

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
            .field("profile", Profile.self),
            .field("id", LensProtocol.InternalPublicationId.self),
            .field("stats", Stats.self),
          ] }

          /// The profile ref
          public var profile: Profile { __data["profile"] }
          /// The internal publication id
          public var id: LensProtocol.InternalPublicationId { __data["id"] }
          /// The publication stats
          public var stats: Stats { __data["stats"] }

          /// Publications.Item.AsPost.Profile
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
            .field("profile", Profile.self),
            .field("stats", Stats.self),
            .field("id", LensProtocol.InternalPublicationId.self),
          ] }

          /// The mirror publication
          public var mirrorOf: MirrorOf { __data["mirrorOf"] }
          /// The profile ref
          public var profile: Profile { __data["profile"] }
          /// The publication stats
          public var stats: Stats { __data["stats"] }
          /// The internal publication id
          public var id: LensProtocol.InternalPublicationId { __data["id"] }

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
              ] }

              /// The profile ref
              public var profile: Profile { __data["profile"] }

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
            }
          }

          /// Publications.Item.AsMirror.Profile
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
    }
  }
}
