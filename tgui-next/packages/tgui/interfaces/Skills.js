import { decodeHtmlEntities } from 'common/string';
import { Component, Fragment } from 'inferno';
import { act } from '../byond';
import { Box, Button, Section, Table, Tabs } from '../components';

export const Skills = props => {
  const { state } = props;
  const { config, data } = state;
  const { ref } = config;
  const {
    name,
    compact_mode,
    selected_category,
    categories = [],
  } = props;
  return (
    <Section
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
            return (
              <Tabs.Tab
                key={name}
                label={`${name} (${skills.length})`}>
				if (name != selected_category) {
                  {() => (
                    <skillList
                      compact={compact_mode}
                      skills={skills}
					  see_mods={see_skill_mods}
                    />
                  )}
				}
              </Tabs.Tab>
            );
          })}
        </Tabs>
      )}
    </Section>
  );
}

const skillList = props => {
  const {
    compact,
    skills,
	see_mods
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
                <Box color=skill.color>
                  {decodeHtmlEntities(skill.name)}
                </Box>
              </Table.Cell>
              <Table.Cell collapsing textAlign="right">
                <Button
                  fluid
                  content={see_mods
                    ? skill.skill_base
                    : skill.skill_mod
                  }
                  tooltip={skill.mods_tooltip
                    ? (skill.desc
                      + "\nModifiers: "
                      + skill.mods_tooltip
                    )
                    : skill.desc
                  }
                  tooltipPosition="left"
                />
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
          <Button
            content={see_mods
              ? skill.skill_base
              : skill.skill_mod
            }
          />
        )}>
        {decodeHtmlEntities(skill.desc)}
        modifiers:
        {skill.modifiers.map(modifier => {
          <Button
            textAlign="center"
            color="transparent"
            tooltip={
              "<b>"+modifier.name+"</b>\n"+modifier.desc
            }
            <Box className={modifier.icon_class} />
          />
        })}
      </Section>
    );
  });
};
