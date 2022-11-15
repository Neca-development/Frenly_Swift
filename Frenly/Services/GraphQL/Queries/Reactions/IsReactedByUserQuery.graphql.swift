// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
import LensProtocol

public class IsReactedByUserQuery: GraphQLQuery {
  public static let operationName: String = "IsReactedByUser"
  public static let document: DocumentType = .notPersisted(
    definition: .init(
      """
      query IsReactedByUser($publicationId: InternalPublicationId!, $profileId: ProfileId!) {
        publication(request: {publicationId: $publicationId}) {
          __typename
          ... on Post {
            reaction(request: {profileId: $profileId})
          }
          ... on Mirror {
            reaction(request: {profileId: $profileId})
          }
        }
      }
      """
    ))

  public var publicationId: LensProtocol.InternalPublicationId
  public var profileId: LensProtocol.ProfileId

  public init(
    publicationId: LensProtocol.InternalPublicationId,
    profileId: LensProtocol.ProfileId
  ) {
    self.publicationId = publicationId
    self.profileId = profileId
  }

  public var __variables: Variables? { [
    "publicationId": publicationId,
    "profileId": profileId
  ] }

  public struct Data: LensProtocol.SelectionSet {
    public let __data: DataDict
    public init(data: DataDict) { __data = data }

    public static var __parentType: ParentType { LensProtocol.Objects.Query }
    public static var __selections: [Selection] { [
      .field("publication", Publication?.self, arguments: ["request": ["publicationId": .variable("publicationId")]]),
    ] }

    public var publication: Publication? { __data["publication"] }

    /// Publication
    ///
    /// Parent Type: `Publication`
    public struct Publication: LensProtocol.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ParentType { LensProtocol.Unions.Publication }
      public static var __selections: [Selection] { [
        .inlineFragment(AsPost.self),
        .inlineFragment(AsMirror.self),
      ] }

      public var asPost: AsPost? { _asInlineFragment() }
      public var asMirror: AsMirror? { _asInlineFragment() }

      /// Publication.AsPost
      ///
      /// Parent Type: `Post`
      public struct AsPost: LensProtocol.InlineFragment {
        public let __data: DataDict
        public init(data: DataDict) { __data = data }

        public static var __parentType: ParentType { LensProtocol.Objects.Post }
        public static var __selections: [Selection] { [
          .field("reaction", GraphQLEnum<LensProtocol.ReactionTypes>?.self, arguments: ["request": ["profileId": .variable("profileId")]]),
        ] }

        public var reaction: GraphQLEnum<LensProtocol.ReactionTypes>? { __data["reaction"] }
      }

      /// Publication.AsMirror
      ///
      /// Parent Type: `Mirror`
      public struct AsMirror: LensProtocol.InlineFragment {
        public let __data: DataDict
        public init(data: DataDict) { __data = data }

        public static var __parentType: ParentType { LensProtocol.Objects.Mirror }
        public static var __selections: [Selection] { [
          .field("reaction", GraphQLEnum<LensProtocol.ReactionTypes>?.self, arguments: ["request": ["profileId": .variable("profileId")]]),
        ] }

        public var reaction: GraphQLEnum<LensProtocol.ReactionTypes>? { __data["reaction"] }
      }
    }
  }
}
