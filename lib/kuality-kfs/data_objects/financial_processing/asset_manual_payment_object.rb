class AssetManualPaymentObject < KFSDataObject

  include AssetManualPaymentAccountingLinesMixin  #defines accounting lines

  DOC_INFO = { label: 'Asset Manual Payment', type_code: 'MPAY', transactional?: true, action_wait_time: 30}

  attr_accessor :asset_allocation, :asset_number,
                :asset_lines

  def defaults
    super #we have no default attribute values but super class does, build from super class first to prevent nil object issue
    super.merge!(get_aft_parameter_values_as_hash(ParameterConstants::DEFAULTS_FOR_ASSET_MANUAL_PAYMENT))
         .merge!(default_accounting_lines)
  end

  def build
    visit(MainPage).asset_manual_payment
    on AssetManualPaymentPage do |page|
      page.expand_all
      page.description.focus
      page.alert.ok if page.alert.exists? # Because, y'know, sometimes it doesn't actually come up...
      fill_out page, :description, :asset_allocation
    end
  end

  def pull_all_accounting_lines(page)
    asset_manual_payment_accounting_lines = Array.new
    #get all From lines, this edoc has no To lines
    max_num_rows = page.accounting_lines_row_count #time sync getting this value, get it once and reuse in loop
    for row in 0..(max_num_rows)-1
      line_hash = page.pull_existing_accounting_line_values(:source, row, page)
      asset_manual_payment_accounting_lines.push(line_hash)
    end
    return asset_manual_payment_accounting_lines
  end

  def pull_specific_asset_line(type, row, page)
    if type == :source
      asset_number = page.capital_asset_number_value row
      amount = (page.allocate_amount_value row).gsub(/,/, '')  #remove any commas that may be present i.e. 1,234.56
    end
    new_line = {
        :asset_number => asset_number,
        :amount       => amount
    }
    return new_line
  end

  def pull_all_asset_lines(page)
    asset_lines = Array.new
    #get all assets listed on the page
    max_num_rows = page.asset_lines_row_count #time sync getting this value, get it once and reuse in loop
    for row in 0..(max_num_rows)-1
      line_hash = pull_specific_asset_line(:source, row, page)
      asset_lines.push(line_hash)
    end
    return asset_lines
  end

end #class
