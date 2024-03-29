// To parse this JSON data, do
//
//     final instagramReelPrivate = instagramReelPrivateFromJson(jsonString);

import 'dart:convert';

InstagramReelPrivate instagramReelPrivateFromJson(String str) => InstagramReelPrivate.fromJson(json.decode(str));

String instagramReelPrivateToJson(InstagramReelPrivate data) => json.encode(data.toJson());

class InstagramReelPrivate {
  InstagramReelPrivate({
    this.graphql,
  });

  Graphql graphql;

  factory InstagramReelPrivate.fromJson(Map<String, dynamic> json) => InstagramReelPrivate(
    graphql: Graphql.fromJson(json["graphql"]),
  );

  Map<String, dynamic> toJson() => {
    "graphql": graphql.toJson(),
  };
}

class Graphql {
  Graphql({
    this.shortcodeMedia,
  });

  ShortcodeMedia shortcodeMedia;

  factory Graphql.fromJson(Map<String, dynamic> json) => Graphql(
    shortcodeMedia: ShortcodeMedia.fromJson(json["shortcode_media"]),
  );

  Map<String, dynamic> toJson() => {
    "shortcode_media": shortcodeMedia.toJson(),
  };
}

class ShortcodeMedia {
  ShortcodeMedia({
    this.typename,
    this.id,
    this.shortcode,
    this.dimensions,
    this.gatingInfo,
    this.factCheckOverallRating,
    this.factCheckInformation,
    this.sensitivityFrictionInfo,
    this.sharingFrictionInfo,
    this.mediaOverlayInfo,
    this.mediaPreview,
    this.displayUrl,
    this.displayResources,
    this.accessibilityCaption,
    this.dashInfo,
    this.hasAudio,
    this.videoUrl,
    this.videoViewCount,
    this.videoPlayCount,
    this.isVideo,
    this.trackingToken,
    this.edgeMediaToTaggedUser,
    this.edgeMediaToCaption,
    this.captionIsEdited,
    this.hasRankedComments,
    this.edgeMediaToParentComment,
    this.edgeMediaToHoistedComment,
    this.edgeMediaPreviewComment,
    this.commentsDisabled,
    this.commentingDisabledForViewer,
    this.takenAtTimestamp,
    this.edgeMediaPreviewLike,
    this.edgeMediaToSponsorUser,
    this.location,
    this.viewerHasLiked,
    this.viewerHasSaved,
    this.viewerHasSavedToCollection,
    this.viewerInPhotoOfYou,
    this.viewerCanReshare,
    this.owner,
    this.isAd,
    this.edgeWebMediaToRelatedMedia,
    this.encodingStatus,
    this.isPublished,
    this.productType,
    this.title,
    this.videoDuration,
    this.thumbnailSrc,
    this.clipsMusicAttributionInfo,
    this.edgeRelatedProfiles,
  });

  String typename;
  String id;
  String shortcode;
  Dimensions dimensions;
  dynamic gatingInfo;
  dynamic factCheckOverallRating;
  dynamic factCheckInformation;
  dynamic sensitivityFrictionInfo;
  SharingFrictionInfo sharingFrictionInfo;
  dynamic mediaOverlayInfo;
  String mediaPreview;
  String displayUrl;
  List<DisplayResource> displayResources;
  dynamic accessibilityCaption;
  DashInfo dashInfo;
  bool hasAudio;
  String videoUrl;
  int videoViewCount;
  int videoPlayCount;
  bool isVideo;
  String trackingToken;
  EdgeMediaToCaptionClass edgeMediaToTaggedUser;
  EdgeMediaToCaptionClass edgeMediaToCaption;
  bool captionIsEdited;
  bool hasRankedComments;
  EdgeMediaToParentCommentClass edgeMediaToParentComment;
  EdgeMediaToCaptionClass edgeMediaToHoistedComment;
  EdgeMediaPreviewComment edgeMediaPreviewComment;
  bool commentsDisabled;
  bool commentingDisabledForViewer;
  int takenAtTimestamp;
  EdgeMediaPreviewLike edgeMediaPreviewLike;
  EdgeMediaToCaptionClass edgeMediaToSponsorUser;
  dynamic location;
  bool viewerHasLiked;
  bool viewerHasSaved;
  bool viewerHasSavedToCollection;
  bool viewerInPhotoOfYou;
  bool viewerCanReshare;
  Owner owner;
  bool isAd;
  EdgeMediaToCaptionClass edgeWebMediaToRelatedMedia;
  dynamic encodingStatus;
  bool isPublished;
  String productType;
  String title;
  double videoDuration;
  String thumbnailSrc;
  ClipsMusicAttributionInfo clipsMusicAttributionInfo;
  EdgeMediaToCaptionClass edgeRelatedProfiles;

  factory ShortcodeMedia.fromJson(Map<String, dynamic> json) => ShortcodeMedia(
    typename: json["__typename"],
    id: json["id"],
    shortcode: json["shortcode"],
    dimensions: Dimensions.fromJson(json["dimensions"]),
    gatingInfo: json["gating_info"],
    factCheckOverallRating: json["fact_check_overall_rating"],
    factCheckInformation: json["fact_check_information"],
    sensitivityFrictionInfo: json["sensitivity_friction_info"],
    sharingFrictionInfo: SharingFrictionInfo.fromJson(json["sharing_friction_info"]),
    mediaOverlayInfo: json["media_overlay_info"],
    mediaPreview: json["media_preview"],
    displayUrl: json["display_url"],
    displayResources: List<DisplayResource>.from(json["display_resources"].map((x) => DisplayResource.fromJson(x))),
    accessibilityCaption: json["accessibility_caption"],
    dashInfo: DashInfo.fromJson(json["dash_info"]),
    hasAudio: json["has_audio"],
    videoUrl: json["video_url"],
    videoViewCount: json["video_view_count"],
    videoPlayCount: json["video_play_count"],
    isVideo: json["is_video"],
    trackingToken: json["tracking_token"],
    edgeMediaToTaggedUser: EdgeMediaToCaptionClass.fromJson(json["edge_media_to_tagged_user"]),
    edgeMediaToCaption: EdgeMediaToCaptionClass.fromJson(json["edge_media_to_caption"]),
    captionIsEdited: json["caption_is_edited"],
    hasRankedComments: json["has_ranked_comments"],
    edgeMediaToParentComment: EdgeMediaToParentCommentClass.fromJson(json["edge_media_to_parent_comment"]),
    edgeMediaToHoistedComment: EdgeMediaToCaptionClass.fromJson(json["edge_media_to_hoisted_comment"]),
    edgeMediaPreviewComment: EdgeMediaPreviewComment.fromJson(json["edge_media_preview_comment"]),
    commentsDisabled: json["comments_disabled"],
    commentingDisabledForViewer: json["commenting_disabled_for_viewer"],
    takenAtTimestamp: json["taken_at_timestamp"],
    edgeMediaPreviewLike: EdgeMediaPreviewLike.fromJson(json["edge_media_preview_like"]),
    edgeMediaToSponsorUser: EdgeMediaToCaptionClass.fromJson(json["edge_media_to_sponsor_user"]),
    location: json["location"],
    viewerHasLiked: json["viewer_has_liked"],
    viewerHasSaved: json["viewer_has_saved"],
    viewerHasSavedToCollection: json["viewer_has_saved_to_collection"],
    viewerInPhotoOfYou: json["viewer_in_photo_of_you"],
    viewerCanReshare: json["viewer_can_reshare"],
    owner: Owner.fromJson(json["owner"]),
    isAd: json["is_ad"],
    edgeWebMediaToRelatedMedia: EdgeMediaToCaptionClass.fromJson(json["edge_web_media_to_related_media"]),
    encodingStatus: json["encoding_status"],
    isPublished: json["is_published"],
    productType: json["product_type"],
    title: json["title"],
    videoDuration: json["video_duration"].toDouble(),
    thumbnailSrc: json["thumbnail_src"],
    clipsMusicAttributionInfo: ClipsMusicAttributionInfo.fromJson(json["clips_music_attribution_info"]),
    edgeRelatedProfiles: EdgeMediaToCaptionClass.fromJson(json["edge_related_profiles"]),
  );

  Map<String, dynamic> toJson() => {
    "__typename": typename,
    "id": id,
    "shortcode": shortcode,
    "dimensions": dimensions.toJson(),
    "gating_info": gatingInfo,
    "fact_check_overall_rating": factCheckOverallRating,
    "fact_check_information": factCheckInformation,
    "sensitivity_friction_info": sensitivityFrictionInfo,
    "sharing_friction_info": sharingFrictionInfo.toJson(),
    "media_overlay_info": mediaOverlayInfo,
    "media_preview": mediaPreview,
    "display_url": displayUrl,
    "display_resources": List<dynamic>.from(displayResources.map((x) => x.toJson())),
    "accessibility_caption": accessibilityCaption,
    "dash_info": dashInfo.toJson(),
    "has_audio": hasAudio,
    "video_url": videoUrl,
    "video_view_count": videoViewCount,
    "video_play_count": videoPlayCount,
    "is_video": isVideo,
    "tracking_token": trackingToken,
    "edge_media_to_tagged_user": edgeMediaToTaggedUser.toJson(),
    "edge_media_to_caption": edgeMediaToCaption.toJson(),
    "caption_is_edited": captionIsEdited,
    "has_ranked_comments": hasRankedComments,
    "edge_media_to_parent_comment": edgeMediaToParentComment.toJson(),
    "edge_media_to_hoisted_comment": edgeMediaToHoistedComment.toJson(),
    "edge_media_preview_comment": edgeMediaPreviewComment.toJson(),
    "comments_disabled": commentsDisabled,
    "commenting_disabled_for_viewer": commentingDisabledForViewer,
    "taken_at_timestamp": takenAtTimestamp,
    "edge_media_preview_like": edgeMediaPreviewLike.toJson(),
    "edge_media_to_sponsor_user": edgeMediaToSponsorUser.toJson(),
    "location": location,
    "viewer_has_liked": viewerHasLiked,
    "viewer_has_saved": viewerHasSaved,
    "viewer_has_saved_to_collection": viewerHasSavedToCollection,
    "viewer_in_photo_of_you": viewerInPhotoOfYou,
    "viewer_can_reshare": viewerCanReshare,
    "owner": owner.toJson(),
    "is_ad": isAd,
    "edge_web_media_to_related_media": edgeWebMediaToRelatedMedia.toJson(),
    "encoding_status": encodingStatus,
    "is_published": isPublished,
    "product_type": productType,
    "title": title,
    "video_duration": videoDuration,
    "thumbnail_src": thumbnailSrc,
    "clips_music_attribution_info": clipsMusicAttributionInfo.toJson(),
    "edge_related_profiles": edgeRelatedProfiles.toJson(),
  };
}

class ClipsMusicAttributionInfo {
  ClipsMusicAttributionInfo({
    this.artistName,
    this.songName,
    this.usesOriginalAudio,
    this.shouldMuteAudio,
  });

  String artistName;
  String songName;
  bool usesOriginalAudio;
  bool shouldMuteAudio;

  factory ClipsMusicAttributionInfo.fromJson(Map<String, dynamic> json) => ClipsMusicAttributionInfo(
    artistName: json["artist_name"],
    songName: json["song_name"],
    usesOriginalAudio: json["uses_original_audio"],
    shouldMuteAudio: json["should_mute_audio"],
  );

  Map<String, dynamic> toJson() => {
    "artist_name": artistName,
    "song_name": songName,
    "uses_original_audio": usesOriginalAudio,
    "should_mute_audio": shouldMuteAudio,
  };
}

class DashInfo {
  DashInfo({
    this.isDashEligible,
    this.videoDashManifest,
    this.numberOfQualities,
  });

  bool isDashEligible;
  String videoDashManifest;
  int numberOfQualities;

  factory DashInfo.fromJson(Map<String, dynamic> json) => DashInfo(
    isDashEligible: json["is_dash_eligible"],
    videoDashManifest: json["video_dash_manifest"],
    numberOfQualities: json["number_of_qualities"],
  );

  Map<String, dynamic> toJson() => {
    "is_dash_eligible": isDashEligible,
    "video_dash_manifest": videoDashManifest,
    "number_of_qualities": numberOfQualities,
  };
}

class Dimensions {
  Dimensions({
    this.height,
    this.width,
  });

  int height;
  int width;

  factory Dimensions.fromJson(Map<String, dynamic> json) => Dimensions(
    height: json["height"],
    width: json["width"],
  );

  Map<String, dynamic> toJson() => {
    "height": height,
    "width": width,
  };
}

class DisplayResource {
  DisplayResource({
    this.src,
    this.configWidth,
    this.configHeight,
  });

  String src;
  int configWidth;
  int configHeight;

  factory DisplayResource.fromJson(Map<String, dynamic> json) => DisplayResource(
    src: json["src"],
    configWidth: json["config_width"],
    configHeight: json["config_height"],
  );

  Map<String, dynamic> toJson() => {
    "src": src,
    "config_width": configWidth,
    "config_height": configHeight,
  };
}

class EdgeMediaPreviewComment {
  EdgeMediaPreviewComment({
    this.count,
    this.edges,
  });

  int count;
  List<EdgeMediaPreviewCommentEdge> edges;

  factory EdgeMediaPreviewComment.fromJson(Map<String, dynamic> json) => EdgeMediaPreviewComment(
    count: json["count"],
    edges: List<EdgeMediaPreviewCommentEdge>.from(json["edges"].map((x) => EdgeMediaPreviewCommentEdge.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "count": count,
    "edges": List<dynamic>.from(edges.map((x) => x.toJson())),
  };
}

class EdgeMediaToParentCommentClass {
  EdgeMediaToParentCommentClass({
    this.count,
    this.pageInfo,
    this.edges,
  });

  int count;
  PageInfo pageInfo;
  List<EdgeMediaPreviewCommentEdge> edges;

  factory EdgeMediaToParentCommentClass.fromJson(Map<String, dynamic> json) => EdgeMediaToParentCommentClass(
    count: json["count"],
    pageInfo: PageInfo.fromJson(json["page_info"]),
    edges: List<EdgeMediaPreviewCommentEdge>.from(json["edges"].map((x) => EdgeMediaPreviewCommentEdge.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "count": count,
    "page_info": pageInfo.toJson(),
    "edges": List<dynamic>.from(edges.map((x) => x.toJson())),
  };
}

class PurpleNode {
  PurpleNode({
    this.id,
    this.text,
    this.createdAt,
    this.didReportAsSpam,
    this.owner,
    this.viewerHasLiked,
    this.edgeLikedBy,
    this.isRestrictedPending,
    this.edgeThreadedComments,
  });

  String id;
  String text;
  int createdAt;
  bool didReportAsSpam;
  OwnerClass owner;
  bool viewerHasLiked;
  EdgeFollowedByClass edgeLikedBy;
  bool isRestrictedPending;
  EdgeMediaToParentCommentClass edgeThreadedComments;

  factory PurpleNode.fromJson(Map<String, dynamic> json) => PurpleNode(
    id: json["id"],
    text: json["text"],
    createdAt: json["created_at"],
    didReportAsSpam: json["did_report_as_spam"],
    owner: OwnerClass.fromJson(json["owner"]),
    viewerHasLiked: json["viewer_has_liked"],
    edgeLikedBy: EdgeFollowedByClass.fromJson(json["edge_liked_by"]),
    isRestrictedPending: json["is_restricted_pending"],
    edgeThreadedComments: json["edge_threaded_comments"] == null ? null : EdgeMediaToParentCommentClass.fromJson(json["edge_threaded_comments"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "text": text,
    "created_at": createdAt,
    "did_report_as_spam": didReportAsSpam,
    "owner": owner.toJson(),
    "viewer_has_liked": viewerHasLiked,
    "edge_liked_by": edgeLikedBy.toJson(),
    "is_restricted_pending": isRestrictedPending,
    "edge_threaded_comments": edgeThreadedComments == null ? null : edgeThreadedComments.toJson(),
  };
}

class EdgeMediaPreviewCommentEdge {
  EdgeMediaPreviewCommentEdge({
    this.node,
  });

  PurpleNode node;

  factory EdgeMediaPreviewCommentEdge.fromJson(Map<String, dynamic> json) => EdgeMediaPreviewCommentEdge(
    node: PurpleNode.fromJson(json["node"]),
  );

  Map<String, dynamic> toJson() => {
    "node": node.toJson(),
  };
}

class PageInfo {
  PageInfo({
    this.hasNextPage,
    this.endCursor,
  });

  bool hasNextPage;
  String endCursor;

  factory PageInfo.fromJson(Map<String, dynamic> json) => PageInfo(
    hasNextPage: json["has_next_page"],
    endCursor: json["end_cursor"] == null ? null : json["end_cursor"],
  );

  Map<String, dynamic> toJson() => {
    "has_next_page": hasNextPage,
    "end_cursor": endCursor == null ? null : endCursor,
  };
}

class EdgeFollowedByClass {
  EdgeFollowedByClass({
    this.count,
  });

  int count;

  factory EdgeFollowedByClass.fromJson(Map<String, dynamic> json) => EdgeFollowedByClass(
    count: json["count"],
  );

  Map<String, dynamic> toJson() => {
    "count": count,
  };
}

class OwnerClass {
  OwnerClass({
    this.id,
    this.isVerified,
    this.profilePicUrl,
    this.username,
  });

  String id;
  bool isVerified;
  String profilePicUrl;
  String username;

  factory OwnerClass.fromJson(Map<String, dynamic> json) => OwnerClass(
    id: json["id"],
    isVerified: json["is_verified"],
    profilePicUrl: json["profile_pic_url"],
    username: json["username"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "is_verified": isVerified,
    "profile_pic_url": profilePicUrl,
    "username": username,
  };
}

class EdgeMediaPreviewLike {
  EdgeMediaPreviewLike({
    this.count,
    this.edges,
  });

  int count;
  List<EdgeMediaPreviewLikeEdge> edges;

  factory EdgeMediaPreviewLike.fromJson(Map<String, dynamic> json) => EdgeMediaPreviewLike(
    count: json["count"],
    edges: List<EdgeMediaPreviewLikeEdge>.from(json["edges"].map((x) => EdgeMediaPreviewLikeEdge.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "count": count,
    "edges": List<dynamic>.from(edges.map((x) => x.toJson())),
  };
}

class EdgeMediaPreviewLikeEdge {
  EdgeMediaPreviewLikeEdge({
    this.node,
  });

  OwnerClass node;

  factory EdgeMediaPreviewLikeEdge.fromJson(Map<String, dynamic> json) => EdgeMediaPreviewLikeEdge(
    node: OwnerClass.fromJson(json["node"]),
  );

  Map<String, dynamic> toJson() => {
    "node": node.toJson(),
  };
}

class EdgeMediaToCaptionClass {
  EdgeMediaToCaptionClass({
    this.edges,
  });

  List<EdgeMediaToCaptionEdge> edges;

  factory EdgeMediaToCaptionClass.fromJson(Map<String, dynamic> json) => EdgeMediaToCaptionClass(
    edges: List<EdgeMediaToCaptionEdge>.from(json["edges"].map((x) => EdgeMediaToCaptionEdge.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "edges": List<dynamic>.from(edges.map((x) => x.toJson())),
  };
}

class EdgeMediaToCaptionEdge {
  EdgeMediaToCaptionEdge({
    this.node,
  });

  FluffyNode node;

  factory EdgeMediaToCaptionEdge.fromJson(Map<String, dynamic> json) => EdgeMediaToCaptionEdge(
    node: FluffyNode.fromJson(json["node"]),
  );

  Map<String, dynamic> toJson() => {
    "node": node.toJson(),
  };
}

class FluffyNode {
  FluffyNode({
    this.text,
  });

  String text;

  factory FluffyNode.fromJson(Map<String, dynamic> json) => FluffyNode(
    text: json["text"],
  );

  Map<String, dynamic> toJson() => {
    "text": text,
  };
}

class Owner {
  Owner({
    this.id,
    this.isVerified,
    this.profilePicUrl,
    this.username,
    this.blockedByViewer,
    this.restrictedByViewer,
    this.followedByViewer,
    this.fullName,
    this.hasBlockedViewer,
    this.isPrivate,
    this.isUnpublished,
    this.requestedByViewer,
    this.passTieringRecommendation,
    this.edgeOwnerToTimelineMedia,
    this.edgeFollowedBy,
  });

  String id;
  bool isVerified;
  String profilePicUrl;
  String username;
  bool blockedByViewer;
  bool restrictedByViewer;
  bool followedByViewer;
  String fullName;
  bool hasBlockedViewer;
  bool isPrivate;
  bool isUnpublished;
  bool requestedByViewer;
  bool passTieringRecommendation;
  EdgeFollowedByClass edgeOwnerToTimelineMedia;
  EdgeFollowedByClass edgeFollowedBy;

  factory Owner.fromJson(Map<String, dynamic> json) => Owner(
    id: json["id"],
    isVerified: json["is_verified"],
    profilePicUrl: json["profile_pic_url"],
    username: json["username"],
    blockedByViewer: json["blocked_by_viewer"],
    restrictedByViewer: json["restricted_by_viewer"],
    followedByViewer: json["followed_by_viewer"],
    fullName: json["full_name"],
    hasBlockedViewer: json["has_blocked_viewer"],
    isPrivate: json["is_private"],
    isUnpublished: json["is_unpublished"],
    requestedByViewer: json["requested_by_viewer"],
    passTieringRecommendation: json["pass_tiering_recommendation"],
    edgeOwnerToTimelineMedia: EdgeFollowedByClass.fromJson(json["edge_owner_to_timeline_media"]),
    edgeFollowedBy: EdgeFollowedByClass.fromJson(json["edge_followed_by"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "is_verified": isVerified,
    "profile_pic_url": profilePicUrl,
    "username": username,
    "blocked_by_viewer": blockedByViewer,
    "restricted_by_viewer": restrictedByViewer,
    "followed_by_viewer": followedByViewer,
    "full_name": fullName,
    "has_blocked_viewer": hasBlockedViewer,
    "is_private": isPrivate,
    "is_unpublished": isUnpublished,
    "requested_by_viewer": requestedByViewer,
    "pass_tiering_recommendation": passTieringRecommendation,
    "edge_owner_to_timeline_media": edgeOwnerToTimelineMedia.toJson(),
    "edge_followed_by": edgeFollowedBy.toJson(),
  };
}

class SharingFrictionInfo {
  SharingFrictionInfo({
    this.shouldHaveSharingFriction,
    this.bloksAppUrl,
  });

  bool shouldHaveSharingFriction;
  dynamic bloksAppUrl;

  factory SharingFrictionInfo.fromJson(Map<String, dynamic> json) => SharingFrictionInfo(
    shouldHaveSharingFriction: json["should_have_sharing_friction"],
    bloksAppUrl: json["bloks_app_url"],
  );

  Map<String, dynamic> toJson() => {
    "should_have_sharing_friction": shouldHaveSharingFriction,
    "bloks_app_url": bloksAppUrl,
  };
}
