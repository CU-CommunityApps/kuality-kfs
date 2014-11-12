class AddressLineObject < DataFactory

  include DateFactory
  include StringFactory
  include GlobalConfig

  attr_accessor   :line_number,
                  :type,
                  :address_1, :address_2,
                  :city, :state, :postal_code,
                  :province, :country, :attention,
                  :url, :fax, :email,
                  :set_as_default, :active

  def initialize(browser, opts={})
    @browser = browser

    defaults = {
      type:           'PO - PURCHASE ORDER',
      address_1:      get_generic_address_1,
      city:           get_generic_city,
      state:          get_random_state_code,
      postal_code:    get_random_postal_code('NY'),
      country:        'United States',
      set_as_default: 'Yes',
      active:         :set
    }

    set_options(defaults.merge(opts))
  end

  def create
    # For now, this only supports Vendor. We'll need to refactor appropriately
    # if any other object needs this collection.
    on VendorPage do |vp|
      vp.address_type.pick!           @type
      vp.address_1.fit                @address_1
      vp.address_2.fit                @address_2
      vp.city.fit                     @city
      vp.state.fit                    @state
      vp.zipcode.fit                  @postal_code
      vp.province.fit                 @province
      vp.country.pick!                @country
      vp.address_attention.fit        @attention
      vp.address_url.fit              @url
      vp.fax.fit                      @fax
      vp.email.fit                    @email
      vp.default_address.pick!        @set_as_default
      vp.address_active_indicator.fit @active
      fill_out_extended_attributes
      vp.add_address
    end
  end

  def edit(opts={})
    on VendorPage do |vp|
      vp.address_type_update(@line_number).pick! opts[:type]
      vp.address_1_update(@line_number).fit      opts[:address_1]
      vp.address_2_update(@line_number).fit      opts[:address_2]
      vp.city_update(@line_number).fit           opts[:city]
      vp.state_update(@line_number).fit          opts[:state]
      vp.zipcode_update(@line_number).fit        opts[:postal_code]
      vp.province_update(@line_number).fit       opts[:province]
      vp.country_update(@line_number).pick!      opts[:country]
      vp.address_attention_update(@line_number).fit opts[:attention]
      vp.address_url_update(@line_number).fit       opts[:url]
      vp.fax_update(@line_number).fit               opts[:fax]
      vp.email_update(@line_number).fit             opts[:email]
      vp.default_address_update(@line_number).pick! opts[:set_as_default]
      vp.address_active_indicator_update(@line_number).fit opts[:active]
    end
    update_options(opts)
    update_extended_attributes(opts)
  end

  def delete
    raise NoMethodError, 'There is no way to delete an Address from a Vendor. Perhaps you have a site-specific extension?'
  end

  def fill_out_extended_attributes
    # Override this method if you have site-specific extended attributes.
  end

  def update_extended_attributes(opts = {})
    # Override this method if you have site-specific extended attributes.
  end
  alias_method :edit_extended_attributes, :update_extended_attributes

end

class AddressLineObjectCollection < LineObjectCollection

  contains AddressLineObject

  def update_from_page!(target=:new)
    on VendorPage do |lines|
      clear # Drop any cached lines. More reliable than sorting out an array merge.

      lines.expand_all
      unless lines.current_address_count.zero?
        (0..(lines.current_address_count - 1)).to_a.collect!{ |i|
          pull_existing_address(i, target).merge(pull_extended_existing_address(i, target))
        }.each { |new_obj|
          # Update the stored lines
          self << (make contained_class, new_obj)
        }
      end

    end
  end

  # @param [Fixnum] i The line number to look for (zero-based)
  # @param [Symbol] target Which address to pull from (most useful during a copy action). Defaults to :new
  # @return [Hash] The return values of attributes for the given line
  def pull_existing_address(i=0, target=:new)
    pulled_address = Hash.new

    on VendorPage do |vp|
      case target
        when :old
          pulled_address = {
              type:           vp.address_type_old(i),
              address_1:      vp.address_1_old(i),
              address_2:      vp.address_2_old(i),
              city:           vp.city_old(i),
              state:          vp.state_old(i),
              postal_code:    vp.zipcode_old(i),
              province:       vp.province_old(i),
              country:        vp.country_old(i),
              attention:      vp.address_attention_old(i),
              url:            vp.address_url_old(i),
              fax:            vp.fax_old(i),
              email:          vp.email_old(i),
              set_as_default: vp.default_address_old(i),
              active:         yesno2setclear(vp.address_active_indicator_old(i))
          }
        when :new
          pulled_address = {
              type:           vp.address_type_new(i),
              address_1:      vp.address_1_new(i),
              address_2:      vp.address_2_new(i),
              city:           vp.city_new(i),
              state:          vp.state_new(i),
              postal_code:    vp.zipcode_new(i),
              province:       vp.province_new(i),
              country:        vp.country_new(i),
              attention:      vp.address_attention_new(i),
              url:            vp.address_url_new(i),
              fax:            vp.fax_new(i),
              email:          vp.email_new(i),
              set_as_default: vp.default_address_new(i),
              active:         yesno2setclear(vp.address_active_indicator_new(i))
          }
        when :readonly
          pulled_address = {
              type:           vp.address_type_readonly(i),
              address_1:      vp.address_1_readonly(i),
              address_2:      vp.address_2_readonly(i),
              city:           vp.city_readonly(i),
              state:          vp.state_readonly(i),
              postal_code:    vp.zipcode_readonly(i),
              province:       vp.province_readonly(i),
              country:        vp.country_readonly(i),
              attention:      vp.address_attention_readonly(i),
              url:            vp.address_url_readonly(i),
              fax:            vp.fax_readonly(i),
              email:          vp.email_readonly(i),
              set_as_default: vp.default_address_readonly(i),
              active:         yesno2setclear(vp.address_active_indicator_readonly(i))
          }
        else
          raise ArgumentError, "AddressLineObject does not know how to pull the provided existing address type (#{target})!"
      end
    end

    pulled_address
  end

  # @param [Fixnum] i The line number to look for (zero-based)
  # @param [Symbol] target Which address to pull from (most useful during a copy action). Defaults to :new
  # @return [Hash] The return values of attributes for the given line
  def pull_extended_existing_address(i=0, target=:new)
    # This can be implemented for site-specific attributes. See the Hash returned in
    # the #collect! in #update_from_page! above for the kind of way to get the
    # right return value.
    Hash.new
  end

end