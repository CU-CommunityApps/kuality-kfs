Feature: Disbursement Voucher

  [KFSQA-681] Retiree should get a DV; People with Multiple Affiliations in PeopleSoft should only return one row.

  [KFSQA-682] Terminated Employees should not be searchable for a DV.

  [KFSQA-685] Active Staff, Former Student, and Alumnus should get a DV;
              People with Multiple Affiliations in PeopleSoft should only return one row.

  [KFSQA-684] DV business rule should not compare Payee's EmplID to DV Initiator's Entity/Principal ID.

  @KFSQA-681 @smoke @sloth @solid
  Scenario: KFS User Initiates and Submits a Disbursement Voucher document with Payment to Retiree
    Given I am logged in as a KFS User for the DV document
    And   I start an empty Disbursement Voucher document
    And   I add a Retiree as payee and Reason Code B to the Disbursement Voucher
    And   I add an Accounting Line to the Disbursement Voucher with the following fields:
      | Number       | G003704            |
      | Object Code  | 6100               |
      | Amount       | 23                 |
      | Description  | Line Test Number 1 |
    When  I submit the Disbursement Voucher document
    Then  the Disbursement Voucher document goes to ENROUTE

  @KFSQA-682 @smoke @hare @solid
  Scenario: KFS User Initiates a Disbursement Voucher document and Payee search should return no result with Terminated Employee
    Given I am logged in as a KFS User for the DV document
    When  I start an empty Disbursement Voucher document
    Then  I search for the payee with Terminated Employee and Reason Code B for Disbursement Voucher document with no result found

  @KFSQA-685 @smoke @sloth @solid
  Scenario: KFS User Initiates and Submits a Disbursement Voucher document with Payment to Active Staff, Former Student, and Alumnus
    Given I am logged in as a KFS User for the DV document
    And   I start an empty Disbursement Voucher document
    And   I add an Active Staff, Former Student, and Alumnus as payee and Reason Code B to the Disbursement Voucher
    And   I add an Accounting Line to the Disbursement Voucher with the following fields:
      | Number       | G003704            |
      | Object Code  | 6100               |
      | Amount       | 23                 |
      | Description  | Line Test Number 1 |
    When  I submit the Disbursement Voucher document
    Then  the Disbursement Voucher document goes to ENROUTE

  @KFSQA-684 @smoke @sloth @solid
  Scenario: KFS User Initiates and Submits a Disbursement Voucher document with Payee's EmplID is the same as Initiator's Entity/Principal ID
    Given I am logged in as "LK26"
    #This is a unique case where initiator's (lk26) principalid=payee's (arm2) employeeid; so keep it hard coded
    And   I start an empty Disbursement Voucher document with Payment to Employee arm2
    And   I add an Accounting Line to the Disbursement Voucher with the following fields:
      | Number       | G003704            |
      | Object Code  | 6540               |
      | Amount       | 22341.11           |
      | Description  | Line Test Number 1 |
    When  I submit the Disbursement Voucher document
    Then  the Disbursement Voucher document goes to ENROUTE
