import { decodeHtmlEntities } from 'common/string';
import { Component, Fragment } from 'inferno';
import { act } from '../byond';
import { Box, Button, Section, LabeledList, Table, Tabs, Tooltip } from '../components';

export const Skills = props => {
  const { state } = props;
  const { config, data } = state;
  const { ref } = config;
  const {
    name,
    compact_mode,
    selected_category,
    see_skill_mods,
    categories = [],
  } = props;
  return (
    <Section
      buttons={(
        <Fragment>
          <Button
            icon={see_skill_mods ? 'check-square-o' : 'square-o'}
            content={'Show modifiers'}
            onClick={() => act(ref, 'toggle_mods')} />
          <Button
            icon={compact_mode ? 'list' : 'info'}
            content={compact_mode ? 'Compact' : 'Detailed'}
            onClick={() => act(ref, 'compact_toggle')} />
        </Fragment>
      )}>
      {(
        <Tabs vertical>
          {categories.map(category => {
            const { name, skills } = category;
            if (name !== selected_category) {
              return (
                <Tabs.Tab
                  key={name}
                  label={`${name} (${skills.length})`}>
                </Tabs.Tab>
              );
            }
            return (
              <Tabs.Tab
                key={name}
                label={`${name} (${skills.length})`}>
                {() => (
                  <skillList
                    compact={compact_mode}
                    skills={skills}
                    see_mods={see_skill_mods}
                  />
                )}
              </Tabs.Tab>
            );
          })}
        </Tabs>
      )}
    </Section>
  );
};

const skillList = props => {
  const {
    compact,
    skills,
    see_mods,
  } = props;
  if (compact) {
    return (
      <Table>
        {skills.map(skill => {
          return (
            <Table.Row
              key={skill.name}
              className="candystripe">
              <Table.Cell bold>
                <Box color={skill.color}>
                  {decodeHtmlEntities(skill.name)}
                </Box>
              </Table.Cell>
              <Table.Cell collapsing textAlign="right">
                <Box mr={1}>
                  (see_mods
                    ? skill.skill_base
                    : skill.skill_mod
                  )
                  <Tooltip
                    content={
                    skill.mods_tooltip
                      ? (multiline`${skill.desc}
                        \nModifiers: 
                        ${skill.mods_tooltip}
                      `)
                      : multiline`${skill.desc}`
                    }
                    position="left"
                  />
                </Box>
              </Table.Cell>
            </Table.Row>
          );
        })}
      </Table>
    );
  }
  return skills.map(skill => {
    return (
      <Section
        key={skill.name}
        title={skill.name}
        level={2}
        buttons={(
          <Box mr={1}>
            content={
              see_mods
                ? skill.skill_base
                : skill.skill_mod
            }
          </Box>
        )}>
        {decodeHtmlEntities(skill.desc)}
        {skill.modifiers && (
          <LabeledList>
            <LabeledList.Item label="Current Modifiers">
              {skill.modifiers.map(modifier => {
                <Box className={modifier.icon_class} mr={1}>
                  <Tooltip
                    content={multiline`
                      "<b>"+modifier.name+"</b>\n"+modifier.desc
                    `}
                    position="relative"
                  />
                </Box>
              })}
            </LabeledList.Item>
          </LabeledList>
        )}
      </Section>
    );
  });
};
