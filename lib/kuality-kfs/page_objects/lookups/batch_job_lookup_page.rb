class BatchJobLookup < Lookups

  element(:namespace_code) { |b| b.frm.select(id: 'namespaceCode') }
  element(:job_name) { |b| b.frm.text_field(id: 'name') }
  element(:job_group) { |b| b.frm.text_field(id: 'group') }
  element(:job_status) { |b| b.frm.select(id: 'status') }

end
