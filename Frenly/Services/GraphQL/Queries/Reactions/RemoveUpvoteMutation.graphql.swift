// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
import LensProtocol

public class RemoveUpvoteMutation: GraphQLMutation {
  public static let operationName: String = "RemoveUpvote"
  public static let document: DocumentType = .notPersisted(
    definition: .init(
      """
      mutation RemoveUpvote($profileId: ProfileId!, $publicationId: InternalPublicationId!) {
        removeReaction(
          request: {profileId: $profileId, reaction: UPVOTE, publicationId: $publicationId}
        )
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
      .field("removeReaction", LensProtocol.Void?.self, arguments: ["request": [
        "profileId": .variable("profileId"),
        "reaction": "UPVOTE",
        "publicationId": .variable("publicationId")
      ]]),
    ] }

    public var removeReaction: LensProtocol.Void? { __data["removeReaction"] }
  }
}
