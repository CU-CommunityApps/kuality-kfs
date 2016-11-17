class MainPage < BasePage

  page_url "#{$base_url}portal.do?selectedTab=main"

  description_field


  links 'Auxiliary Voucher',
        'Disbursement Voucher',
        'Pre-Encumbrance',

        'Salary Expense Transfer',

        'Requisition',

        'Asset Manual Payment',

        'Account',
        'Account Global',
        'Account Delegate',
        'Account Delegate Model',
        'Object Code',
        'Object Code Global',
        'Sub-Account',
        'Sub-Object Code Global',

        'General Ledger Entry',
        'General Ledger Pending Entry',
        'Open Encumbrances',

        'Labor Ledger Pending Entry'
end
