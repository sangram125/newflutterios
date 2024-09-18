import 'package:json_annotation/json_annotation.dart';

part 'get_issue_item_model.g.dart';

@JsonSerializable()
class GetIssueItemModel {
  final List<Issue> data;

  GetIssueItemModel({required this.data});

  factory GetIssueItemModel.fromJson(Map<String, dynamic> json) =>
      _$GetIssueItemModelFromJson(json);
  Map<String, dynamic> toJson() => _$GetIssueItemModelToJson(this);
}

@JsonSerializable()
class Issue {
  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'owner')
  final String? owner;

  @JsonKey(name: 'creation')
  final String? creation;

  @JsonKey(name: 'modified')
  final String? modified;

  @JsonKey(name: 'modified_by')
  final String? modifiedBy;

  @JsonKey(name: 'docstatus')
  final int? docstatus;

  @JsonKey(name: 'idx')
  final int? idx;

  @JsonKey(name: 'naming_series')
  final String? namingSeries;

  @JsonKey(name: 'subject')
  final String? subject;

  @JsonKey(name: 'customer')
  final String? customer;

  @JsonKey(name: 'custom_customer_number')
  final String? customCustomerNumber;

  @JsonKey(name: 'lead')
  final String? lead;

  @JsonKey(name: 'raised_by')
  final String? raisedBy;

  @JsonKey(name: 'status')
  final String? status;

  @JsonKey(name: 'custom_extended_warranty_status_')
  final String? customExtendedWarrantyStatus;

  @JsonKey(name: 'priority')
  final String? priority;

  @JsonKey(name: 'custom_issue_source')
  final String? customIssueSource;

  @JsonKey(name: 'custom_ticket_broad_category')
  final String? customTicketBroadCategory;

  @JsonKey(name: 'custom_ticket_type')
  final String? customTicketType;

  @JsonKey(name: 'custom_ticket_catgeory')
  final String? customTicketCategory;

  @JsonKey(name: 'custom_ticket_item')
  final String? customTicketItem;

  @JsonKey(name: 'description')
  final String? description;

  @JsonKey(name: 'agreement_status')
  final String? agreementStatus;

  @JsonKey(name: 'resolution_details')
  final String? resolutionDetails;

  @JsonKey(name: 'opening_date')
  final String? openingDate;

  @JsonKey(name: 'opening_time')
  final String? openingTime;

  @JsonKey(name: 'company')
  final String? company;

  @JsonKey(name: 'via_customer_portal')
  final int? viaCustomerPortal;

  @JsonKey(name: 'doctype')
  final String? docType;

  @JsonKey(name: 'resolution_date')
  final String? resolutionDate;

  @JsonKey(name: 'resolution_time')
  final String? resolutionTime;

  @JsonKey(name: 'user_resolution_time')
  final String? userResolutionTime;

  @JsonKey(name: 'contact')
  final String? contact;

  @JsonKey(name: 'email_account')
  final String? emailAccount;

  @JsonKey(name: 'customer_name')
  final String? customerName;

  @JsonKey(name: 'project')
  final String? project;

  @JsonKey(name: 'attachment')
  final String? attachment;

  @JsonKey(name: 'content_type')
  final String? contentType;

  @JsonKey( name: 'resolution_by')
  final String? resolutionBy;


  Issue(
    this.resolutionBy, {
    this.name,
    this.owner,
    this.creation,
    this.modified,
    this.modifiedBy,
    this.docstatus,
    this.idx,
    this.namingSeries,
    this.subject,
    this.customer,
    this.customCustomerNumber,
    this.lead,
    this.raisedBy,
    this.status,
    this.customExtendedWarrantyStatus,
    this.priority,
    this.customIssueSource,
    this.customTicketBroadCategory,
    this.customTicketType,
    this.customTicketCategory,
    this.customTicketItem,
    this.description,
    this.agreementStatus,
    this.resolutionDetails,
    this.openingDate,
    this.openingTime,
    this.company,
    this.viaCustomerPortal,
    this.docType,
    this.resolutionDate,
    this.resolutionTime,
    this.userResolutionTime,
    this.contact,
    this.emailAccount,
    this.customerName,
    this.project,
    this.attachment,
    this.contentType,
  });

  factory Issue.fromJson(Map<String, dynamic> json) => _$IssueFromJson(json);
  Map<String, dynamic> toJson() => _$IssueToJson(this);
}
