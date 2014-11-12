class ContactLineObject < DataFactory

  include DateFactory
  include StringFactory
  include GlobalConfig

  attr_accessor   :line_number,
                  :type, :name, :email,
                  :address_1, :address_2,
                  :city, :state, :postal_code,
                  :province, :country, :attention,
                  :comments, :active

  def initialize(browser, opts={})
    @browser = browser

    defaults = { active: :set }

    set_options(defaults.merge(opts))
  end

  def create
    # For now, this only supports Vendor. We'll need to refactor appropriately
    # if any other object needs this collection.
    on VendorPage do |vp|
      vp.new_contact_type.pick!           @type
      vp.new_contact_name.fit             @name
      vp.new_contact_email.fit            @email
      vp.new_contact_address_1.fit        @address_1
      vp.new_contact_address_2.fit        @address_2
      vp.new_contact_city.fit             @city
      vp.new_contact_state.fit            @state
      vp.new_contact_zipcode.fit          @postal_code
      vp.new_contact_province.fit         @province
      vp.new_contact_country.pick!        @country
      vp.new_contact_attention.fit        @attention
      vp.new_contact_comments.fit         @comments
      vp.new_contact_active_indicator.fit @active
      fill_out_extended_attributes
      vp.add_contact
    end
  end

  def edit(opts={})
    on VendorPage do |vp|
      vp.contact_type_update(@line_number).pick!           opts[:type]
      vp.contact_name_update(@line_number).fit             opts[:name]
      vp.contact_email_update(@line_number).fit            opts[:email]
      vp.contact_address_1_update(@line_number).fit        opts[:address_1]
      vp.contact_address_2_update(@line_number).fit        opts[:address_2]
      vp.contact_city_update(@line_number).fit             opts[:city]
      vp.contact_state_update(@line_number).fit            opts[:state]
      vp.contact_zipcode_update(@line_number).fit          opts[:postal_code]
      vp.contact_province_update(@line_number).fit         opts[:province]
      vp.contact_country_update(@line_number).pick!        opts[:country]
      vp.contact_attention_update(@line_number).fit        opts[:attention]
      vp.contact_comments_update(@line_number).fit         opts[:comments]
      vp.contact_active_indicator_update(@line_number).fit opts[:active]
    end
    update_options(opts)
    update_extended_attributes(opts)
  end

  def delete
    raise NoMethodError, 'There is no way to delete a Contact from a Vendor. Perhaps you have a site-specific extension?'
  end

  def fill_out_extended_attributes
    # Override this method if you have site-specific extended attributes.
  end

  def update_extended_attributes(opts = {})
    # Override this method if you have site-specific extended attributes.
  end
  alias_method :edit_extended_attributes, :update_extended_attributes

end

class ContactLineObjectCollection < LineObjectCollection

  contains ContactLineObject

  def update_from_page!(target=:new)
    on VendorPage do |lines|
      clear # Drop any cached lines. More reliable than sorting out an array merge.

      lines.expand_all
      unless lines.current_contacts_count.zero?
        (0..(lines.current_contacts_count - 1)).to_a.collect!{ |i|
          pull_existing_contact(i, target).merge(pull_extended_existing_contact(i, target))
        }.each { |new_obj|
          # Update the stored lines
          self << (make contained_class, new_obj)
        }
      end

    end
  end

  # @param [Fixnum] i The line number to look for (zero-based)
  # @param [Symbol] target Which contact to pull from (most useful during a copy action). Defaults to :new
  # @return [Hash] The return values of attributes for the given line
  def pull_existing_contact(i=0, target=:new)
    pulled_contact = Hash.new

    on VendorPage do |vp|
      case target
        when :old
          pulled_contact = {
              type:           vp.contact_type_old(i),
              name:           vp.contact_name_old(i),
              email:          vp.contact_email_old(i),
              address_1:      vp.contact_address_1_old(i),
              address_2:      vp.contact_address_2_old(i),
              city:           vp.contact_city_old(i),
              state:          vp.contact_state_old(i),
              postal_code:    vp.contact_zipcode_old(i),
              province:       vp.contact_province_old(i),
              country:        vp.contact_country_old(i),
              attention:      vp.contact_attention_old(i),
              comments:       vp.contact_comments_old(i),
              active:         yesno2setclear(vp.contact_active_indicator_old(i))
          }
        when :new
          pulled_contact = {
              type:           vp.contact_type_new(i),
              name:           vp.contact_name_new(i),
              email:          vp.contact_email_new(i),
              address_1:      vp.contact_address_1_new(i),
              address_2:      vp.contact_address_2_new(i),
              city:           vp.contact_city_new(i),
              state:          vp.contact_state_new(i),
              postal_code:    vp.contact_zipcode_new(i),
              province:       vp.contact_province_new(i),
              country:        vp.contact_country_new(i),
              attention:      vp.contact_attention_new(i),
              comments:       vp.contact_comments_new(i),
              active:         yesno2setclear(vp.contact_active_indicator_new(i))
          }
      end
    end

    pulled_contact
  end

  # @param [Fixnum] i The line number to look for (zero-based)
  # @param [Symbol] target Which contact to pull from (most useful during a copy action). Defaults to :new
  # @return [Hash] The return values of attributes for the given line
  def pull_extended_existing_contact(i=0, target=:new)
    # This can be implemented for site-specific attributes. See the Hash returned in
    # the #collect! in #update_from_page! above for the kind of way to get the
    # right return value.
    Hash.new
  end

end