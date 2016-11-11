class AccountGlobalLookupPage < Lookups
  account_facets
  account_principals_facets
  fiscal_officer_facets

  # Extended Attributes
  action(:major_reporting_category_code_lookup) { |b| b.frm.button(alt: 'Search Major Reporting Category Code').click }

end
