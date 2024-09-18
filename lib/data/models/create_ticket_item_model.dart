import 'package:json_annotation/json_annotation.dart';

part 'create_ticket_item_model.g.dart';

@JsonSerializable()
class CreateIssueModel {
  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'owner')
  final String owner;

  @JsonKey(name: 'creation')
  final String creation;

  @JsonKey(name: 'modified')
  final String modified;

  @JsonKey(name: 'modified_by')
  final String modifiedBy;

  @JsonKey(name: 'docstatus')
  final int docstatus;

  @JsonKey(name: 'idx')
  final int idx;

  @JsonKey(name: 'naming_series')
  final String namingSeries;

  @JsonKey(name: 'subject')
  final String subject;

  @JsonKey(name: 'customer')
  final String customer;

  @JsonKey(name: 'custom_customer_number')
  final String customCustomerNumber;

  @JsonKey(name: 'lead')
  final String lead;

  @JsonKey(name: 'raised_by')
  final String raisedBy;

  @JsonKey(name: 'status')
  final String status;

  @JsonKey(name: 'custom_extended_warranty_status_')
  final String customExtendedWarrantyStatus;

  @JsonKey(name: 'priority')
  final String priority;

  @JsonKey(name: 'custom_issue_source')
  final String customIssueSource;

  @JsonKey(name: 'custom_ticket_broad_category')
  final String customTicketBroadCategory;

  @JsonKey(name: 'custom_ticket_type')
  final String customTicketType;

  @JsonKey(name: 'custom_ticket_catgeory')
  final String customTicketCategory;

  @JsonKey(name: 'custom_ticket_item')
  final String customTicketItem;

  @JsonKey(name: 'description')
  final String description;

  @JsonKey(name: 'agreement_status')
  final String agreementStatus;

  @JsonKey(name: 'resolution_details')
  final String resolutionDetails;

  @JsonKey(name: 'opening_date')
  final String openingDate;

  @JsonKey(name: 'opening_time')
  final String openingTime;

  @JsonKey(name: 'company')
  final String company;

  @JsonKey(name: 'via_customer_portal')
  final int viaCustomerPortal;

  @JsonKey(name: 'doctype')
  final String docType;

  CreateIssueModel({
    required this.name,
    required this.owner,
    required this.creation,
    required this.modified,
    required this.modifiedBy,
    required this.docstatus,
    required this.idx,
    required this.namingSeries,
    required this.subject,
    required this.customer,
    required this.customCustomerNumber,
    required this.lead,
    required this.raisedBy,
    required this.status,
    required this.customExtendedWarrantyStatus,
    required this.priority,
    required this.customIssueSource,
    required this.customTicketBroadCategory,
    required this.customTicketType,
    required this.customTicketCategory,
    required this.customTicketItem,
    required this.description,
    required this.agreementStatus,
    required this.resolutionDetails,
    required this.openingDate,
    required this.openingTime,
    required this.company,
    required this.viaCustomerPortal,
    required this.docType,
  });

  factory CreateIssueModel.fromJson(Map<String, dynamic> json) => _$CreateIssueModelFromJson(json);
  Map<String, dynamic> toJson() => _$CreateIssueModelToJson(this);
}
