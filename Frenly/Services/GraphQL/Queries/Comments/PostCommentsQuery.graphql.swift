// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
import LensProtocol

public class PostCommentsQuery: GraphQLQuery {
  public static let operationName: String = "PostComments"
  public static let document: DocumentType = .notPersisted(
    definition: .init(
      """
      query PostComments($publicationId: InternalPublicationId!) {
        publications(request: {commentsOf: $publicationId}) {
          __typename
          items {
            __typename
            ... on Comment {
              id
              metadata {
                __typename
                content
              }
              createdAt
              profile {
                __typename
                ownedBy
              }
            }
          }
        }
      }
      """
    ))

  public var publicationId: LensProtocol.InternalPublicationId

  public init(publicationId: LensProtocol.InternalPublicationId) {
    self.publicationId = publicationId
  }

  public var __variables: Variables? { ["publicationId": publicationId] }

  public struct Data: LensProtocol.SelectionSet {
    public let __data: DataDict
    public init(data: DataDict) { __data = data }

    public static var __parentType: ParentType { LensProtocol.Objects.Query }
    public static var __selections: [Selection] { [
      .field("publications", Publications.self, arguments: ["request": ["commentsOf": .variable("publicationId")]]),
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
          .inlineFragment(AsComment.self),
        ] }

        public var asComment: AsComment? { _asInlineFragment() }

        /// Publications.Item.AsComment
        ///
        /// Parent Type: `Comment`
        public struct AsComment: LensProtocol.InlineFragment {
          public let __data: DataDict
          public init(data: DataDict) { __data = data }

          public static var __parentType: ParentType { LensProtocol.Objects.Comment }
          public static var __selections: [Selection] { [
            .field("id", LensProtocol.InternalPublicationId.self),
            .field("metadata", Metadata.self),
            .field("createdAt", LensProtocol.DateTime.self),
            .field("profile", Profile.self),
          ] }

          /// The internal publication id
          public var id: LensProtocol.InternalPublicationId { __data["id"] }
          /// The metadata for the post
          public var metadata: Metadata { __data["metadata"] }
          /// The date the post was created on
          public var createdAt: LensProtocol.DateTime { __data["createdAt"] }
          /// The profile ref
          public var profile: Profile { __data["profile"] }

          /// Publications.Item.AsComment.Metadata
          ///
          /// Parent Type: `MetadataOutput`
          public struct Metadata: LensProtocol.SelectionSet {
            public let __data: DataDict
            public init(data: DataDict) { __data = data }

            public static var __parentType: ParentType { LensProtocol.Objects.MetadataOutput }
            public static var __selections: [Selection] { [
              .field("content", LensProtocol.Markdown?.self),
            ] }

            /// This is the metadata content for the publication, should be markdown
            public var content: LensProtocol.Markdown? { __data["content"] }
          }

          /// Publications.Item.AsComment.Profile
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
    }
  }
}
