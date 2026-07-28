/**
 * Render a HTML string with the given header and body.
 */
#define HTML_SKELETON_HEADER_BODY(head, body) \
"<!DOCTYPE html><html><head><meta http-equiv='Content-Type' content='text/html; charset=UTF-8'><meta http-equiv='X-UA-Compatible' content='IE=edge'>[head]</head><body>[body]</body></html>"

/**
 * Render a HTML string with the given title and body, without additional headers.
 */
#define HTML_SKELETON_TITLE(title, body) HTML_SKELETON_HEADER_BODY("<title>[title]</title>", body)

/**
 * Render a HTML string with the given body, without a title or additional headers.
 */
#define HTML_SKELETON(body) HTML_SKELETON_HEADER_BODY("", body)
