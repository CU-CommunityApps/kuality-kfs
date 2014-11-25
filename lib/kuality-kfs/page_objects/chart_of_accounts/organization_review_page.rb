class OrganizationReviewPage < KFSBasePage

  element(:chart_code) { |b| b.frm.select(name: 'document.newMaintainableObject.chartOfAccountsCode') }
  element(:organization_code) { |b| b.frm.text_field(name: 'document.newMaintainableObject.organizationCode') }
  element(:doc_type) { |b| b.frm.text_field(name: 'document.newMaintainableObject.financialSystemDocumentTypeCode') }
  element(:review_types) { |b| b.frm.radio(name: 'document.newMaintainableObject.reviewRolesIndicator') }
  element(:from_amount) { |b| b.frm.text_field(name: 'document.newMaintainableObject.fromAmount') }
  element(:to_amount) { |b| b.frm.text_field(name: 'document.newMaintainableObject.toAmount') }
  element(:accounting_line_override_code) { |b| b.frm.select(name: 'document.newMaintainableObject.overrideCode') }
  element(:principal_name) { |b| b.frm.text_field(name: 'document.newMaintainableObject.principalMemberPrincipalName') }
  element(:namespace) { |b| b.frm.select(name: 'document.newMaintainableObject.roleMemberRoleNamespaceCode') }
  element(:role_name) { |b| b.frm.text_field(name: 'document.newMaintainableObject.roleMemberRoleName') }
  element(:group_namespace) { |b| b.frm.select(name: 'document.newMaintainableObject.groupMemberGroupNamespaceCode') }
  element(:group_name) { |b| b.frm.text_field(name: 'document.newMaintainableObject.groupMemberGroupName') }
  element(:action_type_code) { |b| b.frm.select(name: 'document.newMaintainableObject.actionTypeCode') }
  element(:priority_number) { |b| b.frm.text_field(name: 'document.newMaintainableObject.priorityNumber') }
  element(:action_policy_code) { |b| b.frm.select(name: 'document.newMaintainableObject.actionPolicyCode') }
  element(:force_action) { |b| b.frm.checkbox(name: 'document.newMaintainableObject.forceAction') }
  element(:action_from_date) { |b| b.frm.text_field(name: 'document.newMaintainableObject.activeFromDate') }
  element(:action_to_date) { |b| b.frm.text_field(name: 'document.newMaintainableObject.activeToDate') }

  action(:document_type_search) { |b| b.frm.button(title: 'Search Document Type').click }
  action(:principal_search) { |b| b.frm.button(title: 'Search Principal Name').click }

  value(:chart_code_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.chartOfAccountsCode.div').text.strip }
  value(:organization_code_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.organizationCode.div').text.strip }
  value(:doc_type_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.financialSystemDocumentTypeCode.div').text.strip }
  value(:review_types_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.reviewRolesIndicator.div').text.strip }
  value(:from_amount_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.fromAmount.div').text.strip }
  value(:to_amount_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.toAmount.div').text.strip }
  value(:accounting_line_override_code_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.overrideCode.div').text.strip }
  value(:principal_name_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.principalMemberPrincipalName.div').text.strip }
  value(:namespace_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.roleMemberRoleNamespaceCode.div').text.strip }
  value(:role_name_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.roleMemberRoleName.div').text.strip }
  value(:group_namespace_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.groupMemberGroupNamespaceCode.div').text.strip }
  value(:group_name_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.groupMemberGroupName.div').text.strip }
  value(:action_type_code_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.actionTypeCode.div').text.strip }
  value(:priority_number_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.priorityNumber.div').text.strip }
  value(:action_policy_code_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.actionPolicyCode.div').text.strip }
  value(:force_action_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.forceAction.div').text.strip }
  value(:action_from_date_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.activeFromDate.div').text.strip }
  value(:action_to_date_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.activeToDate.div').text.strip }

  value(:chart_code_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.chartOfAccountsCode.div').text.strip }
  value(:organization_code_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.organizationCode.div').text.strip }
  value(:doc_type_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.financialSystemDocumentTypeCode.div').text.strip }
  value(:review_types_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.reviewRolesIndicator.div').text.strip }
  value(:from_amount_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.fromAmount.div').text.strip }
  value(:to_amount_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.toAmount.div').text.strip }
  value(:accounting_line_override_code_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.overrideCode.div').text.strip }
  value(:principal_name_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.principalMemberPrincipalName.div').text.strip }
  value(:namespace_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.roleMemberRoleNamespaceCode.div').text.strip }
  value(:role_name_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.roleMemberRoleName.div').text.strip }
  value(:group_namespace_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.groupMemberGroupNamespaceCode.div').text.strip }
  value(:group_name_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.groupMemberGroupName.div').text.strip }
  value(:action_type_code_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.actionTypeCode.div').text.strip }
  value(:priority_number_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.priorityNumber.div').text.strip }
  value(:action_policy_code_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.actionPolicyCode.div').text.strip }
  value(:force_action_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.forceAction.div').text.strip }
  value(:action_from_date_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.activeFromDate.div').text.strip }
  value(:action_to_date_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.activeToDate.div').text.strip }

  value(:chart_code_new) { |b| b.chart_code.exists? ? b.chart_code.value : b.chart_code_readonly }
  value(:organization_code_new) { |b| b.organization_code.exists? ? b.organization_code.value : b.organization_code_readonly }
  value(:doc_type_new) { |b| b.doc_type.exists? ? b.doc_type.value : b.doc_type_readonly }
  value(:review_types_new) { |b| b.review_types.exists? ? b.review_types.value : b.review_types_readonly }
  value(:from_amount_new) { |b| b.from_amount.exists? ? b.from_amount.value : b.from_amount_readonly }
  value(:to_amount_new) { |b| b.to_amount.exists? ? b.to_amount.value : b.to_amount_readonly }
  value(:accounting_line_override_code_new) { |b| b.accounting_line_override_code.exists? ? b.accounting_line_override_code.value : b.accounting_line_override_code_readonly }
  value(:principal_name_new) { |b| b.principal_name.exists? ? b.principal_name.value : b.principal_name_readonly }
  value(:namespace_new) { |b| b.namespace.exists? ? b.namespace.selected_options.first.text : b.namespace_readonly }
  value(:role_name_new) { |b| b.role_name.exists? ? b.role_name.value : b.role_name_readonly }
  value(:group_namespace_new) { |b| b.group_namespace.exists? ? b.group_namespace.selected_options.first.text : b.group_namespace_readonly }
  value(:group_name_new) { |b| b.group_name.exists? ? b.group_name.value : b.group_name_readonly }
  value(:action_type_code_new) { |b| b.action_type_code.exists? ? b.action_type_code.selected_options.first.text : b.action_type_code_readonly }
  value(:priority_number_new) { |b| b.priority_number.exists? ? b.priority_number.value : b.priority_number_readonly }
  value(:action_policy_code_new) { |b| b.action_policy_code.exists? ? b.action_policy_code.selected_options.first.text : b.action_policy_code_readonly }
  value(:force_action_new) { |b| b.force_action.exists? ? b.force_action.value : b.force_action_readonly }
  value(:action_from_date_new) { |b| b.action_from_date.exists? ? b.action_from_date.value : b.action_from_date_readonly }
  value(:action_to_date_new) { |b| b.action_to_date.exists? ? b.action_to_date.value : b.action_to_date_readonly }

end