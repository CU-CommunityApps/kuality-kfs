module BatchUtilities

  # @param [Symbol] job_name
  # @param [Boolean] wait_for_completion
  # @param [Fixnum] max_seconds_wait
  # @param [Fixnum] loop_wait_seconds
  # Default values allow for maximum processing time of 15 minutes (900 seconds) before returning regardless of
  # completion status; i.e. max_reties * loop_wait_seconds = max_seconds_wait;
  # 180(max times to loop) * 5 seconds = 900(max seconds to wait)
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
    # To prevent intermittent failures, max wait time must be increased to 40 minutes
    run_unscheduled_job('posterBalancingJob', wait_for_completion, 2400)
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
    # To prevent intermittent failures, max wait time must be increased to 20 minutes
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
      if lookup.no_values_match_this_search?
        job_with_status_found = false
      end
    end
    job_with_status_found
  end

end
