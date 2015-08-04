class YearEndDepreciationAssetsObject < KFSDataObject

  DOC_INFO = { label: ' Year End Depreciation Assets', type_code: 'YDPA', transactional?: false, action_wait_time: 30}

  attr_accessor :asset_number

  def initialize(browser, opts={})
    @browser = browser

    defaults = { description:    random_alphanums(20, 'AFT')  }

    set_options(defaults.merge(opts))
  end

  def build
    visit(MainPage).year_end_depreciation
    on(AssetYearEndDepreciationLookupPage).create_new

    on YearEndDepreciationAssetsPage do |page|
      page.description.focus
      page.alert.ok if page.alert.exists? # Because, y'know, sometimes it doesn't actually come up...

      fill_out page, :description

    end
  end

end #class