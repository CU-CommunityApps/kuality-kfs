include Navigation

And /^I access Document Search$/ do
  visit(DocumentSearch)
end

When /^I copy a document with a (.*) status$/ do |status|
  on DocumentSearch do |page|
    docs = page.docs_with_status(status)
    page.open_doc(docs[rand(docs.length)])
  end
  on(KFSBasePage) do |document_page|
    document_page.copy_current_document
    @document_id = document_page.document_id
  end
end

When /^I reopen the document$/ do
  visit DocumentSearch do |page|
    page.document_id.fit @document_id
    page.search
    page.open_doc(@document_id)
  end
end
