import { Fragment } from 'inferno';
import { useBackend } from '../backend';
import { Window } from '../layouts';
import { Box, Button, LabeledList, ProgressBar, Section } from '../components';

export const SkillPanel = (props, context) => {
  const { act, data } = useBackend(context);
  const skills = data.skills || [];
  const see_mods = data.see_skill_mods;
  const skillgreen = {
    color: 'lightgreen',
    fontWeight: 'bold',
  };
  const skillyellow = {
    color: '#FFDB58',
    fontWeight: 'bold',
  };
  return (
    <Window>
      <Window.Content scrollable>
        <Section
          title={data.playername}
          buttons={(
            <Button
              icon={see_mods ? 'Enabled' : 'Disabled'}
              content={see_mods ? 'Modifiers Shown' : 'Modifiers Hidden'}
              onClick={() => act('toggle_mods')} />
          )}>
          <LabeledList>
            {skills.map(skill => (
              <LabeledList.Item key={skill.name} label={skill.name}>
                <span style={skillyellow}>
                  {skill.desc}
                  <br />
                  Modifiers: {skill.modifiers}
                </span>
                <br />
                {!!skill.level_based && (
                  <Box>
                    {see_mods ? (
                      <span>
                        Level: [
                        <span style={skill.mod_style}>
                          {skill.lvl_mod}
                        </span>]
                      </span>
                    ) : (
                      <span>
                        Level: [
                        <span style={skill.base_style}>
                          {skill.lvl_base}
                        </span>]
                      </span>
                    )}
                    <br />
                    Total Experience:
                    {see_mods ? (
                      <span>[{skill.value_mod} XP]</span>
                    ) : (
                      <span>[{skill.value_base} XP]</span>
                    )}
                    <br />
                    XP To Next Level:
                    {skill.max_lvl !== (see_mods
                      ? skill.lvl_mod_num
                      : skill.lvl_base_num) ? (
                        <Box inline>
                          {see_mods ? (
                            <span>{skill.xp_next_lvl_mod}</span>
                          ) : (
                            <span>{skill.xp_next_lvl_base}</span>
                          )}
                        </Box>
                      ) : (
                        <span style={skillgreen}>
                          [MAXXED]
                        </span>
                      )}
                  </Box>
                )}
                {see_mods ? (
                  <span>{skill.mod_readout}</span>
                ) : (
                  <span>{skill.base_readout}</span>
                )}
                {see_mods ? (
                  <ProgressBar
                    value={skill.percent_mod}
                    color="good" />
                ) : (
                  <ProgressBar
                    value={skill.percent_base}
                    color="good" />
                )}
                <br />
                {!!data.admin && (
                  <Fragment>
                    <Button
                      content="Adjust Exp"
                      onClick={() => act('adj_exp', {
                        skill: skill.path,
                      })} />
                    <Button
                      content="Set Exp"
                      onClick={() => act('set_exp', {
                        skill: skill.path,
                      })} />
                    {!!skill.level_based && (
                      <Button
                        content="Set Level"
                        onClick={() => act('set_lvl', {
                          skill: skill.path,
                        })} />
                    )}
                  </Fragment>
                )}
                <br />
                <br />
              </LabeledList.Item>
            ))}
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
