/**
 * @file
 * @license MIT
 */

import { Box } from "tgui-core/components";
import { BooleanLike, classes } from "tgui-core/react";

import { BoxProps } from ".";

interface SpriteProps extends BoxProps {
  readonly sheet: string;
  readonly sizeKey: string;
  readonly prefix?: string;
  readonly sprite: string;
  readonly fill?: BooleanLike;
}

export const Sprite = (props: SpriteProps) => {
  return (
    <Box {...props}
      className={classes([
        "Sprite",
        `${props.sheet}${props.sizeKey}`,
        props.prefix ? `${props.prefix}-${props.sprite}` : props.sprite,
        !!props.fill && 'Sprite--fill',
      ])} />
  );
};

// todo: this is all kind of terrible; we need a way to autodetect sizeKeys too so it's more friendly to users.
