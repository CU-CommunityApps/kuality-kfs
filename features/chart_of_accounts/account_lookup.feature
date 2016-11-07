Feature: Account Lookup

  [smoke]     As a KFS User I should be able to access the Account Lookup page.
  [KFSQA-557] As a KFS user I want to see acct look up screen because it has custom cornell fields.

  @smoke @hare @solid
  Scenario: Account lookup page should appear
    Given I am logged in as a KFS User
    When  I access Account Lookup
    Then  the Account Lookup page should appear

  @KFSQA-557 @cornell @KFSMI-7617 @hare @solid
  Scenario: KFS User accesses Account Lookup and views Cornell custom fields
    Given I am logged in as a KFS User
    When  I access Account Lookup
    Then  the Account Lookup page should appear with Cornell custom fields
