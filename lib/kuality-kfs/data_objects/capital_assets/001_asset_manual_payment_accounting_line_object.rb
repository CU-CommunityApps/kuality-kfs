class AssetManualPaymentAccountingLineObject < AccountingLineObject

  attr_accessor :purchase_order_number, :requisition_number, :origination_code,
                :document_number, :document_type_code, :posted_date

  # Currently, #create doesn't really interact with the page because items are
  # added to this collection through search pages; therefore, we are just
  # absorbing the new data from the page.
  def create
    on AccountingLine do |page|
      mappings = {
          "#{@type}_chart_code".to_sym                 => @chart_code,
          "#{@type}_account_number".to_sym             => @account_number,
          "#{@type}_sub_account_code".to_sym           => @sub_account,
          "#{@type}_sub_object_code".to_sym            => @sub_object,
          "#{@type}_project_code".to_sym               => @project,
          "#{@type}_organization_reference_id".to_sym  => @org_ref_id,
          "#{@type}_amount".to_sym                     => @amount,
      }
      mappings.merge!({"#{@type}_object_code".to_sym => @object}) unless @object.nil?
      mappings.merge!({"#{@type}_purchase_order_number".to_sym => @purchase_order_number}) unless @purchase_order_number.nil?
      mappings.merge!({"#{@type}_requisition_number".to_sym => @requisition_number}) unless @requisition_number.nil?
      mappings.merge!({"#{@type}_origination_code".to_sym => @origination_code}) unless @origination_code.nil?
      mappings.merge!({"#{@type}_document_number".to_sym => @document_number}) unless @document_number.nil?
      mappings.merge!({"#{@type}_document_type_code".to_sym => @document_type_code}) unless @document_type_code.nil?
      mappings.merge!({"#{@type}_posted_date".to_sym => @posted_date}) unless @posted_date.nil?
      mappings.merge!(extended_create_mappings)
      fill_out_extended_attributes
    end
  end

  def extended_update_mappings
    mappings = Hash.new
    mappings.merge!({"update_#{@type}_purchase_order_number".to_sym => opts[:purchase_order_number]}) unless opts[:purchase_order_number].nil?
    mappings.merge!({"update_#{@type}_requisition_number".to_sym => opts[:requisition_number]}) unless opts[:requisition_number].nil?
    mappings.merge!({"update_#{@type}_origination_code".to_sym => opts[:origination_code]}) unless opts[:origination_code].nil?
    mappings.merge!({"update_#{@type}_document_number".to_sym => opts[:document_number]}) unless opts[:document_number].nil?
    mappings.merge!({"update_#{@type}_document_type_code".to_sym => opts[:document_type_code]}) unless opts[:document_type_code].nil?
    mappings.merge!({"update_#{@type}_posted_date".to_sym => opts[:posted_date]}) unless opts[:posted_date].nil?
    mappings
  end

end

class AssetManualPaymentAccountingLineObjectCollection < AccountingLineObjectCollection

  contains AssetManualPaymentAccountingLineObject

  # @param [Symbol] type The type of line to import (source) as this edoc only has source lines. You may want to use AccountingLineObject#get_type_conversion
  # @param [Fixnum] i The line number to look for (zero-based)
  def pull_existing_line_values(type, i)
    on AccountingLine do |lines|
      super.merge({
                      purchase_order_number:  (lines.update_purchase_order_number(type, i).value  if lines.update_purchase_order_number(type, i).exists?),
                      requisition_number:     (lines.update_requisition_number(type, i).value  if lines.update_requisition_numbern(type, i).exists?),
                      origination_code:       (lines.update_origination_code(type, i).value  if lines.update_origination_code(type, i).exists?),
                      document_number:        (lines.update_document_number(type, i).value  if lines.update_document_number(type, i).exists?),
                      document_type_code:     (lines.update_document_type_code(type, i).value  if lines.update_document_type_code(type, i).exists?),
                      posted_date:            (lines.update_posted_date(type, i).value  if lines.update_posted_date(type, i).exists?),
                  })
      .merge(pull_asset_manual_payment_extended_existing_line_values(type, i))
    end
  end

  # @param [Symbol] type The type of line to import (source) as this edoc only has source lines. You may want to use AccountingLineObject#get_type_conversion
  # @param [Fixnum] i The line number to look for (zero-based)
  def pull_asset_manual_payment_extended_existing_line_values(type, i)
    # This can be implemented for site-specific attributes particular to the AssetManualPaymentAccountingLineObject.
    # See the Hash returned in the #collect! in #update_from_page! above for the kind of way
    # to get the right return value.
    Hash.new
  end

end
