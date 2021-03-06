When /^I start a General Error Correction document$/ do
  @general_error_correction = create GeneralErrorCorrectionObject
end

When /^I start an empty General Error Correction document$/ do
  @general_error_correction = create GeneralErrorCorrectionObject
end


And /^I add an Accounting Line to the General Error Correction document with "Account Expired Override" selected$/ do
  on GeneralErrorCorrectionPage do
    @general_error_correction.add_source_line({
        chart_code:               @account.chart_code,
        account_number:           @account.number,
        object:                   '4480',
        reference_origin_code:    '01',
        reference_number:         '777001',
        amount:                   '25000.11',
        account_expired_override: :set
    })
    @general_error_correction.add_target_line({
        chart_code:               @account.chart_code,
        account_number:           @account.number,
        object:                   '4480',
        reference_origin_code:    '01',
        reference_number:         '777002',
        amount:                   '25000.11',
        account_expired_override: :set
    })
  end
end
