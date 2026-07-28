/**
 * @file
 * @license MIT
 */

import { Tooltip } from "tgui-core/components";

import { sanitizeHTML } from "../sanitize";
import { TooltipProps } from ".";

interface TooltipHTMLProps extends TooltipProps {
  html: string;
}

/**
 * I shouldn't have to say why this is dangerous to use.
 */
export const TooltipHTML = (props: TooltipHTMLProps) => {
  const {
    html,
    content,
    ...rest
  } = props;
  let sanitized = sanitizeHTML(html);
  let unsafeContent = (
    // eslint-disable-next-line react/no-danger
    <div dangerouslySetInnerHTML={{ __html: sanitized }} />
  );
  return (
    <Tooltip content={unsafeContent} {...rest} />
  );
};
