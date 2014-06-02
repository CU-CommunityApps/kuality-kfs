class FederalFundedCodeObject < KFSDataObject

  attr_accessor :federal_funded_code, :federal_funded_name, :active_indicator

  def initialize(browser, opts={})
    @browser = browser
    defaults = {
        description:         random_alphanums(20, 'AFT'),
        federal_funded_code: random_alphanums(1),
        federal_funded_name: random_alphanums(20, 'AFT'),
        active_indicator: '',
        press:               :save
    }
    set_options(defaults.merge(opts))
  end

  def build
    visit(MaintenancePage).federal_funded_code
    on(FederalFundedCodeLookupPage).create_new

  on FederalFundedCodePage do |page|
      page.description.focus
      page.alert.ok if page.alert.exists? # Because, y'know, sometimes it doesn't actually come up...

      fill_out page, :description, :federal_funded_code, :federal_funded_name
      page.active_indicator.set if @active_indicator == 'set'
      page.active_indicator.clear if @active_indicator == 'clear'

      #If Federal Funded Code already exists in the system then the Submit/Blanket Approve will fail with error
      #This document cannot be Saved or Routed because a record with the same primary key already exists.
    end
  end

  # def edit opts={}
  #   #do editing
  #   update_options(opts)
  # end


  def search_results_array
    on(FederalFundedCodeLookupPage).make_results_array
    # action(:make_results_array) {|b| b.frm.table(id: 'row').trs.each { |tr| tr.tds.each { |t| @search_results_array << t.text } } }
  end


end #class