/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { canRender, classes } from 'common/react';
import { Component, createRef, InfernoNode, RefObject } from 'inferno';
import { addScrollableNode, removeScrollableNode } from '../events';
import { BoxProps, computeBoxClassName, computeBoxProps } from './Box';

interface SectionProps extends BoxProps {
  className?: string;
  title?: string;
  buttons?: InfernoNode;
  fill?: boolean;
  fitted?: boolean;
  scrollable?: boolean;
  /** @deprecated This property no longer works, please remove it. */
  level?: boolean;
  /** @deprecated Please use `scrollable` property */
  overflowY?: any;
  /** Cit specific BANAID, used for custom colors in the title border */
  borderHexColor?: string;
}

export class Section extends Component<SectionProps> {
  scrollableRef: RefObject<HTMLDivElement>;
  scrollable: boolean;

  constructor(props) {
    super(props);
    this.scrollableRef = createRef();
    this.scrollable = props.scrollable;
  }

  componentDidMount() {
    if (this.scrollable) {
      addScrollableNode(this.scrollableRef.current);
    }
  }

  componentWillUnmount() {
    if (this.scrollable) {
      removeScrollableNode(this.scrollableRef.current);
    }
  }

  render() {
    const {
      className,
      title,
      buttons,
      fill,
      fitted,
      scrollable,
      children,
      // BANAID custom color for border (when title exists)
      borderHexColor,
      ...rest
    } = this.props;
    const hasTitle = canRender(title) || canRender(buttons);
    return (
      <div
        className={classes([
          'Section',
          Byond.IS_LTE_IE8 && 'Section--iefix',
          fill && 'Section--fill',
          fitted && 'Section--fitted',
          scrollable && 'Section--scrollable',
          className,
          computeBoxClassName(rest),
        ])}
        {...computeBoxProps(rest)}>
        {hasTitle && (
          <div
            className={borderHexColor ? undefined : "Section__title"}
            style={{ "border-bottom": borderHexColor ? `2px solid ${borderHexColor}` : undefined }}>
            <span className="Section__titleText">
              {title}
            </span>
            <div className="Section__buttons">
              {buttons}
            </div>
          </div>
        )}
        <div className="Section__rest">
          <div ref={this.scrollableRef} className="Section__content">
            {children}
          </div>
        </div>
      </div>
    );
  }
}
