class PurchaseOrderAmendmentObject < KFSDataObject

  DOC_INFO = { label: 'Purchase Order Amendment', type_code: 'POA' }

  attr_reader :item_quantitiy, :item_catalog_number, :item_description,
              :item_unit_cost, :item_uom, :attachment_file_name

  def initialize(browser, opts={})
    @browser = browser

    defaults = { description:    random_alphanums(40, 'AFT'),
                 item_quantity: '1000',
                 item_catalog: '10121800',
                 item_description: random_alphanums(15, 'AFT Item'),
                 item_unit_cost: '9.9',
                 item_uom: 'BX',
                 attachment_file_name:       'happy_path_reqs.png',
    }

    set_options(defaults.merge(opts))
  end

end