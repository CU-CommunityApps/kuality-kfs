Feature: Account Edit

  [KFSQA-593] As a KFS Chart Manager, when I edit an Account with an
              invalid Sub-Fund Program Code I should get an error message presented
              at the top of the Accountant Maintenance Tab. Because the field is validated
              against a maintenance table and KFS standards require it.

  [KFSQA-610] As a KFS Chart Administrator I want to update an Account without getting a stack trace error.

  [KFSQA-632] As a KFS Fiscal Officer I need to edit an account using the Major Reporting Category Code field and enter
              a lowercase value and have it convert to UPPERCASE because I need to manage in-year financial activity,
              fund balances and year-end reporting.

  @KFSQA-593 @Bug @AcctCreate @KITI-2931 @hare @solid
  Scenario: Edit an Account with an invalid Sub-Fund Program Code, part 1
    Given I am logged in as a KFS Chart Manager
    And   I edit an Account with a random Sub-Fund Group Code
    When  I enter an invalid Sub-Fund Program Code
    Then  I should get an invalid Sub-Fund Program Code error

  @KFSQA-593 @Bug @AcctCreate @KITI-2931 @hare @solid
  Scenario: Edit an Account with an invalid Sub-Fund Program Code, part 2
    Given I am logged in as a KFS Chart Manager
    And   I edit an Account with a random Sub-Fund Group Code
    When  I enter an invalid Major Reporting Category Code
    Then  I should get an invalid Major Reporting Category Code error

  @KFSQA-593 @Bug @AcctCreate @KITI-2931 @hare @solid
  Scenario: Edit an Account with an invalid Sub-Fund Program Code, part 3
    Given I am logged in as a KFS Chart Manager
    And   I edit an Account with a random Sub-Fund Group Code
    When  I enter an invalid Appropriation Account Number
    Then  I should get an invalid Appropriation Account Number error

  @KFSQA-610 @KFSQA-574 @Bug @AcctMaint @hare @solid
  Scenario: Edit an Account as KFS Chart Admin
    Given I am logged in as a KFS Chart Administrator
    And   I edit an Account
    When  I blanket approve the Account document
    Then  the Account document goes to one of the following statuses:
      | PROCESSED |
      | FINAL     |

  @KFSQA-632 @cornell @AcctCreate @KITI-2869 @hare @solid
  Scenario: KFS Chart Manager edits an Account with Major Reporting Category Code
    Given I am logged in as a KFS Chart Manager
    And   I edit an Account
    When  I input a lowercase Major Reporting Category Code value
    When  I blanket approve the Account document
    Then  the Account document goes to one of the following statuses:
      | PROCESSED |
      | FINAL     |

  @KFSQA-619 @AcctCreate @sloth @solid
  Scenario: Create an Account that matches Sub-Fund Group Code and Sub-Fund Program Code with an Appropriation Account Number
    Given I am logged in as a KFS Chart Manager
    And   I edit an Account
    And   I enter Sub Fund Program Code and Appropriation Account Number that are associated with a random Sub Fund Group Code
    When  I blanket approve the Account document
    Then  the Account document goes to one of the following statuses:
      | PROCESSED |
      | FINAL     |

  @KFSQA-619 @AcctCreate @hare @solid
  Scenario: Create an Account that does not match Sub-Fund Group Code and Sub-Fund Program Code with an Appropriation Account Number
    Given I am logged in as a KFS Chart Manager
    And   I edit an Account
    And   I enter Sub Fund Program Code that is associated with a random Sub Fund Group Code
    And   I enter an Appropriation Account Number that is not associated with the Sub Fund Group Code
    When  I submit the Account document
    Then  I should get an invalid Appropriation Account Number error
