package org.buildfest2022;

import io.micronaut.core.annotation.NonNull;
import io.micronaut.http.annotation.Controller;
import io.micronaut.http.annotation.Post;
import org.reactivestreams.Publisher;

import javax.validation.Valid;
import javax.validation.constraints.NotNull;

@Controller("/search")
public class SearchController {
  private final DocumentRepository documentService;

  SearchController(DocumentRepository documentService) {
    this.documentService = documentService;
  }

  @Post
  Publisher<SearchResult> search(@NonNull @NotNull @Valid Search search) {
    // TODO: Implement document search.
    return null;
  }
}
