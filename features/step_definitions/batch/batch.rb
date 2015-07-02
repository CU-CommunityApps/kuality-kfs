include BatchUtilities



# This is the step that should be added to and used when ALL nightly batch job processing must be performed.
# Currently, ensures both Labor and GL processing is completed.
And /^All Nightly Batch Jobs are run$/ do
  step 'I am logged in as a KFS Operations'
  step 'Nightly Labor Batch Jobs run'
  step 'Nightly GL Critical Path Batch Jobs run'
end


# Step is mis-named. It is really just executing the GL batch jobs.
# Currently we are wrapping the appropriate GL batch processing step.
And /^Nightly Batch Jobs run$/ do
  step 'I am logged in as a KFS Operations'
  step 'Nightly GL Critical Path Batch Jobs run'
end


Then /^I run the nightly Labor batch process$/ do
  step 'I am logged in as a KFS Operations'
  #all the labor jobs
  step 'Nightly Labor Batch Jobs run'
  #all the gl jobs required after labor runs
  step 'I run Scrubber'
  step 'the last Nightly Batch Job should have succeeded'
  step 'I run Poster'
  step 'the last Nightly Batch Job should have succeeded'
  step 'I run Poster Balancing'
  step 'the last Nightly Batch Job should have succeeded'
end


# This step will not invoke the first batch job unless all previous batch job run requests were successfully completed.
# This step will not invoke the next batch job unless previous job completed successfully.
# This is to take into account long running or failed jobs.
# Caller is responsible for logging in as a user with security to run the batch jobs.
And /^Nightly GL Critical Path Batch Jobs run$/ do
  step 'There are no incomplete Batch Job executions'
  step 'I run Nightly Out'
  step 'the last Nightly Batch Job should have succeeded'
  step 'I run Scrubber'
  step 'the last Nightly Batch Job should have succeeded'
  step 'I run Poster'
  step 'the last Nightly Batch Job should have succeeded'
  step 'I run Poster Balancing'
  step 'the last Nightly Batch Job should have succeeded'
  step 'I run Clear Pending Entries'
  step 'the last Nightly Batch Job should have succeeded'
end


# This step will not invoke the first batch job unless all previous batch job run requests were successfully completed.
# This step only executes the Labor jobs. It does not execute the GL jobs that should be run after the labor jobs.
# This step will not invoke the next batch job unless previous job completed successfully.
# This is to take into account long running or failed jobs.
# Caller is responsible for logging in as a user with security to run the batch jobs.
And /^Nightly Labor Batch Jobs run$/ do
  step 'There are no incomplete Batch Job executions'
  #all the labor jobs
  step 'I run the Labor Enterprise Feed Process'
  step 'the last Nightly Batch Job should have succeeded'
  step 'I run the Labor Nightly Out Process'
  step 'the last Nightly Batch Job should have succeeded'
  step 'I run the Labor Scrubber Process'
  step 'the last Nightly Batch Job should have succeeded'
  step 'I run the Labor Poster Process'
  step 'the last Nightly Batch Job should have succeeded'
  step 'I run the Labor Balancing Job'
  step 'the last Nightly Batch Job should have succeeded'
  step 'I run the Labor Feed Job'
  step 'the last Nightly Batch Job should have succeeded'
  step 'I run the Labor Clear Pending Entries Job'
  step 'the last Nightly Batch Job should have succeeded'
end


# This step is intended to be called in between successive batch job invocations within the same step.
Then /^the last Nightly Batch Job should have succeeded$/ do
  on(SchedulePage).job_status.should match(/Succeeded/)
end


# This step is intended to be executed before any batch job is requested for a given test.
# This step will prevent that new batch job request from starting by failing the test when previous batch job execution
# requests do not complete successfully.
And /^There are no incomplete Batch Job executions$/ do
  visit(AdministrationPage).schedule
  is_batch_job?('Failed').should_not == true
  is_batch_job?('Running').should_not == true
  is_batch_job?('Cancelled').should_not == true
end


###### General Ledger Batch Jobs

And /^I run Nightly Out$/ do
  run_nightly_out(true)
end

And /^I run Scrubber$/ do
  run_scrubber(true)
end

And /^I run Poster$/ do
  run_poster(true)
end

And /^I run Poster Balancing$/ do
  run_poster_balancing(true)
end

And /^I run Clear Pending Entries$/ do
  run_clear_pending_entries(true)
end


###### Labor Batch Jobs

And /^I run the Labor Enterprise Feed Process$/ do
  run_labor_enterprise_feed(true)
end

And /^I run the Labor Nightly Out Process$/ do
  run_labor_nightly_out(true)
end

And /^I run the Labor Scrubber Process$/ do
  run_labor_scrubber(true)
end

And /^I run the Labor Poster Process$/ do
  run_labor_poster(true)
end

And /^I run the Labor Balancing Job$/ do
  run_labor_balance(true)
end

And /^I run the Labor Feed Job$/ do
  run_labor_feed(true)
end

And /^I run the Labor Clear Pending Entries Job$/ do
  run_labor_clear_pending_entries(true)
end


###### Other batch jobs

And /^I run Auto Approve PREQ$/ do
  run_auto_approve_preq(true)
end

And /^I run Fax Pending Documents$/ do
  run_fax_pending_doc(true)
end

And /^I process Receiving for Payment Requests$/ do
  run_receiving_payment_request(true)
end

And /^I extract Electronic Invoices$/ do
  run_electronic_invoice_extract(true)
end

And /^I extract Regular PREQS to PDP for Payment$/ do
  run_pur_pre_disburse_extract(true)
end

And /^I extract Immediate PREQS to PDP for Payment$/ do
  run_pur_pre_disburse_immediate_extract(true)
end

And /^I approve Line Items$/ do
  run_approve_line_item_receiving(true)
end

And /^I close POS wtih Zero Balanecs$/ do
  run_auto_close_recurring_order(true)
end

And /^I load PREQ into PDP$/ do
  run_pdp_load_payment(true)
end

And /^I generate the ACH XML File$/ do
  run_pdp_extract_ach_payment(true)
end

And /^I generate the Check XML File$/ do
  run_pdp_extract_check(true)
end

And /^I generate the Cancelled Check XML File$/ do
  run_pdp_extract_canceled_check(true)
end

And /^I send EMAIL Notices to ACH Payees$/ do
  run_pdp_send_ach_advice_notification(true)
end

And /^I process Cancels and Paids$/ do
  run_pdp_cancel_and_paid(true)
end

And /^I generate the GL Files from PDP$/ do
  run_pdp_extract_gl_transaction(true)
end

And /^I populate the ACH Bank Table$/ do
  run_pdp_load_fed_reserve_bank_data(true)
end

And /^I clear out PDP Temporary Tables$/ do
  run_pdp_clear_pending_transaction(true)
end

And /^I collect the Capital Asset Documents$/ do
  run_nightly_out(true)
end

And /^I create the Plant Fund Entries$/ do
  run_scrubber(true)
end

And /^I move the Plant Fund Entries to Posted Entries$/ do
  run_poster(true)
end

And /^I create entries for CAB$/ do
  run_cab_extract(true)
end

###### Next two routines  save and retrieve references to instance data between scenario that creates it and scenario
###### that uses it for validation when the batch jobs must be executed in order to achieve validation.
Then /^references to test (.*) instance data is saved for validation after batch job execution$/ do |aft_name|
  # create Hash for this test's instance data
  aft_data_hash = Hash.new
  # populate that instance data hash for the specific AFT with its information needed later for validation and store
  # that info in the global hash referencing by AFT JIRA number
  case aft_name
    when 'KFSQA-664'
      aft_data_hash[:encumbrance_amount] = @encumbrance_amount
      aft_data_hash[:pre_encumbrance]    = @pre_encumbrance
      aft_data_hash[:account]            = @account
      aft_data_hash[:object_code]        = @object_code
      $aft_validation_data[aft_name]     = aft_data_hash
    when 'KFSQA-753'
      aft_data_hash[:encumbrance_amount] = @encumbrance_amount
      aft_data_hash[:pre_encumbrance]    = @pre_encumbrance
      aft_data_hash[:account]            = @account
      aft_data_hash[:object_code]        = @object_code
      $aft_validation_data[aft_name]     = aft_data_hash
    else raise ArgumentError, 'Required AFT Name was not specified.'
  end
end

And /^I can retrieve references to test (.*) instance data saved for validation after batch job execution$/ do |aft_name|
  # ensure global Hash of Hashes contains something
  raise StandardError, 'Global hash of AFT data for validation is nil.' if $aft_validation_data.nil?
  raise StandardError, 'Global hash of AFT data for validation is empty.' if $aft_validation_data.empty?
  # populate all of the instance data for the specified AFT with the archived data needed for validation
  case aft_name
    when 'KFSQA-664'
      aft_data_hash       = $aft_validation_data[aft_name]
      @encumbrance_amount = aft_data_hash[:encumbrance_amount]
      @pre_encumbrance    = aft_data_hash[:pre_encumbrance]
      @account            = aft_data_hash[:account]
      @object_code        = aft_data_hash[:object_code]
      $aft_validation_data.delete(aft_name)
    when 'KFSQA-753'
      aft_data_hash       = $aft_validation_data[aft_name]
      @encumbrance_amount = aft_data_hash[:encumbrance_amount]
      @pre_encumbrance    = aft_data_hash[:pre_encumbrance]
      @account            = aft_data_hash[:account]
      @object_code        = aft_data_hash[:object_code]
      $aft_validation_data.delete(aft_name)
    else raise ArgumentError, 'Required AFT Name was not specified.'
  end
end
