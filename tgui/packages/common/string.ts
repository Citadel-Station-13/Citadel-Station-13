/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

/**
 * Removes excess whitespace and indentation from the string.
 */
export const multiline = str => {
  if (Array.isArray(str)) {
    // Small stub to allow usage as a template tag
    return multiline(str.join(''));
  }
  const lines = str.split('\n');
  // Determine base indentation
  let minIndent;
  for (let line of lines) {
    for (let indent = 0; indent < line.length; indent++) {
      const char = line[indent];
      if (char !== ' ') {
        if (minIndent === undefined || indent < minIndent) {
          minIndent = indent;
        }
        break;
      }
    }
  }
  if (!minIndent) {
    minIndent = 0;
  }
  // Remove this base indentation and trim the resulting string
  // from both ends.
  return lines
    .map(line => line.substr(minIndent).trimRight())
    .join('\n')
    .trim();
};

/**
 * Creates a glob pattern matcher.
 *
 * Matches strings with wildcards.
 *
 * Example: createGlobPattern('*@domain')('user@domain') === true
 */
export const createGlobPattern = pattern => {
  const escapeString = str => str.replace(/[|\\{}()[\]^$+*?.]/g, '\\$&');
  const regex = new RegExp('^'
    + pattern.split(/\*+/).map(escapeString).join('.*')
    + '$');
  return str => regex.test(str);
};

const TRANSLATE_REGEX = /&(nbsp|amp|quot|lt|gt|apos);/g;
const TRANSLATIONS = {
  amp: '&',
  apos: "'",
  gt: '>',
  lt: '<',
  nbsp: ' ',
  quot: '"',
} as const;

/**
 * Decodes HTML entities and removes unnecessary HTML tags.
 *
 * @example
 * ```tsx
 * decodeHtmlEntities('&amp;') // returns '&'
 * decodeHtmlEntities('&lt;') // returns '<'
 * ```
 */
export function decodeHtmlEntities(str: string): string {
  if (!str) return str;

  return (
    str
      // Newline tags
      .replace(/<br>/gi, '\n')
      .replace(/<\/?[a-z0-9-_]+[^>]*>/gi, '')
      // Basic entities
      .replace(TRANSLATE_REGEX, (match, entity) => TRANSLATIONS[entity])
      // Decimal entities
      .replace(/&#?([0-9]+);/gi, (match, numStr) => {
        const num = parseInt(numStr, 10);
        return String.fromCharCode(num);
      })
      // Hex entities
      .replace(/&#x?([0-9a-f]+);/gi, (match, numStr) => {
        const num = parseInt(numStr, 16);
        return String.fromCharCode(num);
      })
  );
}
