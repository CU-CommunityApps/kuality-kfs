Feature: Requisition routing testing

  [KFSQA-1174] Verify a Requisition containing a sensitive or non-sensitive commodity code routes appropriately for review

  [KFSQA-1177] Verify a Requisition containing a restricted vendor routes to purchasing for review

  @KFSQA-1174 @REQS @Routing @solid @coral
  Scenario Outline: Verify a Requisition containing a sensitive or non-sensitive commodity code routes appropriately for review
    Given I am logged in as a KFS User for the REQS document
    And I create a Requisition with required Chart-Organization, Delivery and Additional Institutional information populated
    And I add an Item with a unit cost of 1 to the Requisition with a <commodity_code_type> Commodity Code
    And I add an Accounting Line to or update the favorite account specified for the Requisition Item just created
    And I calculate the Requisition document
    And I submit the Requisition document
    Then the document should have no errors
    And the Requisition document goes to ENROUTE
    And I switch to the user with the next Pending Action in the Route Log for the Requisition document
    And I display the Requisition document
    Then a Commodity Reviewer does <existence_check> a Pending or Future Action approval request for the <commodity_code_type> Commodity Code
    Examples:
      | commodity_code_type | existence_check |
      | sensitive           | have            |
      | non-sensitive       | not have        |

  @KFSQA-1177 @REQS @Routing @solid @coral
  Scenario: Verify a Requisition containing a restricted vendor routes to purchasing for review
    Given I am logged in as a KFS User for the REQS document
    And I create a Requisition with required Chart-Organization, Delivery and Additional Institutional information populated
    And I add a restricted Vendor to the Requisition
    And I add an Item with a unit cost of 1 to the Requisition with a non-sensitive Commodity Code
    And I add an Accounting Line to or update the favorite account specified for the Requisition Item just created
    And I calculate the Requisition document
    And I submit the Requisition document
    Then the document should have no errors
    And I route the Requisition document to final
    Then the Requisition Document Status is Awaiting Contract Manager Assignment
