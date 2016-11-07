Feature: Pre-Encumbrance

  [KFSQA-654] Open Encumbrances Lookup not displaying pending entries generated from the PE eDoc.

  [KFSQA-753] Cornell University needs to process pre-encumbrances with expense
              object codes and verify proper offsets are used.

  @KFSQA-654 @FP @PE @GL-QUERY @sloth @solid
  Scenario: Open Encumbrances Lookup will display pending entries from PE eDoc
    Given I am logged in as a KFS Chart Manager
    And   I clone a random Account with name, chart code, and description changes
    And   I am logged in as a KFS Chart Administrator
    And   I blanket approve a Pre-Encumbrance Document that encumbers the random Account
    And   the Pre-Encumbrance document goes to FINAL
    Then  the Open Encumbrances lookup for the Pre-Encumbrance document with Balance Type PE Includes All Pending Entries

  @KFSQA-753 @FP @PE @nightly-jobs @cornell @tortoise @solid
  Scenario: Generate Proper Offsets Using a PE to generate an Encumbrance
    Given I am logged in as a KFS User
    And   I submit a Pre-Encumbrance document that encumbers a random Account
    And   the Object Codes for the Pre-Encumbrance document appear in the document's GLPE entry
    And   I am logged in as a KFS Chart Manager
    And   I view the Pre-Encumbrance document
    And   I blanket approve the Pre-Encumbrance document
    And   the Pre-Encumbrance document goes to FINAL
    And   the Pre-Encumbrance document has matching GL and GLPE offsets
    #Remaining validation will be performed after the nightly batch jobs are executed for this feature file
    Then    references to test KFSQA-753 instance data are saved for validation after batch job execution

  @nightly-jobs @solid
  Scenario: Run Nightly batch jobs required for Pre-Encumbrance Tests Verification
    Given   Nightly Batch Jobs run
    Then    There are no incomplete Batch Job executions

  @KFSQA-753 @validation-after-batch @solid
  Scenario: Validation for Generate Proper Offsets Using a PE to generate an Encumbrance
    Given All Nightly Batch Jobs have completed successfully
    And   I can retrieve references to test KFSQA-753 instance data saved for validation after batch job execution
    When  I am logged in as a KFS User
    Then  the Pre-Encumbrance document GL Entry Lookup matches the document's GL entry
