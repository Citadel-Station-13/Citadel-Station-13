import { decodeHtmlEntities } from 'common/string';
import { Component, Fragment } from 'inferno';
import { act } from '../byond';
import { Box, Button, Input, Section, Table, Tabs } from '../components';

// It's a class because we need to store state in the form of
// the current hovered item
export class Uplink extends Component {
  constructor() {
    super();
    this.state = {
      hoveredItem: {},
    };
  }

  setHoveredItem(hoveredItem) {
    this.setState({
      hoveredItem,
    });
  }

  render() {
    const { state } = this.props;
    const { config, data } = state;
    const { ref } = config;
    const {
      see_skill_mods,
      compact_mode,
      categories = [],
    } = data;
    return (
      <Section
        title={(
          <Box
            inline
            color={telecrystals > 0 ? 'good' : 'bad'}>
            {telecrystals} TC
          </Box>
        )}
        buttons={(
            <Button
              icon={see_skill_mods ? 'check-square-o' : 'square-o'}
              content='Show modifiers'}
              onClick={() => act(ref, 'toggle_mods')} />
            <Button
              icon={compact_mode ? 'list' : 'info'}
              content={compact_mode ? 'Compact' : 'Detailed'}
              onClick={() => act(ref, 'compact_toggle')} />
            )}
          </Fragment>
        )}>
        {(
          <Tabs vertical>
            {categories.map(category => {
              const { name, skills } = category;
              if (name != selected_category) {
                return;
              }
              return (
                <Tabs.Tab
                  key={name}
                  label={`${name} (${skills.length})`}>
                  {() => (
                    <skillList
                      compact={compact_mode}
                      skills={skills}
                      hoveredItem={hoveredItem}
                      onBuyMouseOver={skill => this.setHoveredItem(skill)}
                      onBuyMouseOut={skill => this.setHoveredItem({})}
                      onBuy={skill => act(ref, 'buy', {
                        skill: skill.name,
                      })} />
                  )}
                </Tabs.Tab>
              );
            })}
          </Tabs>
        )}
      </Section>
    );
  }
}

const skillList = props => {
  const {
    skills,
    hoveredItem,
    compact,
    onBuy,
    onBuyMouseOver,
    onBuyMouseOut,
  } = props;
  const hoveredCost = hoveredItem && hoveredItem.cost || 0;
  if (compact) {
    return (
      <Table>
        {items.map(item => {
          const notSameItem = hoveredItem && hoveredItem.name !== item.name;
          const notEnoughHovered = telecrystals - hoveredCost < item.cost;
          const disabledDueToHovered = notSameItem && notEnoughHovered;
          return (
            <Table.Row
              key={item.name}
              className="candystripe">
              <Table.Cell bold>
                {decodeHtmlEntities(item.name)}
              </Table.Cell>
              <Table.Cell collapsing textAlign="right">
                <Button
                  fluid
                  content={item.cost + " TC"}
                  disabled={telecrystals < item.cost || disabledDueToHovered}
                  tooltip={item.desc}
                  tooltipPosition="left"
                  onmouseover={() => onBuyMouseOver(item)}
                  onmouseout={() => onBuyMouseOut(item)}
                  onClick={() => onBuy(item)} />
              </Table.Cell>
            </Table.Row>
          );
        })}
      </Table>
    );
  }
  return items.map(item => {
    const notSameItem = hoveredItem && hoveredItem.name !== item.name;
    const notEnoughHovered = telecrystals - hoveredCost < item.cost;
    const disabledDueToHovered = notSameItem && notEnoughHovered;
    return (
      <Section
        key={item.name}
        title={item.name}
        level={2}
        buttons={(
          <Button
            content={item.cost + ' TC'}
            disabled={telecrystals < item.cost || disabledDueToHovered}
            onmouseover={() => onBuyMouseOver(item)}
            onmouseout={() => onBuyMouseOut(item)}
            onClick={() => onBuy(item)} />
        )}>
        {decodeHtmlEntities(item.desc)}
      </Section>
    );
  });
};
