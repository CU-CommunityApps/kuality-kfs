module BatchUtilities

  #Default values will allow for maximum processing time of 15 minutes (900 seconds) before returning regardless of completion status.
  def run_unscheduled_job(job_name, wait_for_completion=true, max_seconds_wait=900, loop_wait_seconds=5)
    max_retries = (max_seconds_wait.to_i / loop_wait_seconds.to_i).ceil
    @browser.goto "#{$base_url}batchModify.do?methodToCall=start&name=#{job_name}&group=unscheduled"
    on SchedulePage do |page|
      page.run_job
      if wait_for_completion == true
        x = 0
        while x < max_retries
          break if (page.job_status =~ /Succeeded/) == 0
          break if (page.job_status =~ /Failed/) == 0
          sleep loop_wait_seconds.to_i
          page.refresh
          x += 1
        end
      end
    end
  end


################
# GL Batch Jobs
################
  def run_nightly_out(wait_for_completion = false)
    run_unscheduled_job('nightlyOutJob', wait_for_completion)
  end

  def run_scrubber(wait_for_completion = false)
    run_unscheduled_job('scrubberJob', wait_for_completion)
  end

  def run_poster(wait_for_completion = false)
    run_unscheduled_job('posterJob', wait_for_completion)
  end

  def run_poster_balancing(wait_for_completion = false)
    run_unscheduled_job('posterBalancingJob', wait_for_completion, 1200)
  end

  def run_clear_pending_entries(wait_for_completion = false)
    run_unscheduled_job('clearPendingEntriesJob', wait_for_completion)
  end


##################
# Labor Batch Jobs
##################
  def run_labor_enterprise_feed(wait_for_completion = false)
    run_unscheduled_job('laborEnterpriseFeedJob', wait_for_completion)
  end

  def run_labor_nightly_out(wait_for_completion = false)
    run_unscheduled_job('laborNightlyOutJob', wait_for_completion)
  end

  def run_labor_scrubber(wait_for_completion = false)
    run_unscheduled_job('laborScrubberJob', wait_for_completion)
  end

  def run_labor_poster(wait_for_completion = false)
    run_unscheduled_job('laborPosterJob', wait_for_completion)
  end

  def run_labor_balance(wait_for_completion = false)
    #Labor balancing job runs for a long time (observed as much as 10+ minutes).
    #To prevent intermittent failures, set max_seconds_wait to 1200 so that
    #it has enough time to complete before the next batch job is started,
    # i.e. reties * 5secLoopWait default in run_unscheduled_job = 1200/5 = 240 should be enough
    run_unscheduled_job('laborBalancingJob', wait_for_completion, 1200)
  end

  def run_labor_feed(wait_for_completion = false)
    run_unscheduled_job('laborFeedJob', wait_for_completion)
  end

  def run_labor_clear_pending_entries(wait_for_completion = false)
    run_unscheduled_job('clearLaborPendingEntriesJob', wait_for_completion)
  end


  ###################
  # Batch Job Lookup
  ###################
  def is_batch_job?(status='Failed')
    job_with_status_found = true
    on BatchJobLookup do |lookup|
      lookup.job_status.select_value(/#{status}/m)
      lookup.search
      if lookup.no_result_table_returned?
        job_with_status_found = false
      end
    end
    job_with_status_found  #return our findings
  end


  # TODO : Following batch jobs are commented out for testing
  # FIXME: Why? This seems wrong for the master branch...

  def run_auto_approve_preq(wait_for_completion = false)
    run_unscheduled_job('autoApprovePaymentRequestsJob', wait_for_completion, 600)
  end

  def run_electronic_invoice_extract(wait_for_completion = false)
    warn 'Would have run #run_electronic_invoice_extract'
    #run_unscheduled_job('electronicInvoiceExtractJob', wait_for_completion)
  end

  def run_pur_pre_disburse_extract(wait_for_completion = false)
    warn 'Would have run #run_pur_pre_disburse_extract'
    #run_unscheduled_job('purchasingPreDisbursementExtractJob', wait_for_completion)
  end

  def run_pur_pre_disburse_immediate_extract(wait_for_completion = false)
    warn 'Would have run #run_pur_pre_disburse_immediate_extract'
    #run_unscheduled_job('purchasingPreDisbursementImmediatesExtractJob', wait_for_completion)
  end

  def run_auto_close_recurring_order(wait_for_completion = false)
    warn 'Would have run #run_auto_close_recurring_order'
    #run_unscheduled_job('autoCloseRecurringOrdersJob', wait_for_completion)
  end

  def run_pdp_load_payment(wait_for_completion = false)
    warn 'Would have run #run_pdp_load_payment'
    #run_unscheduled_job('pdpLoadPaymentsJob', wait_for_completion)
  end

  def run_pdp_extract_ach_payment(wait_for_completion = false)
    warn 'Would have run #run_pdp_extract_ach_payment'
    #run_unscheduled_job('pdpExtractAchPaymentsJob', wait_for_completion)
  end

  def run_pdp_extract_check(wait_for_completion = false)
    warn 'Would have run #run_pdp_extract_check'
    #run_unscheduled_job('pdpExtractChecksJob', wait_for_completion)
  end

  def run_pdp_extract_canceled_check(wait_for_completion = false)
    warn 'Would have run #run_pdp_extract_canceled_check'
    #run_unscheduled_job('pdpExtractCanceledChecksJob', wait_for_completion)
  end

  def run_pdp_send_ach_advice_notification(wait_for_completion = false)
    warn 'Would have run #run_pdp_send_ach_advice_notification'
    #run_unscheduled_job('pdpSendAchAdviceNotificationsJob', wait_for_completion)
  end

  def run_pdp_cancel_and_paid(wait_for_completion = false)
    warn 'Would have run #run_pdp_cancel_and_paid'
    #run_unscheduled_job('processPdpCancelsAndPaidJob', wait_for_completion)
  end

  def run_pdp_extract_gl_transaction(wait_for_completion = false)
    warn 'Would have run #run_pdp_extract_gl_transaction'
    #run_unscheduled_job('pdpExtractGlTransactionsStepJob', wait_for_completion)
  end

  def run_pdp_load_fed_reserve_bank_data(wait_for_completion = false)
    warn 'Would have run #run_pdp_load_fed_reserve_bank_data'
    #run_unscheduled_job('pdpLoadFederalReserveBankDataJob', wait_for_completion)
  end

  def run_pdp_clear_pending_transaction(wait_for_completion = false)
    warn 'Would have run #run_pdp_clear_pending_transaction'
    #run_unscheduled_job('pdpClearPendingTransactionsJob', wait_for_completion)
  end

  def run_cab_extract(wait_for_completion = false)
    run_unscheduled_job('cabExtractJob', wait_for_completion)
  end


end
