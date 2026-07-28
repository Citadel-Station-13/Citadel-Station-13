/**
 * @file
 * @license MIT
 */

import { Component, ReactNode } from "react";
import { Box } from "tgui-core/components";

import { BoxProps } from ".";

interface VStaticScrollingWindowerState {

}

export interface VStaticScrollingWindowerEntry {
  key: string;
}

/**
 * Low-level vertical virtual scrolling window component.
 * Allows putting a ton of stuff in a single scrollable div by not actually rendering all of it.
 *
 * This is a static windower; technically, it can update, but since updates are controlled internally
 * you are forced to treat anything rendered as 'static' and immutable once rendered.
 */
export class VStaticScrollingWindower<T extends VStaticScrollingWindowerEntry> extends Component<{
  data: T[],
  transformer: (entry: T) => ReactNode,
} & BoxProps, VStaticScrollingWindowerState> {
  state: VStaticScrollingWindowerState;

  constructor(props) {
    super(props);
    this.state = {

    };
  }

  render() {
    // sike, this doesn't actually do anything
    // make something actually laggy to render enough for me to care
    // and i'll finish this.
    let innerContents = this.props.data.map((e) => {
      return (
        <div className='VStaticScrollingWindower__Element' key={e.key}>
          {this.props.transformer(e)}
        </div>
      );
    });

    return (
      <Box className="VStaticScrollingWindower">
        <Box className="VStaticScrollingWindower__Inner">
          {innerContents}
        </Box>
      </Box>
    );
  }
}
