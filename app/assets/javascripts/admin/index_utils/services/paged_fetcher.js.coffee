angular.module("admin.indexUtils").factory "PagedFetcher", (dataFetcher) ->
  new class PagedFetcher
    # Given a URL like http://example.com/foo?page=::page::&per_page=20
    # And the response includes an attribute pages with the number of pages to fetch
    # Fetch each page async, and call the processData callback with the resulting data
    fetch: (url, processData, onLastPageComplete) ->
      dataFetcher(@urlForPage(url, 1)).then (data) =>
        processData data

        if data.pages > 1
          for page in [2..data.pages]
            lastPromise = dataFetcher(@urlForPage(url, page)).then (data) ->
              processData data
          onLastPageComplete && lastPromise.then onLastPageComplete
          return
        else
          onLastPageComplete && onLastPageComplete()

    urlForPage: (url, page) ->
      url.replace("::page::", page)
