// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_ticket_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateIssueModel _$CreateIssueModelFromJson(Map<String, dynamic> json) =>
    CreateIssueModel(
      name: json['name'] as String,
      owner: json['owner'] as String,
      creation: json['creation'] as String,
      modified: json['modified'] as String,
      modifiedBy: json['modified_by'] as String,
      docstatus: json['docstatus'] as int,
      idx: json['idx'] as int,
      namingSeries: json['naming_series'] as String,
      subject: json['subject'] as String,
      customer: json['customer'] as String,
      customCustomerNumber: json['custom_customer_number'] as String,
      lead: json['lead'] as String,
      raisedBy: json['raised_by'] as String,
      status: json['status'] as String,
      customExtendedWarrantyStatus:
          json['custom_extended_warranty_status_'] as String,
      priority: json['priority'] as String,
      customIssueSource: json['custom_issue_source'] as String,
      customTicketBroadCategory: json['custom_ticket_broad_category'] as String,
      customTicketType: json['custom_ticket_type'] as String,
      customTicketCategory: json['custom_ticket_catgeory'] as String,
      customTicketItem: json['custom_ticket_item'] as String,
      description: json['description'] as String,
      agreementStatus: json['agreement_status'] as String,
      resolutionDetails: json['resolution_details'] as String,
      openingDate: json['opening_date'] as String,
      openingTime: json['opening_time'] as String,
      company: json['company'] as String,
      viaCustomerPortal: json['via_customer_portal'] as int,
      docType: json['doctype'] as String,
    );

Map<String, dynamic> _$CreateIssueModelToJson(CreateIssueModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'owner': instance.owner,
      'creation': instance.creation,
      'modified': instance.modified,
      'modified_by': instance.modifiedBy,
      'docstatus': instance.docstatus,
      'idx': instance.idx,
      'naming_series': instance.namingSeries,
      'subject': instance.subject,
      'customer': instance.customer,
      'custom_customer_number': instance.customCustomerNumber,
      'lead': instance.lead,
      'raised_by': instance.raisedBy,
      'status': instance.status,
      'custom_extended_warranty_status_': instance.customExtendedWarrantyStatus,
      'priority': instance.priority,
      'custom_issue_source': instance.customIssueSource,
      'custom_ticket_broad_category': instance.customTicketBroadCategory,
      'custom_ticket_type': instance.customTicketType,
      'custom_ticket_catgeory': instance.customTicketCategory,
      'custom_ticket_item': instance.customTicketItem,
      'description': instance.description,
      'agreement_status': instance.agreementStatus,
      'resolution_details': instance.resolutionDetails,
      'opening_date': instance.openingDate,
      'opening_time': instance.openingTime,
      'company': instance.company,
      'via_customer_portal': instance.viaCustomerPortal,
      'doctype': instance.docType,
    };
