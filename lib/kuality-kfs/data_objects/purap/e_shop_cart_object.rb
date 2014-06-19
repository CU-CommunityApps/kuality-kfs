class EShopCartObject < DataFactory

  include DateFactory
  include Utilities
  include GlobalConfig

  attr_accessor :cart_name, :cart_description, :business_purpose,
                # == Collections ==
                :items # items is a hash of ProductLineCollections, keyed on (snake_case'd) supplier name

  # Hooks:
  def defaults
    {
      cart_name:        random_alphanums(37, 'AFT'),
      cart_description: random_alphanums(37, 'AFT'),
      business_purpose: nil,
      items:            {}
    }
  end

  def extended_defaults
    Hash.new
  end

  def initialize(browser, opts={})
    @browser = browser
    set_options(defaults.merge(extended_defaults).merge(opts))
  end

  def create
    pre_create
    build
    fill_out_extended_attributes
    post_create
  end

  def pre_create; end

  def build
    on ShopCartPage do |scp|
      fill_out scp, :cart_name, :cart_description
      add_note @business_purpose unless @business_purpose.nil?
    end
  end

  def fill_out_extended_attributes(attribute_group=nil); end

  def post_create;  end

  def update_extended_line_objects_from_page!; end

  def absorb
    on ShopCartPage do |scp|
      update_options({
                       cart_name:        scp.cart_name.value.strip,
                       cart_description: scp.cart_description.value.strip,
                       business_purpose: (scp.add_note_link.exists? ? nil : scp.add_note_textarea.value.strip)
                     })
      absorb_items!
    end
  end

  def absorb_items!
    on ShopCartPage do |scp|
      @items.clear
      scp.suppliers.each do |supplier|
        @items[supplier] = collection('ProductLineObject')
        @items[supplier].supplier_name = supplier
        @items[supplier].update_from_page!
      end
    end
  end
  alias_method :update_line_objects_from_page!, :absorb_items!

  def save
    on(ShopCartPage).save_shopping_cart
  end

  def submit
    on(ShopCartPage).submit_shopping_cart
  end

  def add_note(note)
    on ShopCartPage do |scp|
      scp.add_note_link.click if scp.add_note_link.exists?
      scp.add_note_textarea.fit note
      scp.save_shopping_cart
      @business_purpose = note
    end
  end

  def view(in_e_shop=true)
    visit(MainPage).e_shop unless in_e_shop
    on(EShopPage).goto_cart
  end


end #class