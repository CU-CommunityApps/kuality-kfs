Feature: Auxiliary Voucher

  [KFSQA-627] I want to create an Auxiliary Voucher posting accounting lines
              across Sub-Fund Group Codes because of Cornell SOP.

  @KFSQA-627 @AuxVoucher @cornell @sloth @solid
  Scenario: Auxiliary Voucher allows Accounting Lines across Sub Fund Group Codes
    Given   I am logged in as a KFS User
    And     I start an empty Auxiliary Voucher document
    And     I add credit and debit accounting lines with two different sub funds
    When    I submit the Auxiliary Voucher document
    Then    the document should have no errors
    And     the Auxiliary Voucher document goes to ENROUTE
