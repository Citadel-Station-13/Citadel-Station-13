/**
 * @file
 * @license MIT
 */

import { ReactNode } from "react";
import { Button, Table } from "tgui-core/components";

import { BoxProps, TableCellProps } from ".";

/**
 * A vertical list to render a split left-right set of options, with an optional
 * aligned description on the left. Very useful for things like configuration lists.
 */
export const VSplitTooltipList = (props: {
  leftSideWidthPercent: number;
} & BoxProps) => {
  const {
    leftSideWidthPercent,
    children,
    ...rest
  } = props;

  let remainingWidthPercent = 100 - leftSideWidthPercent;

  return (
    <Table className="VSplitTooltipList" {...rest} >
      <Table.Row className="VSplitTooltipList__Row">
        <Table.Cell width={`${leftSideWidthPercent}%`} />
        <Table.Cell width="0%" />
        <Table.Cell width={`${remainingWidthPercent}%`} />
      </Table.Row>
      {children}
    </Table>
  );
};

const VSplitTooltipListEntry = (props: {
  tooltip?: string;
  label: ReactNode;
  labelProps?: TableCellProps;
  valueProps?: TableCellProps;
} & BoxProps) => {
  const {
    tooltip,
    label,
    labelProps,
    valueProps,
    children,
    ...rest
  } = props;

  return (
    <Table.Row className="VSplitTooltipList__Row" {...rest}>
      <Table.Cell className="VSplitTooltipList__Cell VSplitTooltipList__Label"
        {...labelProps} >
        {label}
      </Table.Cell>
      <Table.Cell
        className="VSplitTooltipList__Cell VSplitTooltipList__Tooltip"><Button icon="question" tooltip={tooltip} />
      </Table.Cell>
      <Table.Cell className="VSplitTooltipList__Cell VSplitTooltipList__Value"
        {...valueProps}>
        {children}
      </Table.Cell>
    </Table.Row>
  );
};

VSplitTooltipList.Entry = VSplitTooltipListEntry;

