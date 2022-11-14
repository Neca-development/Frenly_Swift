// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
import LensProtocol

public class GetPublicationIdByMirrorIdQuery: GraphQLQuery {
  public static let operationName: String = "GetPublicationIdByMirrorId"
  public static let document: DocumentType = .notPersisted(
    definition: .init(
      """
      query GetPublicationIdByMirrorId($mirrorId: InternalPublicationId!) {
        publication(request: {publicationId: $mirrorId}) {
          __typename
          ... on Mirror {
            mirrorOf {
              __typename
              ... on Post {
                id
              }
            }
          }
        }
      }
      """
    ))

  public var mirrorId: LensProtocol.InternalPublicationId

  public init(mirrorId: LensProtocol.InternalPublicationId) {
    self.mirrorId = mirrorId
  }

  public var __variables: Variables? { ["mirrorId": mirrorId] }

  public struct Data: LensProtocol.SelectionSet {
    public let __data: DataDict
    public init(data: DataDict) { __data = data }

    public static var __parentType: ParentType { LensProtocol.Objects.Query }
    public static var __selections: [Selection] { [
      .field("publication", Publication?.self, arguments: ["request": ["publicationId": .variable("mirrorId")]]),
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
        .inlineFragment(AsMirror.self),
      ] }

      public var asMirror: AsMirror? { _asInlineFragment() }

      /// Publication.AsMirror
      ///
      /// Parent Type: `Mirror`
      public struct AsMirror: LensProtocol.InlineFragment {
        public let __data: DataDict
        public init(data: DataDict) { __data = data }

        public static var __parentType: ParentType { LensProtocol.Objects.Mirror }
        public static var __selections: [Selection] { [
          .field("mirrorOf", MirrorOf.self),
        ] }

        /// The mirror publication
        public var mirrorOf: MirrorOf { __data["mirrorOf"] }

        /// Publication.AsMirror.MirrorOf
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

          /// Publication.AsMirror.MirrorOf.AsPost
          ///
          /// Parent Type: `Post`
          public struct AsPost: LensProtocol.InlineFragment {
            public let __data: DataDict
            public init(data: DataDict) { __data = data }

            public static var __parentType: ParentType { LensProtocol.Objects.Post }
            public static var __selections: [Selection] { [
              .field("id", LensProtocol.InternalPublicationId.self),
            ] }

            /// The internal publication id
            public var id: LensProtocol.InternalPublicationId { __data["id"] }
          }
        }
      }
    }
  }
}
